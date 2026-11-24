# PureAmp — Installation Guide

## 1. Requirements

- HiBy R4 running Android 12.
- Root access through Magisk.
- Poweramp installed and configured.
- Sufficient battery charge before installation.
- Basic familiarity with ADB and Android modification.

PureAmp does not include Poweramp or modify its licensing requirements.

## 2. Rooting your device

If your HiBy R4 is not already rooted, please refer to our original project:

[HiBy R4 Android Auto — Rooting and Recovery Documentation](https://github.com/oslara/HiBy-R4-Android-Auto)

Read the rooting and recovery documentation carefully.

You do not need to install the Android Auto module to use PureAmp. Both modules operate independently.

## 3. Installation

1. Download the latest PureAmp module ZIP from the [Releases page](https://github.com/oslara/PureAmp/releases).
2. Transfer the ZIP file to your HiBy R4.
3. Switch the device to normal Android Mode.
4. Open Magisk.
5. Navigate to Modules.
6. Select Install from storage.
7. Select the PureAmp ZIP file.
8. Allow the installation to complete.
9. Reboot your device.

Do not extract the installation ZIP before installing it through Magisk.

## 4. Using PureAmp

Once your device has rebooted:

1. Open the Quick Settings panel.
2. Select Pure Audio Mode.
3. Allow HiBy Music to initialize.
4. PureAmp will automatically launch Poweramp after a short delay.

The temporary appearance of HiBy Music is expected behavior.

To return to normal Android operation, switch back to Android Mode using the original HiBy controls.

## 5. Booting into Pure Audio Mode

PureAmp includes adaptive startup recovery.

When rebooting directly into Pure Audio Mode, the module allows additional time for Android and Poweramp to initialize.

Poweramp may take longer to appear than during a normal mode transition.

The module does not continuously force Poweramp into the foreground after the startup recovery period.

## 6. Updating PureAmp

1. Return to Android Mode.
2. Download the newer module release.
3. Install it through Magisk.
4. Reboot.

Uninstalling the previous version is not normally required.

## 7. Uninstalling PureAmp

1. Open Magisk.
2. Navigate to Modules.
3. Locate PureAmp.
4. Disable or remove the module.
5. Reboot.

PureAmp does not replace original firmware files or modify SELinux policies. Removing the module should restore the original Pure Audio Mode behavior.

## 8. Important notes

- Do not uninstall or disable HiBy Music.
- Poweramp is the currently tested reference player.
- Other firmware versions, devices, and music applications require independent testing.
- Audio quality and battery-life improvements are not guaranteed.
- Always maintain appropriate backups and understand the device recovery process.

PureAmp is provided as-is, without warranty.

---

**Your music. Your player. Your freedom.**

*A Technomancer Sisters project.*
