# Lightweight interactive fallback; Zsh is the main shell.
case $- in
    *i*) ;;
    *) return ;;
esac

shopt -s histappend checkwinsize
HISTSIZE=
HISTFILESIZE=
HISTCONTROL=ignoreboth
PS1='\u@\h \w \$ '

alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'
alias lla='ls -lAh'
alias g='git'
alias vi='nvim'
alias vim='nvim'
alias t='tmux'

if [ -f "$HOME/.bashrc.local" ]; then
    . "$HOME/.bashrc.local"
fi
