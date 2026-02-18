# Changelog

## 7.0.0
- Added structured JSON log output via `--json`.
- Added timestamped log format for text output.
- Added robust argument parsing with one-action validation.
- Added `mkdir` lock fallback when `flock` is unavailable.
- Expanded regression tests for JSON output and invalid multi-action usage.

## 6.0.0
- Added process lock protection (`flock`) to prevent concurrent runs.
- Added `--no-banner` for cleaner non-TTY/automation output.
- Added CLI regression test script at `tests/test_cli.sh`.
- Extended CI workflow to execute the CLI regression tests.

## 5.0.0
- Added deterministic CLI flags (`--prepare-tools`, `--remove-tools`, `--usage`, `--open-guide`, `--help`).
- Added deterministic exit codes for success, invalid input, runtime errors, and usage errors.
- Added local usage document (`USAGE.md`) and made usage available offline.
- Added `SECURITY.md` policy and CI workflow for shell quality checks.
- Simplified menu to only allow safe local maintenance actions.

## 4.0.0
- Refactored menu flow with strict mode and case-based dispatcher.
- Removed missing `tga.sh` dependency and disabled unsafe legacy actions.
