# PureAmp — Troubleshooting Guide

## 1. Initial Diagnostics

Before troubleshooting, confirm that:

- Your device is rooted through Magisk.
- PureAmp is installed and enabled.
- The device has been rebooted after installation.
- Poweramp, or your customized target player, is installed.
- USB debugging is enabled.
- HiBy Music has not been disabled or uninstalled.

## 2. Verify ADB Connectivity

Connect your HiBy R4 to your computer and execute:

```powershell
.\adb devices
```

If the device appears as unauthorized, unlock the device and approve the USB debugging authorization request.

If the authorization prompt does not appear, revoke USB debugging authorizations in Developer Options, reconnect the device, and restart the ADB server:

```powershell
.\adb kill-server
.\adb start-server
```

## 3. Verify Root Access

```powershell
.\adb shell su -c id
```

Expected output includes:

```text
uid=0(root) gid=0(root)
```

If root access fails, verify your Magisk installation and superuser permissions.

Refer to [ROOTING.md](ROOTING.md) for additional information.

## 4. Retrieve PureAmp Diagnostic Logs

PureAmp maintains a local diagnostic log inside its Magisk module directory.

```powershell
.\adb shell su -c "cat /data/adb/modules/pureamp/pureamp.log"
```

A successful mode transition should produce output similar to:

```text
Service started: uid=0(root)
Mode: android -> music
Launching Poweramp
Status: ok
Launch exit=0
Verified Poweramp foreground
```

The diagnostic log is reset when the service starts after reboot.

PureAmp does not transmit diagnostic information to external servers.

## 5. Poweramp Does Not Launch Automatically

Verify the current working mode:

```powershell
.\adb shell settings get global work_mode
```

Expected values:

- android: Normal Android Mode.
- music: Pure Audio Mode.

Check whether the module is installed:

```powershell
.\adb shell su -c "ls -la /data/adb/modules/pureamp"
```

Check whether the background service is running:

```powershell
.\adb shell su -c "ps -A -o LABEL,PID,PPID,USER,ARGS" | Select-String "pureamp"
```

If the service is not running, confirm that the module is enabled in Magisk and reboot the device.

## 6. Manually Test the Player

While in Pure Audio Mode, execute:

```powershell
.\adb shell am start -W -n com.maxmpz.audioplayer/.standard_adaptive
```

Verify that the device remains in Pure Audio Mode:

```powershell
.\adb shell settings get global work_mode
```

Verify that Poweramp is running:

```powershell
.\adb shell pidof com.maxmpz.audioplayer
```

Verify foreground ownership:

```powershell
.\adb shell dumpsys activity activities | Select-String "mResumedActivity:"
```

If the manual launch succeeds but automatic launching fails, retrieve the PureAmp diagnostic log and include it in your issue report.

## 7. Binder Transaction Failure

### Symptoms

```text
cmd: Failure calling service activity:
Failed transaction (2147483646)
```

### Cause

During development of PureAmp v0.1.0, Android's Binder shell-command mechanism encountered an SELinux denial when command output was redirected directly into the module's diagnostic log.

### Resolution

This issue was corrected in v0.1.1 by capturing command output through a pipe before writing it to the protected log file.

Update to a newer PureAmp release.

Do not disable SELinux or modify Android security policies to address this problem.

## 8. Error Type 3 — Activity Does Not Exist

### Symptoms

```text
Error type 3
Error: Activity class does not exist.
```

### Possible Causes

- The selected music player is not installed.
- The launcher activity has changed.
- An application update has changed the active launcher alias.
- Android has not completed application or user initialization.

This error was observed during direct boot into Pure Audio Mode during development.

### Resolution

Verify the installed package:

```powershell
.\adb shell pm path com.maxmpz.audioplayer
```

Resolve the currently available launcher activity:

```powershell
.\adb shell cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -p com.maxmpz.audioplayer
```

PureAmp v0.1.3 introduced dynamic launcher resolution and application readiness checks during startup recovery.

If you are using a customized player, verify its package name and launcher activity against your installed application.

Refer to [CUSTOM_PLAYER.md](CUSTOM_PLAYER.md).

## 9. HiBy Music Reclaims the Foreground After Reboot

### Symptoms

Poweramp opens during startup, but HiBy Music subsequently returns to the foreground.

### Cause

This behavior was observed during development and is consistent with overlapping Android and HiBy initialization routines.

### Resolution

PureAmp v0.1.3 includes adaptive boot recovery designed to address this condition.

Allow the startup recovery window to complete before evaluating the result.

The reference implementation uses:

- A 20-second initial settling period.
- A 120-second startup recovery window.
- A maximum of three boot launch attempts.

If the problem persists, switch back to Android Mode and then return to Pure Audio Mode.

Retrieve the module log before rebooting again.

## 10. HiBy Music Appears Briefly Before Poweramp

This is expected behavior.

PureAmp preserves HiBy's original mode transition and allows its cleanup routine to complete before launching Poweramp.

PureAmp does not replace HiBy Music or modify the native mode selector.

The brief appearance of HiBy Music is not considered a defect.

## 11. Music Stops When Switching Modes

HiBy's native mode transition may force-stop applications, including Poweramp.

PureAmp subsequently relaunches the selected player.

Uninterrupted playback across mode transitions is not guaranteed.

Depending on your player's configuration, playback may need to be resumed manually.

## 12. Alternative Music Player Does Not Work

Successfully launching an application does not guarantee full compatibility with Pure Audio Mode.

Some applications depend on:

- Google Play Services.
- Network connectivity.
- Authentication services.
- Additional background processes.
- Application-specific audio frameworks.

Verify the player's functionality manually before modifying PureAmp.

Poweramp is the original reference player. Other players require independent testing.

## 13. Emergency Disable and Recovery

If PureAmp behaves unexpectedly, disable it through Magisk and reboot.

If the graphical interface is unavailable but ADB and root remain accessible, execute:

```powershell
.\adb shell su -c "touch /data/adb/modules/pureamp/disable"
.\adb reboot
```

This disables PureAmp without intentionally affecting other installed Magisk modules.

If ADB and root are unavailable, refer to the recovery documentation in our original project:

[HiBy R4 Android Auto Enabler](https://github.com/oslara/HiBy-R4-Android-Auto)

Do not flash firmware or boot images from an incompatible device or firmware version.

## 14. Reporting an Issue

Please include:

- Device model.
- HiBy firmware version.
- Android version.
- Magisk version.
- PureAmp version.
- Music player name and version.
- Description of the problem.
- Steps to reproduce the problem.
- Expected and actual behavior.
- Relevant sanitized PureAmp diagnostic logs.

Before submitting any Android system logs, remove account information, authentication tokens, device identifiers, and other personal information.

Do not upload proprietary firmware binaries.

## 15. Known Limitations

- Battery consumption has not been independently benchmarked.
- Audio quality improvements are not guaranteed.
- Compatibility with other devices and music players remains subject to testing.
- Startup timing may vary between firmware versions.
- PureAmp requires root access.
- PureAmp does not continuously enforce foreground ownership.

Community contributions and reproducible bug reports are welcome.

---

**Every bug is an opportunity to understand the machine a little better.**

**Your music. Your player. Your freedom.**

*A Technomancer Sisters project.*
