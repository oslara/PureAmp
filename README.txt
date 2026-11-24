PureAmp v0.1.3 — experimental HiBy R4 Android 12 / Magisk.
Install over v0.1.2 in Android Mode, then reboot.
Normal mode: existing 5-second delay and explicit launcher alias.
Boot into music: wait at least 20 seconds, check user 0 unlocked and resolve launcher dynamically. Up to three launch attempts, separated by at least 10 seconds, within 120 seconds of initial detection. Recover only from HiBy Music, Android launcher or no reported resumed activity. No continuous enforcement after window. Android Mode cancels recovery. No direct MainActivity fallback (not yet validated).
Launch output captured through a pipe; errors checked independently of exit status. No firmware or SELinux changes. Battery impact unmeasured. Host syntax checked; device testing pending.
Log: /data/adb/modules/pureamp/pureamp.log
Rollback: disable PureAmp in Magisk and reboot.
