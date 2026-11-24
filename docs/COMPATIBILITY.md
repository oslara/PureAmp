# PureAmp — Compatibility Database

## 1. Overview

PureAmp was originally developed and tested on the HiBy R4 using Poweramp as its reference music player.

Although the underlying implementation may support other Android music applications and digital audio players, compatibility must be established through independent testing.

This document is intended to evolve through community contributions.

## 2. Reference Environment

| Component | Configuration |
|---|---|
| Device | HiBy R4 |
| Android version | Android 12 |
| Android build | SKQ1.211006.001 dev-keys |
| Root framework | Magisk |
| PureAmp version | v0.1.3 |
| Reference player | Poweramp |
| Player package | com.maxmpz.audioplayer |
| Launcher activity | .standard_adaptive |

## 3. Compatibility Status Definitions

- **Validated:** Successfully tested functionality in the documented environment.
- **Partial:** Some functionality works, but limitations have been identified.
- **Incompatible:** Testing identified issues preventing normal operation.
- **Untested:** No compatibility results are currently available.
- **Experimental:** Initial testing is promising, but additional validation is required.

Untested does not mean incompatible.

## 4. Device Compatibility

| Device | Status | Notes |
|---|---|---|
| HiBy R4 | Validated | Original reference device |
| HiBy R4 Evangelion Edition | Untested | Independent validation required |
| HiBy R6 series | Untested | Firmware investigation required |
| HiBy R8 series | Untested | Firmware investigation required |
| Other HiBy Android DAPs | Untested | Community testing encouraged |
| Other manufacturers | Untested | May use different operating mode mechanisms |

Do not assume that devices sharing similar hardware or Android versions implement Pure Audio Mode identically.

## 5. Music Player Compatibility

| Music player | Status | Notes |
|---|---|---|
| Poweramp | Validated | Original reference implementation |
| USB Audio Player PRO | Untested | Customization required |
| Neutron Music Player | Untested | Customization required |
| Musicolet | Untested | Customization required |
| AIMP | Untested | Customization required |
| foobar2000 | Untested | Customization required |
| VLC | Untested | Customization required |
| Spotify | Untested | Network and service dependencies |
| Tidal | Untested | Network and authentication dependencies |
| Qobuz | Untested | Network and authentication dependencies |
| Apple Music | Untested | Network and authentication dependencies |
| Other Android music players | Untested | Community testing encouraged |

Refer to [CUSTOM_PLAYER.md](CUSTOM_PLAYER.md) for instructions on adapting PureAmp to another music application.

PureAmp does not bypass or modify third-party application licensing requirements.

## 6. Reference Functional Testing

The following functionality has been demonstrated with Poweramp on our reference HiBy R4 during development:

| Functionality | Result |
|---|---|
| Native Pure Audio Mode preserved | Pass |
| Automatic player launch | Pass |
| Local music playback | Pass |
| Physical play/pause controls | Pass |
| Physical next/previous controls | Pass |
| Volume controls | Pass |
| Album and folder navigation | Pass |
| Equalizer and DSP functionality | Pass |
| Screen-off playback | Pass |
| Screen lock and unlock | Pass |
| Quick Settings accessibility | Pass |
| Home and Recent Apps restrictions | Pass |
| Return to Android Mode | Pass |
| Repeated mode switching | Pass |
| Direct boot into Pure Audio Mode | Initial pass in v0.1.3 |
| Android Auto coexistence | Pass in v0.1.1 |
| Extended v0.1.3 regression testing | In progress |

Results represent observations across development versions. They do not constitute universal compatibility guarantees.

## 7. Audio Output Compatibility

The reference Poweramp configuration reported:

- Hi-Res DAP HiBy output.
- 192 kHz output sample rate.
- 32-bit output.
- SoX resampling.
- Equalizer and DSP functionality.
- Hardware volume control.

The same digital audio processing configuration was observed in normal Android Mode and Pure Audio Mode.

These observations do not establish differences in analog audio quality, electrical noise, distortion, or battery efficiency.

## 8. Magisk Module Compatibility

| Module | Status | Notes |
|---|---|---|
| HiBy R4 Android Auto Enabler | Validated with v0.1.1 | Successfully tested alongside PureAmp |
| LSPosed | Untested | Not required |
| Audio modification modules | Untested | Independent validation required |
| Other Magisk modules | Untested | Potential conflicts should be investigated |

Our related Android Auto project is available at:

[HiBy R4 Android Auto Enabler](https://github.com/oslara/HiBy-R4-Android-Auto)

## 9. Community Compatibility Report Template

When testing PureAmp with another device, firmware version, or music player, please provide the following information.

### Environment

- Device model:
- Firmware version:
- Android version:
- Android build:
- Magisk version:
- PureAmp version:
- Music player:
- Music player version:
- Package name:
- Launcher activity:
- Other installed Magisk modules:

### Functional Checklist

- [ ] Module installation successful.
- [ ] Device reboots normally.
- [ ] Normal Android Mode works.
- [ ] Pure Audio Mode remains active.
- [ ] Selected player launches automatically.
- [ ] Music playback works.
- [ ] Physical playback controls work.
- [ ] Volume controls work.
- [ ] Screen-off playback works.
- [ ] Screen lock and unlock work.
- [ ] Return to Android Mode works.
- [ ] Repeated mode transitions work.
- [ ] Direct boot into Pure Audio Mode works.
- [ ] Player remains active after the startup recovery window.
- [ ] No unexpected foreground interruptions.

### Additional Observations

Describe any unexpected behavior, limitations, errors, or configuration changes required to make the selected player work.

Include relevant sanitized diagnostic logs when available.

## 10. Contributing Your Results

Compatibility reports can be submitted through GitHub Issues.

Community members may also submit Pull Requests to update this document with verified results.

Please distinguish between successful launches and fully functional music playback.

Never include:

- Account credentials.
- Authentication tokens.
- Personal information.
- Device serial numbers.
- Proprietary firmware binaries.
- Copyrighted application APKs.

## 11. Our Philosophy

PureAmp is not intended to become a closed ecosystem.

We encourage users to explore their devices, understand the underlying technology, experiment responsibly, and share their discoveries.

Every new compatibility report helps expand our collective understanding of Android-based digital audio players.

You do not need to be a professional developer to contribute. Curiosity, patience, and reproducible observations are equally valuable.

---

**Choose your player. Test your hardware. Share your discoveries.**

**Your music. Your player. Your freedom.**

*A Technomancer Sisters project.*
