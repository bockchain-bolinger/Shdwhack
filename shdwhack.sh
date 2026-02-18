#!/usr/bin/env bash
set -euo pipefail

readonly VERSION="7"
readonly TOOLS_DIR="Tools"
readonly USAGE_FILE="USAGE.md"
readonly USAGE_URL="https://pasteio.com/xuCvIkXdNRIB"
readonly LOCK_FILE=".shdwhack.lock"
readonly LOCK_DIR=".shdwhack.lockdir"

readonly EXIT_SUCCESS=0
readonly EXIT_INVALID_INPUT=2
readonly EXIT_RUNTIME_ERROR=3
readonly EXIT_USAGE_ERROR=64

SHOW_BANNER=true
OUTPUT_FORMAT="text"
LOCK_MODE=""
PARSED_ACTION="none"

json_escape() {
  local input="$1"
  input=${input//\\/\\\\}
  input=${input//\"/\\\"}
  input=${input//$'\n'/\\n}
  input=${input//$'\r'/\\r}
  printf '%s' "$input"
}

timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

emit_log() {
  local level="$1"
  local message="$2"

  if [[ "$OUTPUT_FORMAT" == "json" ]]; then
    printf '{"ts":"%s","level":"%s","message":"%s"}\n' \
      "$(timestamp)" "$(json_escape "$level")" "$(json_escape "$message")"
  else
    printf '[%s] %s %s\n' "$level" "$(timestamp)" "$message"
  fi
}

log() {
  emit_log "INFO" "$*"
}

warn() {
  emit_log "WARN" "$*" >&2
}

err() {
  emit_log "ERROR" "$*" >&2
}

release_lock() {
  if [[ "$LOCK_MODE" == "mkdir" ]]; then
    rmdir "$LOCK_DIR" 2>/dev/null || true
  fi
}

acquire_lock() {
  if command -v flock >/dev/null 2>&1; then
    exec 9>"$LOCK_FILE"
    if ! flock -n 9; then
      err "Another shdwhack process is already running."
      exit "$EXIT_RUNTIME_ERROR"
    fi
    LOCK_MODE="flock"
  else
    if mkdir "$LOCK_DIR" 2>/dev/null; then
      LOCK_MODE="mkdir"
      trap release_lock EXIT
    else
      err "Another shdwhack process is already running (mkdir lock fallback)."
      exit "$EXIT_RUNTIME_ERROR"
    fi
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
  bash shdwhack.sh [options]

Options:
  --prepare-tools   Create local Tools/ directory
  --remove-tools    Remove local Tools/ directory
  --usage           Print local usage guide
  --open-guide      Open online usage guide in browser
  --no-banner       Disable interactive banner rendering
  --json            Emit logs as JSON lines
  --help            Show this help message

Notes:
  - You can combine format flags with one action (for example: --json --usage).
  - At most one action flag can be passed per command.

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

run_action() {
  local action="$1"
  case "$action" in
    prepare)
      ensure_tools_dir
      ;;
    remove)
      remove_tools_dir
      ;;
    usage)
      show_local_usage
      ;;
    open-guide)
      open_online_usage_guide
      ;;
    help)
      show_help
      ;;
    none)
      show_help
      ;;
    *)
      err "Unknown parsed action: $action"
      return "$EXIT_USAGE_ERROR"
      ;;
  esac
}

parse_args() {
  PARSED_ACTION="none"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --prepare-tools)
        [[ "$PARSED_ACTION" == "none" ]] || { err "Only one action flag is allowed."; return "$EXIT_USAGE_ERROR"; }
        PARSED_ACTION="prepare"
        ;;
      --remove-tools)
        [[ "$PARSED_ACTION" == "none" ]] || { err "Only one action flag is allowed."; return "$EXIT_USAGE_ERROR"; }
        PARSED_ACTION="remove"
        ;;
      --usage)
        [[ "$PARSED_ACTION" == "none" ]] || { err "Only one action flag is allowed."; return "$EXIT_USAGE_ERROR"; }
        PARSED_ACTION="usage"
        ;;
      --open-guide)
        [[ "$PARSED_ACTION" == "none" ]] || { err "Only one action flag is allowed."; return "$EXIT_USAGE_ERROR"; }
        PARSED_ACTION="open-guide"
        ;;
      --help)
        [[ "$PARSED_ACTION" == "none" ]] || { err "Only one action flag is allowed."; return "$EXIT_USAGE_ERROR"; }
        PARSED_ACTION="help"
        ;;
      --no-banner)
        SHOW_BANNER=false
        ;;
      --json)
        OUTPUT_FORMAT="json"
        ;;
      *)
        err "Unknown option: $1"
        return "$EXIT_USAGE_ERROR"
        ;;
    esac
    shift
  done
}

main() {
  acquire_lock

  if [[ $# -gt 0 ]]; then
    parse_args "$@" || {
      show_help
      exit "$EXIT_USAGE_ERROR"
    }
    run_action "$PARSED_ACTION"
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
