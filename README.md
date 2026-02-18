Author : nischal-sketch21
### Version 5
![image](Shdwtool.png)

# Shdwhack (hardened maintenance edition)
This repository ships a security-hardened local maintenance shell.

## Highlights
- Strict bash mode (`set -euo pipefail`)
- Safe allowlist menu (only local maintenance actions)
- Deterministic exit codes
- Interactive and non-interactive usage
- Offline local usage guide (`USAGE.md`)

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

## Files
- `shdwhack.sh`: main script
- `USAGE.md`: operational usage guide
- `SECURITY.md`: security policy
- `CHANGELOG.md`: release notes
- `.github/workflows/shell-quality.yml`: CI checks (`bash -n` + `shellcheck`)

## Security note
Use this project only for legal and authorized security learning workflows.
