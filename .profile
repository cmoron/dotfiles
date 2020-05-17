# Profile file. Runs on login. Environmental variables are set here.

# Source ~/.bashrc if exists
[[ -f "${HOME}/.bashrc" ]] && source "${HOME}/.bashrc"

# Default config home dir
export XDG_CONFIG_HOME="${HOME}/.config"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

# Default tools
export EDITOR="vim"

# Local bin PATH
export PATH="${HOME}/.local/bin:${PATH}"
