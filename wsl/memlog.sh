#!/usr/bin/env bash
# Record WSL memory and the largest processes every 30 seconds so an
# out-of-memory crash can be traced to a specific process afterwards.
# Logs: ~/.local/state/dotrepo/memlog/YYYY-MM-DD.log (seven days kept).
set -u
dir="${HOME}/.local/state/dotrepo/memlog"
mkdir -p "$dir"
interval="${MEMLOG_INTERVAL:-30}"
top="${MEMLOG_TOP:-8}"

label() {
  # Name VS Code node processes by role or extension instead of "node".
  case "$1" in
    *--type=extensionHost*) echo "vscode-exthost" ;;
    *server-main.js*) echo "vscode-server" ;;
    *fileWatcher*|*watcherService*) echo "vscode-watcher" ;;
    */.vscode-server/extensions/*)
      echo "$1" | sed -E 's#.*/\.vscode-server/extensions/([^/]+)/.*#ext:\1#' ;;
    *) echo "$1" | awk '{print $1}' | sed 's#.*/##' ;;
  esac
}

while :; do
  log="$dir/$(date +%F).log"
  {
    printf '%s ' "$(date +%T)"
    free -m | awk '/^Mem/{printf "used=%sMB avail=%sMB ", $3, $7} /^Swap/{printf "swap=%sMB\n", $3}'
    ps -eo pid=,rss=,etime=,args= --sort=-rss | head -n "$top" | while read -r pid rss etime args; do
      printf '  %7s %6dMB %11s %s\n' "$pid" "$((rss / 1024))" "$etime" "$(label "$args")"
    done
  } >> "$log"
  find "$dir" -name '*.log' -mtime +7 -delete 2>/dev/null
  sleep "$interval"
done
