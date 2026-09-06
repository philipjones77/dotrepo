#!/usr/bin/env sh

export DOTREPO="${DOTREPO:-$HOME/.dotrepo}"
export PROJECTS_HOME="${PROJECTS_HOME:-$HOME/projects}"

prepend_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1${PATH:+:$PATH}" ;;
  esac
}

for path_dir in "$HOME/.local/bin" "$HOME/bin" "$HOME/.cargo/bin"; do
  if [ -d "$path_dir" ]; then
    prepend_path "$path_dir"
  fi
done

export PATH
export R_LIBS_USER="${R_LIBS_USER:-$HOME/.local/lib/R/site-library}"

export DOTREPO_AUTO_MOUNT_GOOGLE_DRIVE="${DOTREPO_AUTO_MOUNT_GOOGLE_DRIVE:-1}"
export DOTREPO_GDRIVE_WINDOWS_DRIVE="${DOTREPO_GDRIVE_WINDOWS_DRIVE:-G}"
export DOTREPO_GDRIVE_WSL_DRVFS="${DOTREPO_GDRIVE_WSL_DRVFS:-/mnt/g}"
export DOTREPO_GDRIVE_RCLONE_MOUNT="${DOTREPO_GDRIVE_RCLONE_MOUNT:-${DOTREPO_GDRIVE_PATH:-$HOME/mnt/gdrive}}"

# Environment setup has no mount side effects. init.sh owns opted-in startup.
