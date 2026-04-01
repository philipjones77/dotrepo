export DOTREPO="${HOME}/.dotrepo"

if [ -f "$DOTREPO/shared/shell/env.sh" ]; then
  . "$DOTREPO/shared/shell/env.sh"
fi

if [ -f "$DOTREPO/shared/shell/aliases.sh" ]; then
  . "$DOTREPO/shared/shell/aliases.sh"
fi

if [ -f "$DOTREPO/shared/shell/functions.sh" ]; then
  . "$DOTREPO/shared/shell/functions.sh"
fi

autoload -Uz compinit
compinit

PROMPT='%n@%m:%~%# '

if [ -f "$HOME/miniforge3/bin/activate" ]; then
  . "$HOME/miniforge3/bin/activate"
fi

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

cd "$HOME"
