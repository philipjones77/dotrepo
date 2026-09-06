# Shared by WSL Bash, Zsh and login shells. Keep this file POSIX-compatible.
export DOTREPO="${DOTREPO:-$HOME/.dotrepo}"
if [ -f "$DOTREPO/shared/shell/env.sh" ]; then
  . "$DOTREPO/shared/shell/env.sh"
fi
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
case $- in
  *i*)
    . "$DOTREPO/shared/shell/aliases.sh"
    . "$DOTREPO/shared/shell/functions.sh"
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
      . "$HOME/miniforge3/etc/profile.d/conda.sh"
      conda activate base
    fi
    # Keep local wrappers (including the system-R wrapper) ahead of Conda.
    export PATH="$HOME/.local/bin:$PATH"
    ;;
esac
if [ -f "$HOME/.config/dotrepo/gdrive.enabled" ] && [ -f "$DOTREPO/wsl/mounts/gdrive.sh" ]; then
  # Run in the WSL session's mount namespace; never source Bash-only code.
  mkdir -p "$HOME/.local/state/dotrepo"
  (bash "$DOTREPO/wsl/mounts/gdrive.sh" start >> "$HOME/.local/state/dotrepo/gdrive-startup.log" 2>&1) </dev/null >/dev/null 2>&1 &
fi
if [ -f "$HOME/.config/dotrepo/shell.local.sh" ]; then
  . "$HOME/.config/dotrepo/shell.local.sh"
fi
