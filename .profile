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
# Homebrew (macOS)
[ -d /opt/homebrew/bin ] && export PATH="/opt/homebrew/bin:${PATH}"
# GNU coreutils on macOS (ls, dircolors, diff, ... à la Linux)
[ -d /opt/homebrew/opt/coreutils/libexec/gnubin ] && export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:${PATH}"

# uv
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# atuin (si installé via le script officiel, dans ~/.atuin/bin ;
# via Homebrew le binaire est déjà dans le PATH)
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# less
export LESS='-R'
if _lp=$(command -v src-hilite-lesspipe.sh 2>/dev/null); then
    export LESSOPEN="| $_lp %s"
fi
unset _lp

# colored GCC warnings and errors
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# Pre-start claude-mem worker to avoid SessionStart race on first Claude Code launch.
# Shells interactifs uniquement : .profile est sourcé par .zshenv pour TOUS les zsh,
# on ne veut pas spawn le worker sur chaque `zsh -c` ou script.
# POSIX-only : sourcé par bash ET par zsh (emulate sh). `&` met en arrière-plan,
# '{}' en stdin pour que bun-runner ne traite pas un stdin vide comme erreur (#2188).
case $- in
  *i*)
    _CMEM="$HOME/.claude/plugins/marketplaces/thedotmack/plugin"
    if [ -f "$_CMEM/scripts/bun-runner.js" ]; then
      echo '{}' | node "$_CMEM/scripts/bun-runner.js" "$_CMEM/scripts/worker-service.cjs" start >/dev/null 2>&1 &
      disown 2>/dev/null
    fi
    unset _CMEM
    ;;
esac

# Machine-specific overrides (untracked, optional)
[ -f "${HOME}/.profile.local" ] && . "${HOME}/.profile.local"

# Source ~/.bashrc for bash interactive shells (skip if zsh sources .profile via .zshenv)
[ -n "$BASH_VERSION" ] && [ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
