#!/system/bin/sh
MODDIR=${0%/*}
LOG="$MODDIR/pureamp.log"
log_msg() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG"; }
# One small log per boot.
: > "$LOG"
DELAY=5
POLL=3
# Fixed target, no executable configuration.
TARGET=com.maxmpz.audioplayer/.standard_adaptive
while [ "$(getprop sys.boot_completed)" != 1 ]; do
    [ ! -e "$MODDIR/disable" ] && [ ! -e "$MODDIR/remove" ] || exit 0
    sleep 5
done
log_msg "Service started: $(id)"
last=unknown
boot_pending=1
boot_end=0
attempts=0
last_attempt=0
uptime_seconds() { read -r up rest < /proc/uptime; echo "${up%%.*}"; }
active() { [ ! -e "$MODDIR/disable" ] && [ ! -e "$MODDIR/remove" ]; }
in_music() { [ "$(settings get global work_mode 2>/dev/null)" = music ]; }
foreground() { dumpsys activity activities 2>/dev/null | grep -E 'mResumedActivity:'; }
player_visible() { foreground | grep -q 'com\.maxmpz\.audioplayer/'; }
resolve_player() {
    /system/bin/cmd package resolve-activity --brief --user 0 -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -p com.maxmpz.audioplayer 2>/dev/null | grep -E '^com\.maxmpz\.audioplayer/[A-Za-z0-9_.$]+$' | tail -n 1
}
launch_player() {
    active && in_music || return 1
    log_msg "Launching Poweramp: $1"
    output=$(/system/bin/am start --user 0 -W -n "$1" </dev/null 2>&1)
    rc=$?
    printf '%s\n' "$output" >> "$LOG"
    log_msg "Launch exit=$rc"
    if [ "$rc" -ne 0 ] || printf '%s\n' "$output" | grep -Ei 'Error type|Error:|Exception|Failed transaction|Failure calling' >/dev/null; then
        log_msg 'Launch reported failure'
        return 1
    fi
    sleep 2
    if active && in_music && player_visible; then
        log_msg 'Verified Poweramp foreground'
        return 0
    fi
    log_msg 'Poweramp foreground not verified'
    return 1
}
while active; do
    mode=$(settings get global work_mode 2>/dev/null)
    case "$mode" in android|music) ;; *) sleep "$POLL"; continue ;; esac
    if [ "$mode" != "$last" ]; then
        log_msg "Mode: $last -> $mode"
        last=$mode
        if [ "$mode" = android ]; then
            boot_pending=0
            boot_end=0
        elif [ "$boot_pending" = 1 ]; then
            boot_pending=0
            boot_start=$(uptime_seconds)
            boot_end=$((boot_start + 120))
            log_msg 'Boot into music: readiness checks; 120-second startup window'
        else
            remaining=$DELAY
            while [ "$remaining" -gt 0 ]; do
                active || exit 0
                in_music || break
                sleep 1
                remaining=$((remaining - 1))
            done
            if [ "$remaining" -ne 0 ] || ! in_music; then last=unknown; continue; fi
            if ! player_visible; then launch_player "$TARGET"; fi
        fi
    fi
    if [ "$boot_end" -gt 0 ]; then
        now=$(uptime_seconds)
        if [ "$now" -ge "$boot_end" ] || [ "$attempts" -ge 3 ]; then
            log_msg "Boot recovery ended; attempts=$attempts"
            boot_end=0
        elif active && in_music && [ "$((now - boot_start))" -ge 20 ] && [ "$((now - last_attempt))" -ge 10 ]; then
            fg=$(foreground)
            case "$fg" in
                *com.maxmpz.audioplayer/*) ;;
                *com.hiby.music/*|*com.android.launcher3/*|'')
                    if dumpsys user 2>/dev/null | grep -F '0=RUNNING_UNLOCKED' >/dev/null; then
                        component=$(resolve_player)
                        if [ -n "$component" ]; then
                            active && in_music || continue
                            attempts=$((attempts + 1))
                            last_attempt=$now
                            log_msg "Boot launch attempt $attempts; resolved=$component"
                            launch_player "$component"
                        else
                            log_msg 'Boot waiting: launcher not resolved'
                        fi
                    else
                        log_msg 'Boot waiting: user 0 not confirmed unlocked'
                    fi ;;
                *) ;; # Do not interrupt unrelated foreground activities.
            esac
        fi
    fi
    sleep "$POLL"
done
