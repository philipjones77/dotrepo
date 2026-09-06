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
    if [ "${_DOTREPO_CONDA_INITIALIZED:-0}" != 1 ] \
      && [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
      . "$HOME/miniforge3/etc/profile.d/conda.sh"
      if [ "${CONDA_SHLVL:-0}" = 0 ]; then
        conda activate base
      fi
      _DOTREPO_CONDA_INITIALIZED=1
    fi
    # Keep local wrappers (including the system-R wrapper) ahead of Conda.
    export PATH="$HOME/.local/bin:$PATH"
    ;;
esac
if [ -f "$HOME/.config/dotrepo/shell.local.sh" ]; then
  . "$HOME/.config/dotrepo/shell.local.sh"
fi
if [ "${_DOTREPO_GDRIVE_STARTUP_STARTED:-0}" != 1 ] \
  && [ "${DOTREPO_AUTO_MOUNT_GOOGLE_DRIVE:-1}" != 0 ] \
  && [ -f "$HOME/.config/dotrepo/gdrive.enabled" ] \
  && [ -f "$DOTREPO/wsl/mounts/gdrive.sh" ]; then
  # Run in the WSL session's mount namespace; never source Bash-only code.
  mkdir -p "$HOME/.local/state/dotrepo"
  (bash "$DOTREPO/wsl/mounts/gdrive.sh" start >> "$HOME/.local/state/dotrepo/gdrive-startup.log" 2>&1) </dev/null >/dev/null 2>&1 &
  _DOTREPO_GDRIVE_STARTUP_STARTED=1
fi
