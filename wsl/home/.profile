export DOTREPO="${HOME}/.dotrepo"

if [ -f "$DOTREPO/shared/shell/env.sh" ]; then
  . "$DOTREPO/shared/shell/env.sh"
fi

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
