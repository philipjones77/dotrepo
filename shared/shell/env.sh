#!/usr/bin/env sh

export DOTREPO="${DOTREPO:-$HOME/.dotrepo}"

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
