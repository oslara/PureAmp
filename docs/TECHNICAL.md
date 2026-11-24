# PureAmp — Technical Documentation

## 1. Project Background

PureAmp originated from an investigation into the HiBy R4's native Pure Audio Mode and its restriction to HiBy Music.

Although the device continues to operate on Android while in Pure Audio Mode, the firmware restricts application navigation, terminates other applications during mode transitions, and automatically launches HiBy Music.

Our objective was to determine whether an alternative music player could operate within this native mode without replacing firmware components or modifying Android's security policies.

Poweramp was selected as the reference implementation.

## 2. Reference Environment

| Component | Configuration |
|---|---|
| Device | HiBy R4 |
| Android | Android 12 |
| Android build | SKQ1.211006.001 dev-keys |
| Root framework | Magisk |
| Reference player | Poweramp |
| Player package | com.maxmpz.audioplayer |
| Launcher component | com.maxmpz.audioplayer/.standard_adaptive |

Additional devices and firmware versions require independent validation.

## 3. Reconnaissance Methodology

The initial investigation compared the device's state before and after entering Pure Audio Mode.

The following information was collected through ADB:

- Android global, system, and secure settings.
- System properties.
- Running processes.
- Installed packages.
- Activity Manager state.
- Android services.
- Media sessions.
- Audio subsystem state.
- System logs during mode transitions.

This allowed us to identify the operational differences between normal Android Mode and Pure Audio Mode.

## 4. Native Working Mode

The HiBy R4 exposes its current working mode through an Android global setting:

```sh
settings get global work_mode
```

Observed values:

| Value | Operating mode |
|---|---|
| android | Normal Android Mode |
| music | Pure Audio Mode |

Changing modes does not require rebooting the device or loading a separate operating system.

The global setting provides PureAmp with a lightweight mechanism for detecting mode transitions without modifying the firmware.

## 5. Firmware Investigation

Selected firmware components were extracted from the reference device for local analysis.

These included:

- Settings.apk
- services.jar
- framework.jar
- SystemUI.apk
- HiByMusic.apk
- Launcher3QuickStep.apk

Inspection of compiled Android bytecode revealed several relevant classes and methods.

| Component | Identified method |
|---|---|
| Settings.apk | WorkModeDashboardFragment.setDefaultKey() |
| Settings.apk | WorkModeDashboardFragment.startHiBy() |
| services.jar | ActivityTaskManagerService.killAllTasks() |
| services.jar | ActivityTaskManagerService.killAssignPkg() |
| services.jar | PhoneWindowManager.isMusicMode() |
| services.jar | DisplayPolicy.checkHiByActivity() |
| SystemUI.apk | WorkModeTile |

The inspected bytecode contained hardcoded references to HiBy Music and Android Launcher packages.

The following broadcast action was also identified:

```text
android.intent.hiby_music
```

A corresponding receiver in the Android window-management policy contained a reference to:

```text
hibyandapp://hibymusic/view
```

These findings indicate that HiBy's Pure Audio Mode is integrated into multiple Android framework and system application components.

The investigation identified relevant bytecode references and observed behavior. It was not a complete reconstruction of HiBy's proprietary source code.

No proprietary firmware binaries are distributed with PureAmp.

## 6. Application Termination

During a normal transition into Pure Audio Mode, Android logs confirmed that Poweramp was explicitly force-stopped.

A sanitized example:

```text
ActivityManager: Force stopping com.maxmpz.audioplayer

ActivityManager: Killing com.maxmpz.audioplayer
```

Further investigation established that Poweramp remained installed, enabled, visible, and unsuspended after the transition.

The application was stopped, rather than removed or permanently disabled.

This distinction became the foundation of our solution.

## 7. The Breakthrough

After allowing HiBy's native transition routine to complete, we explicitly launched Poweramp through ADB:

```powershell
.\adb shell am start -W -n com.maxmpz.audioplayer/.standard_adaptive
```

The launch succeeded.

We then verified the working mode:

```powershell
.\adb shell settings get global work_mode
```

The device continued to report:

```text
music
```

Android Activity Manager also confirmed that Poweramp owned the resumed foreground activity.

Functional testing established that Poweramp could operate within native Pure Audio Mode, including playback, physical media controls, volume adjustment, library navigation, equalization, and screen-off playback.

Home and Recent Apps restrictions remained active.

This demonstrated that replacing core Android framework components was unnecessary for our reference implementation.

## 8. PureAmp Architecture

PureAmp operates as a Magisk background service.

Its primary responsibilities are:

1. Wait for Android boot completion.
2. Monitor the native work_mode setting.
3. Detect entry into Pure Audio Mode.
4. Allow HiBy's transition routine to complete.
5. Launch the designated music player.
6. Verify foreground ownership.
7. Return to passive mode monitoring.

Normal operation does not continuously force the selected player into the foreground.

PureAmp does not modify the working mode setting itself.

The original HiBy controls remain responsible for entering and exiting Pure Audio Mode.

## 9. Binder Transaction Failure

The first automated implementation encountered the following error:

```text
cmd: Failure calling service activity:
Failed transaction (2147483646)
```

Manual launches through ADB succeeded, including launches executed with Magisk root privileges.

SELinux audit logs subsequently revealed a denial involving the module's diagnostic log:

```text
avc: denied { append }
comm="cmd"
path="/data/adb/modules/pureamp/pureamp.log"
scontext=u:r:system_server:s0
```

The original implementation redirected Android's command output directly into a file within the Magisk module directory.

The evidence indicated that Android's Binder shell-command mechanism could not use the supplied output file descriptor under the existing SELinux policy.

The correction captured command output through a pipe before allowing the Magisk shell to write it into the module's log.

Subsequent automated launches succeeded.

This correction required no SELinux policy modification.

## 10. Adaptive Boot Recovery

Rebooting directly into Pure Audio Mode exposed additional startup conditions:

- HiBy Music could reclaim the foreground after Poweramp had launched.
- Poweramp's launcher activity could be temporarily unavailable.
- Android could report a successful command exit code despite an activity launch error.
- The Android Launcher could remain in the foreground after a failed launch.

PureAmp v0.1.3 introduced adaptive startup recovery to address these conditions.

The implementation includes:

- An initial boot settling period.
- Android user readiness verification.
- Dynamic launcher activity resolution.
- Launch error output inspection.
- Independent foreground verification.
- Bounded startup recovery attempts.
- A finite startup recovery window.

Normal mode transitions retain the original short delay.

Startup monitoring is not intended to operate as a permanent foreground enforcement mechanism.

## 11. Design Parameters

| Parameter | Reference implementation |
|---|---|
| Mode polling interval | 3 seconds |
| Normal transition delay | 5 seconds |
| Initial boot settling period | 20 seconds |
| Boot recovery window | 120 seconds |
| Maximum boot launch attempts | 3 |

These values are engineering choices based on prototype testing, not documented HiBy firmware requirements.

Future versions may refine these parameters based on community testing.

## 12. Audio Processing

Poweramp's audio information was compared while operating in normal Android Mode and Pure Audio Mode.

Under the tested configuration, both modes reported identical:

- Source format and resolution.
- Resampling configuration.
- DSP processing.
- Equalizer settings.
- Output engine.
- Output sample rate.
- Output bit depth.
- Reported audio latency.

The reference configuration used Poweramp's Hi-Res DAP HiBy output at 192 kHz and 32-bit output.

These observations suggest that PureAmp preserves Poweramp's existing digital audio processing configuration.

However, they do not constitute laboratory measurements of analog audio quality.

PureAmp does not claim to improve sound quality, achieve bit-perfect playback, reduce electrical noise, or extend battery life.

Controlled resource consumption and battery benchmarks remain future research objectives.

## 13. Security and Design Principles

PureAmp deliberately avoids:

- Android framework replacements.
- Firmware partition modifications.
- SELinux policy changes.
- Poweramp APK modifications.
- Application licensing modifications.
- Additional framework dependencies.
- Network communication.
- Advertising and telemetry.

PureAmp runs with root privileges through Magisk. Users should inspect the source code and understand the implications of installing root-level software.

The project distributes only its original implementation and documentation.

## 14. Known Limitations

- Poweramp is terminated during the initial native mode transition and subsequently relaunched.
- HiBy Music may appear briefly before Poweramp takes over.
- Uninterrupted playback across mode transitions is not guaranteed.
- Startup behavior may vary across firmware versions.
- Other music players may require different application dependencies.
- Polling service battery consumption has not been measured.
- Compatibility outside the reference HiBy R4 environment remains unverified.

## 15. Related Projects

Our previous HiBy R4 Android Auto modification is available at:

[HiBy R4 Android Auto Enabler](https://github.com/oslara/HiBy-R4-Android-Auto)

Both projects demonstrate different approaches to extending the functionality of the HiBy R4 while preserving its original firmware.

## 16. Community Research

PureAmp encourages independent investigation, reproducible experiments, and community contributions.

We welcome additional findings regarding:

- Alternative music players.
- Other HiBy devices.
- Firmware compatibility.
- Startup behavior.
- Audio processing.
- Resource consumption.
- More efficient mode detection mechanisms.

Please sanitize all diagnostic logs before publishing them.

Do not distribute proprietary firmware components, authentication tokens, account information, or personal data.

---

**Curiosity. Evidence. Experimentation.**

**Your hardware. Your rules. Your responsibility.**

*A Technomancer Sisters project.*

Research initiated November 24, 2026.
