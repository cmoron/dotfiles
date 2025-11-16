# Profile file. Runs on login. Environmental variables are set here.

# Source ~/.bashrc if exists
[[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"

# Default config home dir
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

# Default tools
export EDITOR="nvim"
export BROWSER="firefox"

# NAS env variable for mount script (see $HOME/.local/bin)
export NAS_LOCAL_IP="192.168.1.20"
export NAS_SHARED_PATH="/volume1/NAS_SHARED"

# Local bin PATH
export PATH="${HOME}/.local/bin:${PATH}"
