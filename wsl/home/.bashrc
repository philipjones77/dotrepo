case $- in
  *i*) ;;
  *) return ;;
esac
export DOTREPO="${HOME}/.dotrepo"
. "$DOTREPO/shared/shell/init.sh"
if [ -x /usr/bin/dircolors ]; then
  if [ -r "$HOME/.dircolors" ]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
fi
PS1='\u@\h:\w\$ '
case "$TERM" in
  xterm*|rxvt*) PS1="\[\e]0;\u@\h: \w\a\]$PS1" ;;
esac
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell bash)"
fi
