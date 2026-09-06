export DOTREPO="${HOME}/.dotrepo"
case $- in
  *i*)
    if [ -n "${BASH_VERSION:-}" ] && [ -f "$HOME/.bashrc" ]; then
      . "$HOME/.bashrc"
    else
      . "$DOTREPO/shared/shell/init.sh"
    fi
    ;;
  *) . "$DOTREPO/shared/shell/init.sh" ;;
esac
