mkcd() {
  mkdir -p "$1" && cd "$1" || return 1
}

venvpy() {
  python -m venv "${1:-.venv}"
}

jaxenv() {
  case "${1:-314}" in
    313|314|315) ;;
    *) echo 'usage: jaxenv [313|314|315]' >&2; return 1 ;;
  esac
  if [ ! -f "$HOME/.virtualenvs/jax${1:-314}/bin/activate" ]; then
    echo "Python virtualenv is not installed: ~/.virtualenvs/jax${1:-314}" >&2
    return 1
  fi
  if command -v conda >/dev/null 2>&1 && [ "${CONDA_SHLVL:-0}" != 0 ]; then
    conda deactivate || return 1
  fi
  . "$HOME/.virtualenvs/jax${1:-314}/bin/activate"
  export UV_PYTHON="$VIRTUAL_ENV/bin/python"
  export IFJ_PYTHON="$VIRTUAL_ENV/bin/python"
  export ARBPLUSJAX_PYTHON="$VIRTUAL_ENV/bin/python"
}

extract() {
  if [ $# -ne 1 ] || [ ! -f "$1" ]; then
    echo "usage: extract <archive>" >&2
    return 1
  fi

  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.xz|*.txz) tar xJf "$1" ;;
    *.tar) tar xf "$1" ;;
    *.zip) unzip "$1" ;;
    *.gz) gunzip "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.xz) unxz "$1" ;;
    *)
      echo "unsupported archive: $1" >&2
      return 1
      ;;
  esac
}
