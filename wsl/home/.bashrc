case $- in
  *i*) ;;
  *) return ;;
esac

export DOTREPO="${HOME}/.dotrepo"

if [ -x /usr/bin/dircolors ]; then
  test -r "$HOME/.dircolors" && eval "$(dircolors -b "$HOME/.dircolors")" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

if [ -f "$DOTREPO/shared/shell/env.sh" ]; then
  . "$DOTREPO/shared/shell/env.sh"
fi

if [ -f "$DOTREPO/shared/shell/aliases.sh" ]; then
  . "$DOTREPO/shared/shell/aliases.sh"
fi

if [ -f "$DOTREPO/shared/shell/functions.sh" ]; then
  . "$DOTREPO/shared/shell/functions.sh"
fi

PS1='\u@\h:\w\$ '
case "$TERM" in
  xterm*|rxvt*) PS1="\[\e]0;\u@\h: \w\a\]$PS1" ;;
esac

if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

if [ -f "$HOME/miniforge3/bin/activate" ]; then
  # Preserve the current machine behavior: new shells open with base activated.
  . "$HOME/miniforge3/bin/activate"
fi

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell bash)"
fi

cd "$HOME"
