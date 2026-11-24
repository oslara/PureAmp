# PureAmp — Changelog

All notable changes to PureAmp are documented here.

## v0.1.3 — Adaptive Boot Recovery

**Date:** November 24, 2026  
**Status:** Release Candidate

### Added

- Dynamic launcher activity resolution during startup.
- Android user readiness verification.
- Detection of activity launch errors independently of command exit codes.
- Recovery when HiBy Music or Android Launcher retains foreground ownership.
- Extended 120-second startup recovery window.
- Maximum of three boot launch attempts.

### Fixed

- Temporary launcher activity unavailability during startup.
- Recovery logic failing when Android Launcher remained in the foreground.
- False successful exit codes reported by Android following activity launch errors.

### Preserved

- Five-second normal mode transition delay.
- Three-second mode polling interval.
- SELinux-compatible diagnostic logging.
- Native Pure Audio Mode behavior.
- Systemless Magisk architecture.

### Validation

- Successful direct reboot into Pure Audio Mode.
- Successful dynamic resolution of Poweramp's launcher.
- Successful cold launch of Poweramp.
- Verified foreground activity.
- Confirmed preservation of the native music working mode.

Extended regression testing remains in progress.

## v0.1.2 — Boot-Time Race Condition Correction

**Date:** November 24, 2026  
**Status:** Superseded

### Added

- Separate boot and normal mode transition handling.
- Twenty-second initial boot settling period.
- Sixty-second startup recovery window.
- Bounded foreground recovery attempts.
- Device uptime-based recovery timing.

### Known Issues

- Poweramp's launcher activity could be temporarily unavailable during startup.
- Recovery was restricted to HiBy Music reclaiming the foreground.
- Recovery could fail when Android Launcher remained active.
- Android could report exit code 0 despite an unsuccessful activity launch.

These issues motivated the adaptive startup architecture introduced in v0.1.3.

## v0.1.1 — Binder Transaction Correction

**Date:** November 24, 2026  
**Status:** Superseded

### Fixed

- Failed Binder transactions caused by direct command output redirection into the protected Magisk module log.

### Added

- Pipe-based command output capture.
- Explicit Android executable paths.
- Standard input redirection.
- Execution context logging.
- Post-launch foreground verification.

### Validation

Nine of ten regression tests passed, including:

- Magisk installation.
- Normal device reboot.
- Automatic Poweramp switching.
- Music playback and physical controls.
- Repeated mode transitions.
- Return to Android Mode.
- Coexistence with the HiBy R4 Android Auto Enabler module.

### Known Issues

HiBy Music could reclaim the foreground when rebooting directly into Pure Audio Mode.

## v0.1.0 — Initial Prototype

**Date:** November 24, 2026  
**Status:** Superseded

### Added

- Initial Magisk module implementation.
- Native work_mode monitoring.
- Automatic detection of Pure Audio Mode.
- Configured transition delay.
- Explicit Poweramp activity launch.
- Local diagnostic logging.
- Installation compatibility checks.

### Known Issues

Automated activity launches failed with a Binder transaction error despite successful manual ADB launches.

The root cause was investigated and corrected in v0.1.1.

## Pre-Release Research

**Date:** November 24, 2026

### Discoveries

- Identified the native work_mode global setting.
- Identified firmware references responsible for Pure Audio Mode restrictions.
- Confirmed that Poweramp was force-stopped during mode transitions.
- Confirmed that Poweramp remained installed and enabled.
- Demonstrated successful explicit activity launching within native Pure Audio Mode.
- Passed eleven manual functional tests.
- Observed identical reported Poweramp digital audio configurations in Android Mode and Pure Audio Mode.

The research demonstrated that core firmware replacements were unnecessary for the reference implementation.

## Future Development

Potential improvements include:

- Simplified custom player configuration.
- Dynamic launcher resolution for all mode transitions.
- Alternative music player compatibility.
- Additional HiBy device support.
- Battery consumption benchmarking.
- Background resource utilization benchmarking.
- More efficient mode detection mechanisms.
- Community-driven improvements.

Future features are proposals, not release commitments.

## Permanent Project Principles

- Free and open source.
- No advertisements.
- No subscriptions.
- No telemetry.
- No activation requirements.
- No proprietary firmware redistribution.
- No unnecessary dependencies.
- No SELinux policy modifications.

---

**Your music. Your player. Your freedom.**

*A Technomancer Sisters project.*
