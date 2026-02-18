#!/usr/bin/env bash
set -euo pipefail

readonly VERSION="6"
readonly TOOLS_DIR="Tools"
readonly USAGE_FILE="USAGE.md"
readonly USAGE_URL="https://pasteio.com/xuCvIkXdNRIB"
readonly LOCK_FILE=".shdwhack.lock"

readonly EXIT_SUCCESS=0
readonly EXIT_INVALID_INPUT=2
readonly EXIT_RUNTIME_ERROR=3
readonly EXIT_USAGE_ERROR=64

SHOW_BANNER=true

log() {
  printf '[INFO] %s\n' "$*"
}

warn() {
  printf '[WARN] %s\n' "$*" >&2
}

err() {
  printf '[ERROR] %s\n' "$*" >&2
}

acquire_lock() {
  exec 9>"$LOCK_FILE"
  if ! flock -n 9; then
    err "Another shdwhack process is already running."
    exit "$EXIT_RUNTIME_ERROR"
  fi
}

show_banner() {
  if [[ "$SHOW_BANNER" != true ]] || [[ ! -t 1 ]]; then
    return
  fi

  clear >/dev/null 2>&1 || true
  cat <<'BANNER'
███████╗██╗  ██╗██████╗ ██╗    ██╗   ████████╗ ██████╗  ██████╗ ██╗
██╔════╝██║  ██║██╔══██╗██║    ██║   ╚══██╔══╝██╔═══██╗██╔═══██╗██║
███████╗███████║██║  ██║██║ █╗ ██║█████╗██║   ██║   ██║██║   ██║██║
╚════██║██╔══██║██║  ██║██║███╗██║╚════╝██║   ██║   ██║██║   ██║██║
███████║██║  ██║██████╔╝╚███╔███╔╝      ██║   ╚██████╔╝╚██████╔╝███████╗
╚══════╝╚═╝  ╚═╝╚═════╝  ╚══╝╚══╝       ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝
BANNER
  printf 'Version: %s\n\n' "$VERSION"
}

show_menu() {
  cat <<'MENU'
[1] Prepare local tools directory
[2] Show local usage guide
[3] Remove downloaded tools
[0] Exit
MENU
}

show_help() {
  cat <<'HELP'
Usage:
  bash shdwhack.sh [option]

Options:
  --prepare-tools   Create local Tools/ directory
  --remove-tools    Remove local Tools/ directory
  --usage           Print local usage guide
  --open-guide      Open online usage guide in browser
  --no-banner       Disable interactive banner rendering
  --help            Show this help message

Exit codes:
  0   Success
  2   Invalid user input
  3   Runtime error
  64  Invalid CLI usage
HELP
}

ensure_tools_dir() {
  mkdir -p "$TOOLS_DIR"
  log "Directory '$TOOLS_DIR' is ready."
}

remove_tools_dir() {
  rm -rf "$TOOLS_DIR"
  log "Directory '$TOOLS_DIR' removed."
}

show_local_usage() {
  if [[ -f "$USAGE_FILE" ]]; then
    cat "$USAGE_FILE"
  else
    err "Usage file '$USAGE_FILE' was not found."
    return "$EXIT_RUNTIME_ERROR"
  fi
}

open_online_usage_guide() {
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$USAGE_URL" >/dev/null 2>&1 || {
      warn "Failed to open browser."
      warn "Open manually: $USAGE_URL"
      return "$EXIT_RUNTIME_ERROR"
    }
  else
    warn "xdg-open is unavailable. Open manually: $USAGE_URL"
    return "$EXIT_RUNTIME_ERROR"
  fi
}

handle_selection() {
  local selection="$1"
  case "$selection" in
    1)
      ensure_tools_dir
      ;;
    2)
      show_local_usage
      ;;
    3)
      remove_tools_dir
      ;;
    0)
      log "Exiting."
      exit "$EXIT_SUCCESS"
      ;;
    *)
      err "Invalid selection: '$selection'. Please choose 0, 1, 2 or 3."
      return "$EXIT_INVALID_INPUT"
      ;;
  esac
}

run_non_interactive() {
  local option="$1"
  case "$option" in
    --prepare-tools)
      ensure_tools_dir
      ;;
    --remove-tools)
      remove_tools_dir
      ;;
    --usage)
      show_local_usage
      ;;
    --open-guide)
      open_online_usage_guide
      ;;
    --no-banner)
      SHOW_BANNER=false
      ;;
    --help)
      show_help
      ;;
    *)
      err "Unknown option: $option"
      show_help
      return "$EXIT_USAGE_ERROR"
      ;;
  esac
}

main() {
  acquire_lock

  if [[ $# -gt 0 ]]; then
    run_non_interactive "$1"
    exit $?
  fi

  ensure_tools_dir

  while true; do
    show_banner
    show_menu

    read -r -p "Number: " selection || {
      err "Failed to read input."
      exit "$EXIT_RUNTIME_ERROR"
    }

    if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
      err "Input must be numeric."
      sleep 1
      continue
    fi

    if ! handle_selection "$selection"; then
      sleep 1
      continue
    fi

    printf '\nPress Enter to continue...'
    read -r _ || true
  done
}

main "$@"
