# Shared by WSL Bash, Zsh and login shells. Keep this file POSIX-compatible.
export DOTREPO="${DOTREPO:-$HOME/.dotrepo}"
if [ -f "$DOTREPO/shared/shell/env.sh" ]; then
  . "$DOTREPO/shared/shell/env.sh"
fi
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
# Editors opened before Conda retirement can pass its prefix as VIRTUAL_ENV.
# Clear that stale value before choosing the installed CPython default.
case "${VIRTUAL_ENV:-}" in
  "$HOME/miniforge3"|"$HOME/miniforge3/"*) unset VIRTUAL_ENV VIRTUAL_ENV_PROMPT ;;
esac
case $- in
  *i*)
    # Plain wsl.exe inherits the Windows directory unless the shell resets it.
    # Explicit bash -c commands keep their caller-selected working directory.
    if [ -n "${WSL_DISTRO_NAME:-}" ] && [ -z "${BASH_EXECUTION_STRING:-}" ]; then
      cd "$HOME" || return 1
    fi
    . "$DOTREPO/shared/shell/aliases.sh"
    . "$DOTREPO/shared/shell/functions.sh"
    ;;
esac
if [ -f "$HOME/.config/dotrepo/shell.local.sh" ]; then
  . "$HOME/.config/dotrepo/shell.local.sh"
fi
case $- in
  *i*)
    # Activation must save the finished machine PATH so deactivate (including
    # switching with jaxenv) cannot restore retired paths or discard local tools.
    if [ -z "${VIRTUAL_ENV:-}" ] \
      && [ -f "$HOME/.virtualenvs/py313/bin/activate" ]; then
      . "$HOME/.virtualenvs/py313/bin/activate"
    fi
    # Keep local wrappers (including the system-R wrapper) ahead of environments.
    export PATH="$HOME/.local/bin:$PATH"
    ;;
esac
if [ "${_DOTREPO_GDRIVE_STARTUP_STARTED:-0}" != 1 ] \
  && [ "${DOTREPO_AUTO_MOUNT_GOOGLE_DRIVE:-1}" != 0 ] \
  && [ -f "$HOME/.config/dotrepo/gdrive.enabled" ] \
  && [ -f "$DOTREPO/wsl/mounts/gdrive.sh" ]; then
  # Run in the WSL session's mount namespace; never source Bash-only code.
  mkdir -p "$HOME/.local/state/dotrepo"
  (bash "$DOTREPO/wsl/mounts/gdrive.sh" start >> "$HOME/.local/state/dotrepo/gdrive-startup.log" 2>&1) </dev/null >/dev/null 2>&1 &
  _DOTREPO_GDRIVE_STARTUP_STARTED=1
fi
