#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
  printf 'Usage: open-pdf /path/to/document.pdf\n' >&2
  exit 2
fi
pdf_path=$(realpath -- "$1")
if [[ ! -f "$pdf_path" || "${pdf_path,,}" != *.pdf ]]; then
  printf 'Expected an existing PDF: %s\n' "$pdf_path" >&2
  exit 2
fi
windows_home=$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("UserProfile")' | tr -d '\r')
windows_home_unix=$(wslpath -u "$windows_home")
pwsh_exe="$windows_home_unix/.local/powershell/current/pwsh.exe"
if [[ ! -f "$pwsh_exe" ]]; then
  pwsh_exe=$(command -v pwsh.exe)
fi
exec "$pwsh_exe" -NoProfile -File "${windows_home}\\.local\\bin\\open-pdf.ps1" -Pdf "$(wslpath -w "$pdf_path")"
