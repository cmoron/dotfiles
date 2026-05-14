# ~/.zprofile — sourcé une fois au login (avant .zshrc).
# Réutilise le .profile POSIX (PATH, EDITOR, NAS_*, claude-mem prewarm, etc.).
# Le .profile guarde lui-même le source de .bashrc via $BASH_VERSION,
# donc zsh ne se tire pas une balle dans le pied.

[ -f "${HOME}/.profile" ] && emulate sh -c '. "${HOME}/.profile"'
