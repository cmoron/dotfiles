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

# Shell options
shopt -s autocd 2>/dev/null     # cd en tapant le nom du dossier (bash 4+, silencieux sur bash 3.2)
shopt -s histappend             # append plutôt qu'overwrite l'historique
shopt -s checkwinsize           # met à jour LINES/COLUMNS après chaque commande
#shopt -s globstar              # ** matche récursivement (désactivé)

# Note : HISTSIZE/HISTFILESIZE/HISTCONTROL sont dans .profile (env).

# enable color support of ls and also add handy aliases
if [[ -x "/usr/bin/dircolors" ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=auto"
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
    alias diff="diff --color=auto"
fi

# aliases
alias ll="ls -lh"
alias la="ls -A"
alias l="ls -CF"
alias lla="ls -lAh"
command -v pacman >/dev/null && alias p="sudo pacman"
alias g="git"
alias rg="rg --hidden"
alias fd="fd -HI"
alias vim="nvim"
alias vi="nvim"

# FZF shell integration (Arch / Debian)
for _fzf_dir in /usr/share/fzf /usr/share/doc/fzf/examples; do
    if [[ -f "$_fzf_dir/key-bindings.bash" ]]; then
        source "$_fzf_dir/key-bindings.bash"
        [[ -f "$_fzf_dir/completion.bash" ]] && source "$_fzf_dir/completion.bash"
        break
    fi
done
unset _fzf_dir

# Git prompt + completion
for _git_sh in /usr/lib/git-core/git-sh-prompt; do
    [[ -f "$_git_sh" ]] && { . "$_git_sh"; break; }
done

for _git_comp in /usr/share/git/completion/git-completion.bash; do
    [[ -f "$_git_comp" ]] && { . "$_git_comp"; break; }
done
unset _git_sh _git_comp

# PS1 — utilisateur en rouge (root en bleu), host, cwd, branche git
COLOR_RED="\[\e[91m\]"
COLOR_BLU="\[\e[94m\]"
COLOR_YEL="\[\e[93m\]"
COLOR_WHI="\[\e[97m\]"
COLOR_RES="\[\e[0m\]"

if (( EUID == 0 )); then
    _user_color="$COLOR_BLU"
else
    _user_color="$COLOR_RED"
fi
PS1="${_user_color}\u${COLOR_WHI}@\h ${COLOR_YEL}\w${COLOR_WHI}\$(__git_ps1) \\$ ${COLOR_RES}"
unset _user_color

# Machine-specific shell config (untracked, optional)
[ -f "${HOME}/.bashrc.local" ] && . "${HOME}/.bashrc.local"
