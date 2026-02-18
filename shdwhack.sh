#!/usr/bin/env bash
set -euo pipefail




 main
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
[1] Prepare local tools directory main
[3] Remove downloaded tools
[0] Exit
MENU
}

main
ensure_tools_dir() {
  mkdir -p "$TOOLS_DIR"
  log "Directory '$TOOLS_DIR' is ready."
}

main
remove_tools_dir() {
  rm -rf "$TOOLS_DIR"
  log "Directory '$TOOLS_DIR' removed."
}

main
}

handle_selection() {
  local selection="$1"
  case "$selection" in
    1)
      ensure_tools_dir
      ;;
    2)
main
      ;;
    3)
      remove_tools_dir
      ;;
main
      ;;
  esac
}



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
main
  ensure_tools_dir

  while true; do
    show_banner
    show_menu
main

    if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
      err "Input must be numeric."
      sleep 1
      continue
    fi

main
  done
}

main "$@"
