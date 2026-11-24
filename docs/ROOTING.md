# PureAmp — Rooting Prerequisites

## Overview

PureAmp requires root access through Magisk to operate its background service and automatically launch an alternative music player within HiBy's native Pure Audio Mode.

PureAmp does not root your device.

## Existing Rooting Documentation

As part of our previous HiBy R4 Android Auto project, we documented the rooting process, boot image safety, and recovery considerations.

Please refer to the original repository:

**[HiBy R4 Android Auto Enabler](https://github.com/oslara/HiBy-R4-Android-Auto)**

Follow the rooting and recovery documentation appropriate to your installed firmware.

Installing the Android Auto Enabler module is not required to use PureAmp.

Both projects operate independently and have been tested together on our reference HiBy R4.

## Android Platform Tools

Download the official Android SDK Platform Tools directly from Google:

https://developer.android.com/tools/releases/platform-tools

These tools provide ADB and Fastboot, which are useful for installation, diagnostics, customization, and recovery.

## Verifying Root Access

Before installing PureAmp, connect your device to your computer with USB debugging enabled.

From PowerShell, inside your platform-tools directory, execute:

```powershell
.\adb devices
.\adb shell su -c id
```

A successful root verification should return an output containing:

```text
uid=0(root) gid=0(root)
```

If Magisk requests superuser authorization, review and approve the request.

## Safety Considerations

- Always verify your exact device model and firmware version.
- Never flash a boot image intended for a different firmware version.
- Maintain a backup of your original boot image.
- Understand the recovery procedure before modifying your device.
- Do not disable SELinux.
- Do not install unverified firmware images.
- Rooting may affect OTA updates, warranty coverage, security, and application compatibility.

PureAmp itself does not replace firmware components, patch the Android framework, or modify SELinux policies.

## The DIY Philosophy

PureAmp is designed for enthusiasts who enjoy understanding, modifying, and experimenting with their own hardware.

Rooting is not simply an installation prerequisite. It is an opportunity to understand how your device operates and what becomes possible when you gain greater control over it.

We encourage users to read the documentation, inspect the source code, ask questions, and share their discoveries.

Experiment responsibly.

---

**Your hardware. Your rules. Your responsibility.**

*A Technomancer Sisters project.*
