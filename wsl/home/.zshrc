export DOTREPO="${HOME}/.dotrepo"
. "$DOTREPO/shared/shell/init.sh"
autoload -Uz compinit
compinit
PROMPT='%n@%m:%~%# '
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
