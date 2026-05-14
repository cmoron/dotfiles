# dotfiles

Configuration personnelle pour **Arch Linux** (poste principal, X11 + i3) et
**macOS** (subset shell + éditeur + git).

## Structure

| Fichier / dossier        | Rôle                                                   |
|--------------------------|--------------------------------------------------------|
| `.profile`               | Variables d'env, PATH, sourcing `.bashrc` (login)      |
| `.bash_profile` → symlink vers `.profile`                                          |
| `.bashrc`                | Shell interactif : prompt, aliases, fzf, git-prompt    |
| `.xinitrc` / `.xprofile` | Session X11 (Arch uniquement)                          |
| `.config/i3/`            | Window manager (Arch)                                  |
| `.config/i3blocks/` `.config/i3status/` | Barres de statut i3                     |
| `.config/sxhkd/`         | Hotkeys X11                                            |
| `.config/dunst/`         | Démon de notifications                                 |
| `.config/picom/`         | Compositeur X11 (transparence, ombres)                 |
| `.config/kitty/`         | Émulateur de terminal                                  |
| `.config/nvim/`          | Neovim (lazy-lock géré séparément dans `nvim-config`)  |
| `.config/git/`           | Config git globale + ignore                            |
| `.config/sxiv/`          | Viewer d'images                                        |
| `.local/bin/`            | Scripts utilitaires (`setbg`, `mount_nas`, statusbar)  |
| `.local/share/fonts/`    | Polices (Hack, Roboto, FontAwesome, Ubuntu Mono, …)    |
| `progs.csv`              | Liste de paquets Arch (pacman/AUR)                     |

## Installation

Les fichiers se déploient par symlinks depuis ce repo vers `$HOME` (stow, ou à
la main). Convention : ce repo est cloné dans `~/conf/dotfiles/` et les
symlinks pointent ici.

### Arch Linux

1. Installer les paquets listés dans [`progs.csv`](progs.csv) (script
   pacman/yay ad hoc — format CSV : `package, description`).
2. Symlinker `.profile`, `.bashrc`, `.bash_profile`, `.xinitrc`, `.xprofile`
   et les dossiers `.config/*` et `.local/*` vers `$HOME`.
3. Démarrer X11 via `startx` (lance `i3` via `.xinitrc`).

### macOS

Prérequis Homebrew :

```sh
brew install bash coreutils fzf bash-completion git neovim ripgrep fd
```

- **`coreutils`** — fournit `dircolors`, `gls`, `gdiff`, … Le `.profile`
  préfixe `/opt/homebrew/opt/coreutils/libexec/gnubin` au `PATH`, ce qui rend
  ces commandes disponibles **sans préfixe `g`**. Requis pour la colorisation
  `ls` via `~/.dircolors` et pour l'alias `diff --color=auto`.
- **`bash`** — le bash natif de macOS est en 3.2 (figé pour licence GPLv3) ;
  on a besoin de bash 4+ pour `shopt -s autocd` et certains usages bash
  modernes. Pour activer le shell, ajouter `/opt/homebrew/bin/bash` à
  `/etc/shells` et `chsh -s /opt/homebrew/bin/bash`.
- **`fzf`** — `.bashrc` source `key-bindings.bash` et `completion.bash` depuis
  `/opt/homebrew/opt/fzf/shell`.
- **`bash-completion`** + **`git`** — pour `git-prompt.sh` (PS1
  `__git_ps1`) et la complétion git, sourcés depuis
  `/opt/homebrew/etc/bash_completion.d/`.

L'environnement X11 (`.xinitrc`, `.xprofile`, `i3`, `picom`, `sxhkd`, `dunst`,
…) ne s'applique pas sur macOS.

## Shell

- **Prompt** PS1 avec utilisateur (rouge pour user, bleu pour root), host,
  cwd, et branche git (via `__git_ps1`).
- **Aliases** principaux : `ll`/`la`/`l`/`lla`, `g=git`, `vim`/`vi=nvim`,
  `rg=rg --hidden`, `fd=fd -HI`.
- **fzf** : raccourcis clavier (`Ctrl-R`, `Ctrl-T`, `Alt-C`) + complétion.
- **Historique** illimité (`HISTSIZE=` / `HISTFILESIZE=`),
  `HISTCONTROL=ignoreboth`.

## Outils tiers attendus dans le `PATH`

Le `.profile` ajoute les répertoires suivants au `PATH` s'ils existent :

| Préfixe                                       | Outil                       |
|-----------------------------------------------|-----------------------------|
| `~/.local/bin`                                 | scripts du repo + uv        |
| `~/.cargo/bin`                                 | binaires Rust (cargo install)|
| `~/.bun/bin`                                   | bun (runtime / package mgr) |
| `/opt/homebrew/bin`                            | Homebrew (macOS)            |
| `/opt/homebrew/opt/coreutils/libexec/gnubin`   | GNU coreutils (macOS)       |
