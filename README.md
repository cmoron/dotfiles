# dotfiles (branche `MACOS`)

Configuration personnelle pour **macOS** : shell (bash **et** zsh), neovim,
kitty, git.

> La configuration Arch Linux (X11 + i3 + sxhkd + picom + dunst + …) vit sur
> la branche [`master`](../../tree/master) — cette branche `MACOS` est durable
> et séparée, jamais mergée vers master.

## Structure

| Fichier / dossier         | Rôle                                                |
|---------------------------|-----------------------------------------------------|
| `.profile`                | Variables d'env (PATH, HIST*, EDITOR, …), POSIX     |
| `.bash_profile`           | Symlink vers `.profile`                             |
| `.bashrc`                 | Shell bash interactif (prompt, aliases, fzf)        |
| `.zshenv`                 | Sourcé par tout zsh, source `.profile` (env + PATH) |
| `.zprofile`               | Volontairement vide (l'env passe par `.zshenv`)     |
| `.zshrc`                  | Shell zsh interactif (options, plugins, starship, …)|
| `.config/starship.toml`   | Config du prompt Starship (zsh + bash)              |
| `.config/atuin/config.toml` | Config Atuin (historique TUI fuzzy)               |
| `.config/eza/theme.yml`   | Thème de couleurs pour `eza`                        |
| `.config/kitty/`          | Émulateur de terminal                               |
| `.config/ghostty/`        | Émulateur de terminal (force `zsh --login`)         |
| `.config/nvim/`           | Neovim (lazy-lock géré dans `nvim-config`)          |
| `.config/git/`            | Config git globale + ignore                         |
| `.local/bin/`             | Scripts utilitaires (`install-zsh-setup`, …)        |
| `.local/share/fonts/`     | Polices (Hack, Roboto, FontAwesome, Ubuntu Mono, …) |

D'autres répertoires `.config/*` (`i3`, `i3blocks`, `i3status`, `picom`,
`sxhkd`, `dunst`, `sxiv`) sont des restes de la conf Linux non utilisés sur
macOS. Idem pour `progs.csv` (paquets Arch). Conservés pour limiter la
divergence avec `master`.

## Installation

Convention : repo cloné dans `~/conf/dotfiles/`, fichiers déployés par
symlinks vers `$HOME`.

### Setup zsh (recommandé) — one-shot

```sh
~/conf/dotfiles/.local/bin/install-zsh-setup
```

Le script :
1. `brew install` les outils manquants (`starship`, `atuin`, `eza`, `fzf`)
2. Clone les plugins zsh (`zsh-syntax-highlighting`, `zsh-autosuggestions`)
   dans `~/.local/share/zsh/plugins/`
3. Symlink `.profile`, `.zshenv`, `.zprofile`, `.zshrc` et
   `.config/{starship.toml,atuin/config.toml,eza/theme.yml}` vers `$HOME`
4. Propose d'activer zsh comme shell par défaut (`chsh`)

Idempotent : peut être relancé sans casse.

### Prérequis bash (avant ou en plus de zsh)

```sh
brew install bash coreutils fzf bash-completion git neovim ripgrep fd
```

- **`coreutils`** — `dircolors`, GNU `ls`, GNU `diff`, … `.profile` préfixe
  `/opt/homebrew/opt/coreutils/libexec/gnubin` au `PATH`.
- **`bash`** — bash 4+ requis ; activer via `chsh -s /opt/homebrew/bin/bash`
  (après avoir ajouté à `/etc/shells`).
- **`fzf`** — `.bashrc` et `.zshrc` sourcent ses key-bindings depuis
  `/opt/homebrew/opt/fzf/shell`.
- **`bash-completion`** + **`git`** — `git-prompt.sh` et complétion git.

### Polices (optionnel mais joli)

Pour les icônes dans `eza` et certains glyphs Starship :

```sh
brew install --cask font-hack-nerd-font
```

Puis configurer kitty/Ghostty pour utiliser "Hack Nerd Font".

## Stack zsh — qu'est-ce qui est dedans

Config volontairement **minimale** : pas de plugin manager, pas de gadgets.
Deux plugins sourcés en clair, le reste est natif zsh.

**Plugins** (clonés par `install-zsh-setup` dans `~/.local/share/zsh/plugins/`,
sourcés s'ils sont présents) :

| Plugin                                | Effet                                              |
|---------------------------------------|----------------------------------------------------|
| `zsh-syntax-highlighting`             | Highlight de la commande pendant la frappe         |
| `zsh-autosuggestions`                 | Suggestion grise depuis l'historique               |

**Outils intégrés** :
- **[Starship](https://starship.rs/)** — prompt configurable, palette custom
  (voir [`.config/starship.toml`](.config/starship.toml)).
- **[Atuin](https://atuin.sh/)** — historique TUI fuzzy ; remplace `Ctrl-R`.
  Flèche haut native zsh conservée. Mode local par défaut (pas de sync cloud).
- **[eza](https://eza.rocks/)** — `ls` moderne, alias par défaut, thème dans
  [`.config/eza/theme.yml`](.config/eza/theme.yml).
- **[fzf](https://github.com/junegunn/fzf)** — key-bindings natifs `Ctrl-T` /
  `Alt-C`.

## Aliases (zsh)

Pur renommage — nom court, paramètres tapés à la main.

| Cmd                  | Effet                                                          |
|----------------------|----------------------------------------------------------------|
| `ls` / `l`           | `eza` (icônes + couleurs), fallback `ls` natif si eza absent   |
| `ll` / `lla`         | `eza` long (`-lg` / `-lag --git`)                              |
| `la`                 | `eza -a` (inclut les dotfiles)                                 |
| `g`                  | `git`                                                          |
| `vi` / `vim`         | `nvim`                                                         |
| `z`                  | `zellij`                                                       |

## Keybindings (zsh)

| Raccourci      | Effet                                                              |
|----------------|--------------------------------------------------------------------|
| `Ctrl-R`       | Atuin TUI fuzzy history                                            |
| `Ctrl-T`       | fzf file picker                                                    |
| `Alt-C`        | fzf cd picker                                                      |
| flèche droite  | accepte la suggestion `zsh-autosuggestions`                        |

Mode emacs (`bindkey -e`) par défaut.

## Comportements automatiques

- **Titre de tab** du terminal mis à jour selon `cwd` (idle) ou commande en
  cours (preexec).
- **Curseur** forcé en block clignotant à chaque prompt (robuste contre les
  shell-integrations qui le passent en barre).
- **History partagé** en temps réel entre tous les zsh ouverts.
- **Auto cd/pushd** : taper `dir-name` (sans `cd`) y va, `cd -<TAB>` montre
  l'historique des cd.

## Overrides locaux (non versionnés)

Pour la config spécifique à une machine, sans la committer :

| Fichier            | Sourcé par / quand                                        |
|--------------------|-----------------------------------------------------------|
| `~/.profile.local` | `.profile`, après l'env partagé (PATH, vars)              |
| `~/.bashrc.local`  | `.bashrc`, en fin de fichier (bash interactif)            |
| `~/.zshrc.local`   | `.zshrc`, en dernier (surcharge aliases, options, tools)  |

## `PATH`

`.profile` (POSIX, partagé bash/zsh) ajoute, dans cet ordre de priorité :

| Préfixe                                       | Outil                        |
|-----------------------------------------------|------------------------------|
| `/opt/homebrew/opt/coreutils/libexec/gnubin`  | GNU coreutils                |
| `/opt/homebrew/bin`                           | Homebrew                     |
| `~/.bun/bin`                                  | bun                          |
| `~/.cargo/bin`                                | binaires Rust                |
| `~/.local/bin`                                | scripts du repo + uv         |

## Outils additionnels (gérés hors brew)

- **`uv`** (Python) — installer officiel, son `env` est sourcé par `.profile`
  s'il existe.
- **`bun`** (JS/TS) — installer officiel, `~/.bun/bin` dans le `PATH`.

## Pré-warm du worker claude-mem

`.profile` lance le worker du plugin
[`claude-mem`](https://github.com/thedotmack/claude-mem) au login d'un shell
**interactif** s'il n'est pas déjà actif, pour éviter une race condition au
`SessionStart` du premier lancement de Claude Code.

## Migration de l'historique bash vers atuin

Première fois après install :

```sh
atuin import auto       # importe ~/.bash_history (ou zsh_history si existant)
atuin stats             # voir top commandes
```
