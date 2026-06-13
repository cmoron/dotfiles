# Profile file. Runs on login. Environmental variables are set here.

# Default config home dir
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_STATE_HOME="${HOME}/.local/state"

# Default tools
export EDITOR="nvim"
export BROWSER="firefox"

# History (bash + less). Toutes les history settings ensemble.
# HISTSIZE/HISTFILESIZE vides = historique bash illimité.
export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL=ignoreboth
export LESSHISTFILE=-

# NAS env variable for mount script (see $HOME/.local/bin)
export NAS_LOCAL_IP="192.168.1.20"
export NAS_SHARED_PATH="/volume1/NAS_SHARED"

# PATH
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/.cargo/bin:${PATH}"

# uv
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# atuin (binaire installé hors apt, dans ~/.atuin/bin)
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# less
export LESS='-R'
if _lp=$(command -v src-hilite-lesspipe.sh 2>/dev/null); then
    export LESSOPEN="| $_lp %s"
fi
unset _lp

# colored GCC warnings and errors
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# Machine-specific overrides (untracked, optional)
[ -f "${HOME}/.profile.local" ] && . "${HOME}/.profile.local"

# Source ~/.bashrc for bash interactive shells (skip if zsh sources .profile via .zprofile)
[ -n "$BASH_VERSION" ] && [ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
