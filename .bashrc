# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [[ -f /etc/bash.bashrc ]]; then
    . /etc/bash.bashrc
fi

# cd in directory by typing the directory name
#shopt -s autocd

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# Unlimited history size
HISTSIZE=
HISTFILESIZE=

# Disable less history file (.lesshst)
export LESSHISTFILE=-

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# colored GCC warnings and errors
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# enable color support of ls and also add handy aliases
if [[ -x "/usr/bin/dircolors" ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls -G"
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
    alias diff="diff --color=auto"
fi

# aliases
alias ll="ls -Glh"
alias la="ls -GA"
alias l="ls -GCF"
alias lla="ls -GlAh"
alias p="sudo pacman"
alias vi=$EDITOR
alias g="git"
alias rg="rg --hidden"
alias fd="fd -HI"

# FZF bash extensions
if [[ -f "${HOME}/.local/shell/fzf/completion.bash" ]]; then
    source "${HOME}/.local/shell/fzf/completion.bash"
    source "${HOME}/.local/shell/fzf/key-bindings.bash"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Git prompt and completion source

if [[ -f "/usr/share/git/completion/git-prompt.sh" ]]; then
    . "/usr/share/git/completion/git-prompt.sh"
fi

if [[ -f "/usr/share/git/completion/git-completion.bash" ]]; then
    . "/usr/share/git/completion/git-completion.bash"
fi

if [[ -f "/usr/share/fzf/key-bindings.bash" ]]; then
    . "/usr/share/fzf/key-bindings.bash"
fi

if [[ -f "/usr/share/fzf/completion.bash" ]]; then
    . "/usr/share/fzf/completion.bash"
fi

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# npm path
export PATH="${HOME}/.local/share/npm/bin/:${PATH}"
# yarn path
export PATH="${HOME}/.local/share/yarn/global/node_modules/.bin/:${PATH}"

# Colored PS1 definition
export COLOR_RED="\[\e[91m\]"
export COLOR_GRE="\[\e[92m\]"
export COLOR_YEL="\[\e[93m\]"
export COLOR_BLU="\[\e[94m\]"
export COLOR_MAG="\[\e[95m\]"
export COLOR_CYA="\[\e[96m\]"
export COLOR_WHI="\[\e[97m\]"
export COLOR_RES="\[\e[0m\]"

# PS1 for user
export PS1="${COLOR_RED}\u${COLOR_WHI}@\h ${COLOR_YEL}\w${COLOR_WHI} \\$ ${COLOR_RES}"
