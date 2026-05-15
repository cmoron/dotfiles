# ~/.zshenv — sourcé par TOUS les zsh (login, interactif, scripts).
# Garde minimal : tout ce qui doit être présent même pour `zsh -c "cmd"`.
# Les vraies vars d'env (PATH, EDITOR, etc.) sont dans .profile, sourcé par .zprofile.

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
