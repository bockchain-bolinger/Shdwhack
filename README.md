Author : nischal-sketch21
### Version 4
![image](Shdwtool.png)

# Shdwhack (hardened maintenance edition)
This repository now ships a **security-hardened maintenance shell** that focuses on safe local operations only.

## What changed
- Legacy offensive actions were disabled for security/compliance.
- Menu handling was rewritten with validated numeric input.
- Missing `tga.sh` loops were removed.
- Script now runs with strict shell mode (`set -euo pipefail`).

## Current menu options
- `1` Prepare local `Tools/` directory
- `2` Open usage guide URL
- `3` Remove local `Tools/` directory
- `0` Exit

## Operating system requirements
Works on most Linux shells with `bash`.

## Run
```bash
bash shdwhack.sh
```

## Security note
Use this project only for legal and authorized security learning workflows.
