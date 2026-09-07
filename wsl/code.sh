#!/usr/bin/env sh
# Keep Linux tools first on PATH while using Windows VS Code and Remote WSL.
set -eu

if [ -n "${DOTREPO_WINDOWS_CODE_BIN:-}" ]; then
  if [ ! -x "$DOTREPO_WINDOWS_CODE_BIN" ]; then
    printf 'VS Code launcher is not executable: %s\n' "$DOTREPO_WINDOWS_CODE_BIN" >&2
    exit 127
  fi
  exec "$DOTREPO_WINDOWS_CODE_BIN" "$@"
fi

windows_cmd=/mnt/c/Windows/System32/cmd.exe
if [ -x "$windows_cmd" ] && command -v wslpath >/dev/null 2>&1; then
  windows_local_appdata=$("$windows_cmd" /d /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')
  if [ -n "$windows_local_appdata" ] && [ "$windows_local_appdata" != '%LOCALAPPDATA%' ]; then
    if local_appdata=$(wslpath -u "$windows_local_appdata" 2>/dev/null); then
      code_bin="$local_appdata/Programs/Microsoft VS Code/bin/code"
      if [ -x "$code_bin" ]; then
        exec "$code_bin" "$@"
      fi
    fi
  fi
fi

for code_bin in \
  '/mnt/c/Program Files/Microsoft VS Code/bin/code' \
  '/mnt/c/Program Files (x86)/Microsoft VS Code/bin/code'; do
  if [ -x "$code_bin" ]; then
    exec "$code_bin" "$@"
  fi
done

printf '%s\n' 'Windows VS Code was not found. Install it with Remote WSL, or set DOTREPO_WINDOWS_CODE_BIN to its Linux /mnt/.../bin/code path.' >&2
exit 127
