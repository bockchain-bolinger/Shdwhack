Author : nischal-sketch21
### Version 6
![image](Shdwtool.png)

# Shdwhack (hardened maintenance edition)
This repository ships a security-hardened local maintenance shell.

## Highlights
- Strict bash mode (`set -euo pipefail`)
- Safe allowlist menu (only local maintenance actions)
- Deterministic exit codes
- Interactive and non-interactive usage
- Offline local usage guide (`USAGE.md`)
- Single-process lock protection via `flock`

## Interactive run
```bash
bash shdwhack.sh
```

## Non-interactive run
```bash
bash shdwhack.sh --prepare-tools
bash shdwhack.sh --usage
bash shdwhack.sh --remove-tools
bash shdwhack.sh --help
```

## Optional flags
```bash
bash shdwhack.sh --no-banner
```

## Tests
```bash
bash tests/test_cli.sh
```

## Files
- `shdwhack.sh`: main script
- `USAGE.md`: operational usage guide
- `SECURITY.md`: security policy
- `CHANGELOG.md`: release notes
- `tests/test_cli.sh`: CLI regression checks
- `.github/workflows/shell-quality.yml`: CI checks (`bash -n`, `shellcheck`, CLI tests)

## Security note
Use this project only for legal and authorized security learning workflows.
