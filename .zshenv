# ~/.zshenv — sourcé par TOUS les zsh (login, interactif, scripts, `zsh -c`).
# On y source .profile pour que PATH & env soient présents partout — y compris
# dans un zsh interactif NON-login (nouveau tab terminal) ou un `zsh -c`.
# .profile garde lui-même ses effets de bord (prewarm claude-mem) en interactif.

[ -f "${HOME}/.profile" ] && emulate sh -c '. "${HOME}/.profile"'

typeset -U path PATH   # PATH sans doublons (si shells zsh imbriqués)
