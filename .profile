# Profile file. Runs on login. Environmental variables are set here.

# Default config home dir
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"

# Default tools
export EDITOR="nvim"
export BROWSER="firefox"

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

# less
export LESSHISTFILE=-
export LESS=' -R '
[ -x /usr/bin/src-hilite-lesspipe.sh ] && export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"

# colored GCC warnings and errors
export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# Pre-start claude-mem worker to avoid SessionStart race condition on first Claude Code launch
_CMEM="$HOME/.claude/plugins/marketplaces/thedotmack/plugin"
if [ -f "$_CMEM/scripts/bun-runner.js" ] && ! curl -sf http://localhost:37777/api/health &>/dev/null; then
  node "$_CMEM/scripts/bun-runner.js" "$_CMEM/scripts/worker-service.cjs" start &>/dev/null &
  disown
fi
unset _CMEM

# Machine-specific overrides (untracked, optional)
[ -f "${HOME}/.profile.local" ] && . "${HOME}/.profile.local"

# Source ~/.bashrc for interactive shell setup (last, so env is ready)
[[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"
