# Changelog

## 5.0.0
- Added deterministic CLI flags (`--prepare-tools`, `--remove-tools`, `--usage`, `--open-guide`, `--help`).
- Added deterministic exit codes for success, invalid input, runtime errors, and usage errors.
- Added local usage document (`USAGE.md`) and made usage available offline.
- Added `SECURITY.md` policy and CI workflow for shell quality checks.
- Simplified menu to only allow safe local maintenance actions.

## 4.0.0
- Refactored menu flow with strict mode and case-based dispatcher.
- Removed missing `tga.sh` dependency and disabled unsafe legacy actions.
