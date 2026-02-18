#!/usr/bin/env bash
set -euo pipefail

readonly VERSION="4"
readonly TOOLS_DIR="Tools"

log() {
  printf '[INFO] %s\n' "$*"
}

warn() {
  printf '[WARN] %s\n' "$*" >&2
}

err() {
  printf '[ERROR] %s\n' "$*" >&2
}

show_banner() {
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
[2] Open usage guide
[3] Remove downloaded tools
[0] Exit
MENU
}

ensure_tools_dir() {
  mkdir -p "$TOOLS_DIR"
  log "Directory '$TOOLS_DIR' is ready."
}

open_usage_guide() {
  local url="https://pasteio.com/xuCvIkXdNRIB"
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url" >/dev/null 2>&1 || warn "Failed to open browser; use this URL manually: $url"
  else
    warn "xdg-open is unavailable; use this URL manually: $url"
  fi
}

remove_tools_dir() {
  rm -rf "$TOOLS_DIR"
  log "Directory '$TOOLS_DIR' removed."
}

unsupported_option() {
  warn "This legacy option was disabled for security and compliance reasons."
  warn "Only safe local maintenance options remain available in this version."
}

handle_selection() {
  local selection="$1"
  case "$selection" in
    1)
      ensure_tools_dir
      ;;
    2)
      open_usage_guide
      ;;
    3)
      remove_tools_dir
      ;;
    4|5|6|7|8|9|10|11|12|13|14|15|16|17|18)
      unsupported_option
      ;;
    0)
      log "Exiting."
      exit 0
      ;;
    *)
      err "Invalid selection: '$selection'. Please choose 0, 1, 2 or 3."
      ;;
  esac
}

main() {
  ensure_tools_dir

  while true; do
    show_banner
    show_menu
    read -r -p "Number: " selection

    if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
      err "Input must be numeric."
      sleep 1
      continue
    fi

    handle_selection "$selection"
    printf '\nPress Enter to continue...'
    read -r _
  done
}

main "$@"
