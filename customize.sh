#!/system/bin/sh
SKIPMOUNT=true
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true
ui_print '- PureAmp v0.1.3 experimental build'
ui_print '- Checking Android API and Poweramp installation'
[ "$(getprop ro.build.version.sdk)" = 31 ] || abort '! Expected Android 12 (API 31)'
pm path com.maxmpz.audioplayer >/dev/null 2>&1 || abort '! Poweramp is not installed'
case "$(settings get global work_mode 2>/dev/null)" in
    android|music) ;;
    *) abort '! HiBy work_mode setting not recognized' ;;
esac
set_perm "$MODPATH/service.sh" 0 0 0755
ui_print '- No system files will be replaced'
