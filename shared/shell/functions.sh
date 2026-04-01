mkcd() {
  mkdir -p "$1" && cd "$1" || return 1
}

venvpy() {
  python -m venv "${1:-.venv}"
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
