# Profile file. Runs on login. Environmental variables are set here.


# Source ~/.bashrc if exists
[[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"

# Default config home dir
export XDG_CONFIG_HOME="${HOME}/.config"

# Default tools
export EDITOR="vim"
export TERMINAL="kitty"
export BROWSER="firefox"

# NAS env variable for mount script (see $HOME/.local/bin)
export NAS_LOCAL_IP="192.168.1.20"
export NAS_SHARED_PATH="/volume1/NAS_SHARED"

# Local bin PATH
export PATH="${HOME}/.local/bin:${PATH}"
