# ~/.zshrc — shell interactif zsh.
# Org : options · completion · tools · aliases · keybindings · hooks ·
#       plugins · local.

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

# ls → eza si dispo (icônes + couleurs pastel), sinon fallback ls natif.
# ll/la/l/lla = conventions universelles.
if command -v eza >/dev/null; then
    alias ls='eza --color=auto --icons=auto --group-directories-first'
    alias ll='eza -l --color=auto --icons=auto --group-directories-first --git'
    alias la='eza -a --color=auto --icons=auto --group-directories-first'
    alias l='eza --color=auto --icons=auto --group-directories-first'
    alias lla='eza -la --color=auto --icons=auto --group-directories-first --git'

    # Thème pastel (palette Catppuccin Mocha). eza 0.18 n'a pas encore de
    # theme.yml → on colore via EZA_COLORS, extension de LS_COLORS.
    # Codes : 38;2;R;G;B (truecolor) ; suffixe ;1 = gras, ;4 = souligné.
    EZA_COLORS="di=38;2;137;180;250;1:ex=38;2;166;227;161;1:fi=38;2;205;214;244"
    EZA_COLORS+=":ln=38;2;148;226;213:or=38;2;243;139;168:pi=38;2;147;153;178"
    EZA_COLORS+=":so=38;2;147;153;178:bd=38;2;250;179;135:cd=38;2;250;179;135"
    EZA_COLORS+=":ur=38;2;249;226;175:uw=38;2;250;179;135:ux=38;2;166;227;161"
    EZA_COLORS+=":ue=38;2;166;227;161:gr=38;2;186;194;222:gw=38;2;250;179;135"
    EZA_COLORS+=":gx=38;2;166;227;161:tr=38;2;166;173;200:tw=38;2;250;179;135"
    EZA_COLORS+=":tx=38;2;166;227;161:su=38;2;203;166;247:sf=38;2;203;166;247"
    EZA_COLORS+=":uu=38;2;249;226;175:un=38;2;166;173;200:gu=38;2;186;194;222"
    EZA_COLORS+=":gn=38;2;166;173;200:da=38;2;137;220;235:sn=38;2;148;226;213"
    EZA_COLORS+=":sb=38;2;166;173;200:ga=38;2;166;227;161:gm=38;2;249;226;175"
    EZA_COLORS+=":gd=38;2;243;139;168:gv=38;2;148;226;213:gt=38;2;203;166;247"
    EZA_COLORS+=":xx=38;2;147;153;178:hd=38;2;180;190;254;4:lp=38;2;148;226;213"
    export EZA_COLORS
else
    alias ls='ls --color=auto'
    alias ll='ls -lh'
    alias la='ls -A'
    alias l='ls -CF'
    alias lla='ls -lAh'
fi
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
# 7. PLUGINS (clonés par install-zsh-setup, sourcés si présents)
#───────────────────────────────────────────────────────────────────────────

ZSH_PLUGINS="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

# Coloration de la commande pendant la frappe : vert = commande valide,
# rouge = introuvable. À sourcer avant les autosuggestions.
_p="$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$_p" ]] && source "$_p"

# Suggestion grise depuis l'historique (→ ou Ctrl-E pour accepter).
_p="$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$_p" ]] && source "$_p"
unset _p

#───────────────────────────────────────────────────────────────────────────
# 8. LOCAL OVERRIDES (config machine-specific, non versionnée)
#───────────────────────────────────────────────────────────────────────────

# Sourcé en dernier pour pouvoir surcharger aliases, options et tools.
# Pendant POSIX/env, voir ~/.profile.local (via .zprofile).
[[ -f "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"
