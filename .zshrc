# ~/.zshrc — shell interactif zsh.
# Org : options · zinit · plugins · completion · tools · aliases · functions ·
#       named dirs · keybindings · hooks · greeting.
# Architecture : zinit en turbo mode → startup < 100ms même avec ~6 plugins.

#───────────────────────────────────────────────────────────────────────────
# 1. OPTIONS
#───────────────────────────────────────────────────────────────────────────

setopt AUTO_CD                  # `dir` au lieu de `cd dir`
setopt AUTO_PUSHD               # cd push automatiquement sur la stack
setopt PUSHD_IGNORE_DUPS        # pas de doublons dans la stack
setopt PUSHD_SILENT             # `cd -<TAB>` montre la stack sans noise
setopt EXTENDED_GLOB            # globs riches : `**/*.rs`, `*(.)`, etc.
setopt GLOB_DOTS                # globs matchent aussi les dotfiles
setopt NUMERIC_GLOB_SORT        # tri numérique naturel
setopt INTERACTIVE_COMMENTS     # `# comment` autorisé dans la ligne
setopt PROMPT_SUBST             # substitution dans PS1 (utile pour starship & hooks)
setopt NO_BEEP                  # pas de bip à la moindre erreur
setopt NOTIFY                   # status des jobs background dès qu'ils finissent

# ── History (les valeurs sont dans .profile : HISTSIZE/HISTFILESIZE/HISTCONTROL) ──
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
# 2. ZINIT (plugin manager, install auto au premier lancement)
#───────────────────────────────────────────────────────────────────────────

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f "${ZINIT_HOME}/zinit.zsh" ]]; then
    print -P "%F{33}▒▒▒%f Installing zinit..."
    command mkdir -p "${ZINIT_HOME:h}"
    command git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

#───────────────────────────────────────────────────────────────────────────
# 3. PLUGINS (turbo mode : chargés après que le prompt soit prêt)
#───────────────────────────────────────────────────────────────────────────

# fast-syntax-highlighting + compinit + cdreplay (init complétion une fois)
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting

# autosuggestions (suggère depuis l'historique, gris à droite du curseur)
zinit wait lucid for \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

# history-substring-search : bind les flèches au chargement du plugin (atload)
# pour éviter "unhandled ZLE widget" si bindkey appelé avant le load
zinit wait lucid for \
    atload"bindkey '^[[A' history-substring-search-up; bindkey '^[[B' history-substring-search-down" \
        zsh-users/zsh-history-substring-search \
    Aloxaf/fzf-tab \
    hlissner/zsh-autopair

# you-should-use : rappel discret quand on tape la commande complète au lieu d'un alias
zinit wait lucid for \
    MichaelAquilina/zsh-you-should-use
export YSU_MESSAGE_POSITION="after"
export YSU_HARDCORE=0   # rappel mais sans bloquer

#───────────────────────────────────────────────────────────────────────────
# 4. COMPLETION STYLING
#───────────────────────────────────────────────────────────────────────────

# Insensible à la casse, partial-word, ordre intelligent
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu no                  # fzf-tab gère le menu
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# fzf-tab : preview enrichi
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons=auto $realpath 2>/dev/null || ls -la $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview '
    case "$realpath" in
        *.md|*.txt|*.py|*.rs|*.toml|*.json|*.yaml|*.yml|*.sh|*.zsh)
            bat --color=always --style=numbers --line-range :100 "$realpath" 2>/dev/null ;;
        *)
            eza -1 --color=always --icons=auto "$realpath" 2>/dev/null || ls -la "$realpath" ;;
    esac'
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border --color=fg:7,bg:-1,hl:4
zstyle ':fzf-tab:*' switch-group ',' '.'

#───────────────────────────────────────────────────────────────────────────
# 5. TOOLS INTEGRATIONS
#───────────────────────────────────────────────────────────────────────────

# Starship : prompt principal
command -v starship >/dev/null && eval "$(starship init zsh)"

# Atuin : historique remplace Ctrl-R par une TUI fuzzy
if command -v atuin >/dev/null; then
    eval "$(atuin init zsh --disable-up-arrow)"  # garde la flèche haut zsh-native
fi

# Zoxide : `z dirname` au lieu de cd (apprend les dossiers fréquents)
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd z)"

# Direnv : env per-projet via .envrc
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

# fzf : keybindings (Ctrl-R remplacé par atuin, Ctrl-T fichier, Alt-C cd)
for _fzf in /usr/share/fzf /usr/share/doc/fzf/examples; do
    if [[ -f "$_fzf/key-bindings.zsh" ]]; then
        source "$_fzf/key-bindings.zsh"
        [[ -f "$_fzf/completion.zsh" ]] && source "$_fzf/completion.zsh"
        break
    fi
done
unset _fzf

# Default fzf flags : preview + UI sobre
export FZF_DEFAULT_OPTS='--height=50% --layout=reverse --border --info=inline'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || eza -1 --color=always --icons=auto {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons=auto {} | head -100'"
[[ -n "$FZF_DEFAULT_COMMAND" ]] || export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

#───────────────────────────────────────────────────────────────────────────
# 6. ALIASES
#───────────────────────────────────────────────────────────────────────────

# ls → eza (avec icônes/git, fallback ls si eza absent)
if command -v eza >/dev/null; then
    alias ls='eza --color=auto --icons=auto --group-directories-first'
    alias ll='eza -l --color=auto --icons=auto --group-directories-first --git'
    alias la='eza -a --color=auto --icons=auto --group-directories-first'
    alias lla='eza -la --color=auto --icons=auto --group-directories-first --git'
    alias lt='eza --tree --level=2 --color=auto --icons=auto'
    alias ltt='eza --tree --level=3 --color=auto --icons=auto'
else
    alias ls='ls --color=auto'
    alias ll='ls -lh'
    alias la='ls -A'
    alias lla='ls -lAh'
fi

# cat → bat (avec syntax highlight)
if command -v bat >/dev/null; then
    alias cat='bat --paging=never --style=plain'
    alias bcat='bat'  # bat complet avec line numbers + git diff
    export BAT_THEME='Coldark-Dark'
fi

# Standards
alias g='git'
alias rg='rg --hidden'
alias fd='fd -HI'
alias vim='nvim'
alias vi='nvim'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias path='echo $PATH | tr ":" "\n"'
alias reload='source ${ZDOTDIR:-$HOME}/.zshrc && rehash && echo "zshrc rechargé"'
alias zshconf='${EDITOR:-nvim} ~/.zshrc'
alias dot='cd ~/conf/dotfiles'                   # raccourci dotfiles

# Git shortcuts (en plus des alias dans .config/git/config)
alias gst='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git push'
alias gpl='git pull'

# Suffix aliases : `./file.rs` ouvre dans nvim, `./file.json` aussi, etc.
alias -s {rs,py,ts,tsx,js,jsx,md,toml,yaml,yml,json,sh,zsh,conf,txt}='${EDITOR:-nvim}'

# Global aliases : `cmd G pattern` = `cmd | grep pattern`
alias -g G='| grep -i --color=auto'
alias -g L='| less -R'
alias -g H='| head'
alias -g T='| tail'
alias -g C='| wc -l'
alias -g NUL='>/dev/null 2>&1'

#───────────────────────────────────────────────────────────────────────────
# 7. FUNCTIONS
#───────────────────────────────────────────────────────────────────────────

# take : mkdir + cd en une commande
take() {
    [[ -z "$1" ]] && { echo "usage: take <dir>"; return 1; }
    mkdir -p "$1" && cd "$1"
}

# extract : détecte le format et extrait (zip, tar.gz, tar.bz2, tar.xz, 7z, rar, …)
extract() {
    [[ -z "$1" ]] && { echo "usage: extract <archive>"; return 1; }
    [[ ! -f "$1" ]] && { echo "extract: '$1' not found"; return 1; }
    case "$1" in
        *.tar.bz2|*.tbz2)   tar xjf "$1"        ;;
        *.tar.gz|*.tgz)     tar xzf "$1"        ;;
        *.tar.xz|*.txz)     tar xJf "$1"        ;;
        *.tar)              tar xf  "$1"        ;;
        *.zip)              unzip "$1"          ;;
        *.7z)               7z x "$1"           ;;
        *.rar)              unrar x "$1"        ;;
        *.gz)               gunzip "$1"         ;;
        *.bz2)              bunzip2 "$1"        ;;
        *.xz)               unxz "$1"           ;;
        *.Z)                uncompress "$1"     ;;
        *)                  echo "extract: format non reconnu: $1"; return 1 ;;
    esac
}

# weather : météo locale (ou ville en argument) via wttr.in
weather() {
    local loc="${1:-}"
    curl -s "wttr.in/${loc}?format=v2&lang=fr"
}

# cheat : antisèche pour une commande (cht.sh)
cheat() {
    [[ -z "$1" ]] && { echo "usage: cheat <command> [query]"; return 1; }
    curl -s "cht.sh/$1${2:+/${(j:+:)@:2}}"
}

# serve : sert le dossier courant sur :8000 (bun préféré, sinon python)
serve() {
    local port="${1:-8000}"
    if command -v bun >/dev/null; then
        bun --bun x serve -l "$port" .
    else
        python3 -m http.server "$port"
    fi
}

# mkv : nouveau venv uv au cwd
mkv() {
    command -v uv >/dev/null || { echo "uv pas installé"; return 1; }
    uv venv "${1:-.venv}" && echo "→ source ${1:-.venv}/bin/activate"
}

# gbf : git branch fuzzy switch (Ctrl-G binding aussi)
gbf() {
    local branch
    branch=$(git branch --all --color=always | grep -v HEAD |
        fzf --ansi --no-multi --preview 'git log -20 --oneline --color=always {-1}') || return
    git switch "${${branch##*/}%% *}"
}

# fkill : kill un process via fzf
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf --multi --header='[kill:process]' | awk '{print $2}')
    [[ -n "$pid" ]] && echo "$pid" | xargs kill -"${1:-15}"
}

# gi : génère un .gitignore via gitignore.io
gi() {
    [[ -z "$1" ]] && { echo "usage: gi <lang1,lang2,…>"; return 1; }
    curl -sL "https://www.toptal.com/developers/gitignore/api/$*"
}

# cdr : cd vers la racine du repo git courant
cdr() { cd "$(git rev-parse --show-toplevel)" 2>/dev/null || echo "pas dans un repo git"; }

#───────────────────────────────────────────────────────────────────────────
# 8. NAMED DIRECTORIES (utilisables comme `cd ~dot`, `cd ~claude`, …)
#───────────────────────────────────────────────────────────────────────────

hash -d dot=${HOME}/conf/dotfiles
hash -d claude=${HOME}/.claude
hash -d src=${HOME}/src
hash -d conf=${HOME}/.config
hash -d cache=${XDG_CACHE_HOME}

#───────────────────────────────────────────────────────────────────────────
# 9. KEYBINDINGS (widgets custom)
#───────────────────────────────────────────────────────────────────────────

bindkey -e                                    # emacs mode (par défaut)

# Note : les bindkey pour history-substring-search-up/down sont définis via
# `atload` au chargement du plugin (voir section 3), pour éviter le warning
# "unhandled ZLE widget" de fast-syntax-highlighting.

# Custom widgets
_gbf-widget() { gbf; zle reset-prompt }
zle -N _gbf-widget
bindkey '^G' _gbf-widget                      # Ctrl-G : fuzzy git branch switch

# Edit current command line in $EDITOR (Ctrl-X Ctrl-E)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

#───────────────────────────────────────────────────────────────────────────
# 10. HOOKS (titre de tab, notif si commande longue)
#───────────────────────────────────────────────────────────────────────────

autoload -Uz add-zsh-hook
zmodload zsh/datetime  # pour EPOCHSECONDS

# Titre de tab terminal (kitty / iTerm2 / autres) : commande en cours sinon cwd
_set-title-precmd()  { print -Pn '\e]0;%n@%m:%~\a' }
_set-title-preexec() { print -Pn "\e]0;${1//[^[:print:]]/}\a" }
add-zsh-hook precmd  _set-title-precmd
add-zsh-hook preexec _set-title-preexec

# Notif desktop si commande > 30s
_notif-preexec() { _cmd_start=$EPOCHSECONDS; _cmd_name="$1" }
_notif-precmd()  {
    local last_status=$?
    [[ -z "$_cmd_start" ]] && return
    local elapsed=$(( EPOCHSECONDS - _cmd_start ))
    if (( elapsed > 30 )) && command -v notify-send >/dev/null; then
        local status_text="done"; (( last_status != 0 )) && status_text="failed"
        notify-send "shell" "${_cmd_name} (${elapsed}s, ${status_text})" &>/dev/null
    fi
    unset _cmd_start _cmd_name
}
add-zsh-hook preexec _notif-preexec
add-zsh-hook precmd  _notif-precmd

#───────────────────────────────────────────────────────────────────────────
# 11. GREETING (première session du jour seulement, sinon silencieux)
#───────────────────────────────────────────────────────────────────────────

_zsh-greet() {
    local greet_file="${XDG_CACHE_HOME:-$HOME/.cache}/zsh-last-greet"
    local today=$(date +%Y-%m-%d)
    local last=""
    [[ -f "$greet_file" ]] && last=$(< "$greet_file")
    [[ "$today" == "$last" ]] && return

    mkdir -p "${greet_file:h}"
    echo "$today" > "$greet_file"

    local hour=$(date +%H)
    local mood
    if   (( hour < 6 ));   then mood="encore là à cette heure"
    elif (( hour < 12 ));  then mood="bonjour"
    elif (( hour < 14 ));  then mood="bon midi"
    elif (( hour < 18 ));  then mood="bon après-midi"
    elif (( hour < 22 ));  then mood="bonsoir"
    else                        mood="bonne nuit"
    fi

    local date_fr=$(date "+%A %-d %B %Y · %Hh%M")
    print -P ""
    print -P "  %F{8}─%f %F{6}${mood}%f %F{8}·%f %F{7}${date_fr}%f %F{8}─%f"

    # Repo info si on est dans un git repo
    if git rev-parse --show-toplevel &>/dev/null; then
        local repo=$(basename "$(git rev-parse --show-toplevel)")
        local branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo detached)
        local dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        local dirty_text
        if (( dirty == 0 )); then dirty_text="%F{2}clean%f"
        else dirty_text="%F{3}${dirty} fichier(s) modifié(s)%f"
        fi
        print -P "  %F{8}─%f repo %F{4}${repo}%f sur %F{5}${branch}%f %F{8}·%f ${dirty_text}"
    fi

    # Tip random (1 chance sur 3)
    local tips=(
        "tip · %F{6}take dir-name%f pour mkdir+cd"
        "tip · %F{6}z dot%f pour revenir aux dotfiles depuis n'importe où"
        "tip · %F{6}Ctrl-R%f : atuin TUI · %F{6}Alt-C%f : zoxide cd fuzzy"
        "tip · %F{6}Ctrl-G%f : fuzzy git branch switch"
        "tip · %F{6}weather%f, %F{6}cheat git rebase%f, %F{6}gi rust,macos%f"
        "tip · %F{6}extract foo.tar.gz%f détecte le format tout seul"
        "tip · %F{6}gbf%f / %F{6}fkill%f / %F{6}cdr%f (root du repo git)"
        "tip · %F{6}cmd G pattern%f = pipe vers grep (alias global)"
        "tip · %F{6}reload%f recharge le .zshrc sans relancer le shell"
    )
    if (( RANDOM % 3 == 0 )); then
        local n=$(( RANDOM % ${#tips[@]} + 1 ))
        print -P "  %F{8}─%f ${tips[$n]}"
    fi
    print -P ""
}
_zsh-greet
