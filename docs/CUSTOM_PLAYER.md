# PureAmp — Choose Your Own Player

## 1. Introduction

Poweramp is our original reference implementation, but PureAmp's underlying mechanism is not exclusive to Poweramp.

PureAmp detects HiBy's native Pure Audio Mode and launches a designated Android application after the firmware completes its mode transition.

With a few source code modifications, enthusiasts can experiment with their preferred music players.

This is part of the appeal of PureAmp: understanding the technology, experimenting with it, and making it your own.

## 2. Find Your Player's Package Name

Connect your HiBy R4 to your computer with USB debugging enabled.

From your ADB platform-tools directory, execute:

```powershell
.\adb shell pm list packages -3
```

This lists installed third-party applications.

Some candidate music player package names are:

| Player | Package name |
|---|---|
| Poweramp | com.maxmpz.audioplayer |
| USB Audio Player PRO | com.extreamsd.usbaudioplayerpro |
| Neutron | com.neutroncode.mp |
| Musicolet | in.krosbits.musicolet |
| AIMP | com.aimp.player |
| Spotify | com.spotify.music |
| Tidal | com.aspiro.tidal |

These are reference identifiers. Verify the actual package name installed on your device.

Only Poweramp has been validated by the PureAmp project at this stage.

## 3. Identify the Launcher Activity

Replace PACKAGE_NAME with your selected application's package name:

```powershell
.\adb shell cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -p PACKAGE_NAME
```

For Poweramp, our reference device returns:

```text
com.maxmpz.audioplayer/.standard_adaptive
```

Your preferred player will have a different package and potentially a different activity name.

## 4. Test Before Modifying PureAmp

Temporarily disable PureAmp in Magisk and reboot.

Switch to Pure Audio Mode using the original HiBy controls.

After HiBy Music opens, explicitly launch your preferred application:

```powershell
.\adb shell am start -W -n PACKAGE_NAME/ACTIVITY_NAME
```

Confirm that Pure Audio Mode remains active:

```powershell
.\adb shell settings get global work_mode
```

Expected result:

```text
music
```

If your application opens and functions normally while this setting remains unchanged, it may be a suitable candidate for PureAmp.

A successful launch alone does not guarantee full compatibility.

## 5. Customize the Module Source

Download and extract the PureAmp module ZIP.

Use a plain-text editor such as Visual Studio Code or Notepad++.

### service.sh

Update the TARGET variable:

```sh
TARGET=com.maxmpz.audioplayer/.standard_adaptive
```

Replace the entire component with the launcher component discovered in Section 3.

Replace all other references to the original Poweramp package:

```text
com.maxmpz.audioplayer
```

Also update the escaped package references used in regular expressions:

```text
com\.maxmpz\.audioplayer
```

Preserve the regular expression escaping when substituting your own package name.

These references are used for:

- Foreground activity detection.
- Dynamic launcher resolution.
- Boot recovery.
- Application launch verification.

You may also replace Poweramp-specific logging messages with your preferred player's name.

Do not modify the HiBy Music or Android Launcher package references. They are part of the startup recovery mechanism.

### customize.sh

Locate the installation check:

```sh
pm path com.maxmpz.audioplayer >/dev/null 2>&1 || abort '! Poweramp is not installed'
```

Replace the package name with your preferred player's package name.

Update the corresponding installation messages.

### module.prop

Optionally update the module description to reflect your preferred player.

Keep the original module ID if you intend your customized version to replace the existing PureAmp installation.

## 6. Repackage and Install

Preserve the original module directory structure.

Ensure that shell scripts use Unix LF line endings and are saved without a byte order mark (BOM).

Create a new ZIP archive containing the module files directly at its root, rather than inside an additional parent directory.

Install your customized ZIP through Magisk and reboot.

Refer to the [Installation Guide](INSTALL.md) for additional instructions.

## 7. Compatibility Testing

Test the following before considering your player compatible:

- Automatic launch when entering Pure Audio Mode.
- Music playback.
- Physical playback controls.
- Volume controls.
- Album and folder navigation.
- Screen-off playback.
- Lock and unlock behavior.
- Return to Android Mode.
- Repeated mode switching.
- Reboot directly into Pure Audio Mode.
- Continued operation after the startup recovery window.

Streaming applications may have additional dependencies, including network connectivity, authentication, Google Play Services, and background processes.

PureAmp does not guarantee bit-perfect playback or improvements in audio quality or battery consumption.

## 8. Share Your Results

We encourage users to submit their discoveries through GitHub Issues or Pull Requests.

Include:

- Device model.
- Firmware version.
- Android version.
- Magisk version.
- Music player name and version.
- Package name.
- Launcher activity.
- Successful and unsuccessful tests.
- Relevant sanitized diagnostic logs.

Never include account credentials, authentication tokens, personal information, or proprietary firmware binaries.

Help us build a community-driven compatibility database.

## 9. Experiment Responsibly

PureAmp is free and open source.

There are no advertisements, subscriptions, activation requirements, or restrictions preventing you from customizing our original code.

Other music applications retain their own licensing requirements.

You are encouraged to experiment, modify, improve, and share your findings.

---

**Your music. Your player. Your freedom.**

*A Technomancer Sisters project.*
