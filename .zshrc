# ~/.zshrc — shell interactif zsh.
# Org : options · completion · tools · aliases · keybindings · hooks · local.

#───────────────────────────────────────────────────────────────────────────
# 1. OPTIONS
#───────────────────────────────────────────────────────────────────────────

setopt AUTO_CD                  # `dir` au lieu de `cd dir`
setopt AUTO_PUSHD               # cd empile l'ancien dir (cd -, cd -2, dirs -v)
setopt PUSHD_IGNORE_DUPS        # pas de doublons dans la pile
setopt PUSHD_SILENT             # `cd -<TAB>` montre la pile sans noise
setopt EXTENDED_GLOB            # globs riches : `**/*.rs`, `*(.)`, etc.
setopt GLOB_DOTS                # globs matchent aussi les dotfiles
setopt NUMERIC_GLOB_SORT        # tri numérique naturel
setopt INTERACTIVE_COMMENTS     # `# comment` autorisé en ligne de commande
setopt PROMPT_SUBST             # substitution dans PS1 (utile pour starship & hooks)
setopt NO_BEEP                  # pas de bip à la moindre erreur
setopt NOTIFY                   # status des jobs background dès qu'ils finissent

# WORDCHARS : retire `/` pour que Ctrl-W s'arrête aux séparateurs de chemin
# (ex: `xxx/yyy` → supprime juste `yyy` puis `/`). Default zsh inclut `/`.
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# ── History ──
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=1000000              # taille en mémoire
SAVEHIST=1000000              # taille du fichier
setopt SHARE_HISTORY          # historique partagé entre sessions live
setopt EXTENDED_HISTORY       # `:start:elapsed;cmd` (timestamps)
setopt HIST_IGNORE_DUPS       # pas deux entrées identiques consécutives
setopt HIST_IGNORE_ALL_DUPS   # dédupe global, garde la plus récente
setopt HIST_IGNORE_SPACE      # ignore les commandes commençant par espace
setopt HIST_REDUCE_BLANKS     # normalise les espaces
setopt HIST_VERIFY            # `!!` montre la commande avant de la lancer
setopt HIST_FIND_NO_DUPS      # search dans l'historique : pas de doublons

#───────────────────────────────────────────────────────────────────────────
# 2. COMPLETION (native, sans plugin)
#───────────────────────────────────────────────────────────────────────────

autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select               # menu navigable aux flèches
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

#───────────────────────────────────────────────────────────────────────────
# 3. TOOLS INTEGRATIONS
#───────────────────────────────────────────────────────────────────────────

# Starship : prompt principal
command -v starship >/dev/null && eval "$(starship init zsh)"

# Atuin : historique fuzzy sur Ctrl-R (garde la flèche haut zsh-native)
command -v atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

# fzf : keybindings natifs (Ctrl-T fichier, Alt-C cd), flags par défaut
for _fzf in /usr/share/fzf /usr/share/doc/fzf/examples; do
    if [[ -f "$_fzf/key-bindings.zsh" ]]; then
        source "$_fzf/key-bindings.zsh"
        [[ -f "$_fzf/completion.zsh" ]] && source "$_fzf/completion.zsh"
        break
    fi
done
unset _fzf

#───────────────────────────────────────────────────────────────────────────
# 4. ALIASES (pur renommage : nom court, paramètres tapés à la main)
#───────────────────────────────────────────────────────────────────────────

alias ls='ls --color=auto'    # couleur seule (affichage, pas un paramètre)
alias ll='ls -lh'             # cas particuliers : conventions ls universelles
alias la='ls -A'
alias l='ls -CF'
alias lla='ls -lAh'
alias g='git'
alias vi='nvim'
alias vim='nvim'
alias dot='cd ~/src/dotfiles'
alias reload='source ${ZDOTDIR:-$HOME}/.zshrc && rehash && echo "zshrc rechargé"'
alias zshconf='${EDITOR:-nvim} ~/.zshrc'

#───────────────────────────────────────────────────────────────────────────
# 5. KEYBINDINGS
#───────────────────────────────────────────────────────────────────────────

bindkey -e                                    # emacs mode (par défaut)

#───────────────────────────────────────────────────────────────────────────
# 6. HOOKS (titre de tab, curseur)
#───────────────────────────────────────────────────────────────────────────

autoload -Uz add-zsh-hook

# Force le curseur en block clignotant à chaque prompt (DECSCUSR \e[1 q).
_force-cursor-block() { printf '\e[1 q' }
add-zsh-hook precmd _force-cursor-block

# Titre de tab terminal (kitty / autres) : user@host:cwd
_set-title-precmd()  { print -Pn '\e]0;%n@%m:%~\a' }
_set-title-preexec() { print -Pn "\e]0;${1//[^[:print:]]/}\a" }
add-zsh-hook precmd  _set-title-precmd
add-zsh-hook preexec _set-title-preexec

#───────────────────────────────────────────────────────────────────────────
# 7. LOCAL OVERRIDES (config machine-specific, non versionnée)
#───────────────────────────────────────────────────────────────────────────

# Sourcé en dernier pour pouvoir surcharger aliases, options et tools.
# Pendant POSIX/env, voir ~/.profile.local (via .zprofile).
[[ -f "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"
