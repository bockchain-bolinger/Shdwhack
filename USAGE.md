# Usage Guide

## Interactive mode
```bash
bash shdwhack.sh
```

Menu options:
- `1` Prepare local `Tools/` directory
- `2` Show this local usage guide
- `3` Remove local `Tools/` directory
- `0` Exit

## Non-interactive mode
```bash
bash shdwhack.sh --prepare-tools
bash shdwhack.sh --usage
bash shdwhack.sh --remove-tools
bash shdwhack.sh --help
```

## Exit codes
- `0`: success
- `2`: invalid input
- `3`: runtime error
- `64`: invalid CLI usage
