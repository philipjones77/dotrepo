#!/usr/bin/env sh
# Use the Windows Antigravity IDE client from Bash without importing Windows PATH.
set -eu

if [ -n "${DOTREPO_WINDOWS_ANTIGRAVITY_IDE_BIN:-}" ]; then
  if [ ! -x "$DOTREPO_WINDOWS_ANTIGRAVITY_IDE_BIN" ]; then
    printf 'Antigravity IDE launcher is not executable: %s\n' "$DOTREPO_WINDOWS_ANTIGRAVITY_IDE_BIN" >&2
    exit 127
  fi
  exec "$DOTREPO_WINDOWS_ANTIGRAVITY_IDE_BIN" "$@"
fi

windows_cmd=/mnt/c/Windows/System32/cmd.exe
if [ -x "$windows_cmd" ] && command -v wslpath >/dev/null 2>&1; then
  windows_local_appdata=$("$windows_cmd" /d /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')
  if [ -n "$windows_local_appdata" ] && [ "$windows_local_appdata" != '%LOCALAPPDATA%' ]; then
    if local_appdata=$(wslpath -u "$windows_local_appdata" 2>/dev/null); then
      ide_bin="$local_appdata/Programs/Antigravity IDE/bin/antigravity-ide"
      if [ -x "$ide_bin" ]; then
        exec "$ide_bin" "$@"
      fi
    fi
  fi
fi

for ide_bin in \
  '/mnt/c/Program Files/Antigravity IDE/bin/antigravity-ide' \
  '/mnt/c/Program Files (x86)/Antigravity IDE/bin/antigravity-ide'; do
  if [ -x "$ide_bin" ]; then
    exec "$ide_bin" "$@"
  fi
done

printf '%s\n' 'Windows Antigravity IDE was not found. Install it, or set DOTREPO_WINDOWS_ANTIGRAVITY_IDE_BIN to its Linux /mnt/.../bin/antigravity-ide path.' >&2
exit 127
