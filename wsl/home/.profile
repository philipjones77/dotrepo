export DOTREPO="${HOME}/.dotrepo"
. "$DOTREPO/shared/shell/init.sh"
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
