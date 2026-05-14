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
| `.zshenv`                 | Env zsh (XDG dirs) sourcé pour tout shell zsh       |
| `.zprofile`               | Login zsh, source `.profile` en émulation POSIX     |
| `.zshrc`                  | Shell zsh interactif (zinit, plugins, starship, …)  |
| `.config/starship.toml`   | Config du prompt Starship (zsh + bash)              |
| `.config/atuin/config.toml` | Config Atuin (historique TUI fuzzy)               |
| `.config/kitty/`          | Émulateur de terminal                               |
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
1. `brew install` les outils manquants (starship, atuin, zoxide, eza, bat,
   direnv, tldr, fzf)
2. Clone `zinit` dans `~/.local/share/zinit/zinit.git`
3. Symlink `.zshenv`, `.zprofile`, `.zshrc`, `.config/starship.toml`,
   `.config/atuin/config.toml` vers `$HOME`
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

Puis configurer kitty/iTerm2 pour utiliser "Hack Nerd Font".

## Stack zsh — qu'est-ce qui est dedans

**Plugin manager** : [`zinit`](https://github.com/zdharma-continuum/zinit) en
turbo mode → startup `< 100ms` même avec 6 plugins (chargés en arrière-plan
juste après l'affichage du prompt).

**Plugins** :
| Plugin                                | Effet                                              |
|---------------------------------------|----------------------------------------------------|
| `fast-syntax-highlighting`            | Highlight syntaxique en temps réel                 |
| `zsh-autosuggestions`                 | Suggestion grise depuis l'historique               |
| `zsh-history-substring-search`        | Flèche haut/bas matche par préfixe tapé            |
| `fzf-tab`                             | Complétion TAB remplacée par fzf avec preview      |
| `zsh-you-should-use`                  | Rappelle un alias si tu tapes la commande complète |
| `zsh-autopair`                        | Auto-fermeture `()`, `[]`, `{}`, `""`, `''`        |

**Outils intégrés** :
- **[Starship](https://starship.rs/)** — prompt configurable, palette custom
  (voir [`.config/starship.toml`](.config/starship.toml)).
- **[Atuin](https://atuin.sh/)** — historique TUI fuzzy avec preview ;
  remplace `Ctrl-R`. Mode local par défaut (pas de sync cloud).
- **[Zoxide](https://github.com/ajeetdsouza/zoxide)** — `z dot`, `z claude` ;
  apprend tes dossiers fréquents.
- **[eza](https://eza.rocks/)** — `ls` moderne, alias par défaut.
- **[bat](https://github.com/sharkdp/bat)** — `cat` avec syntax highlight.
- **[direnv](https://direnv.net/)** — env per-projet via `.envrc`.

## Aliases & fonctions clés

| Cmd                  | Effet                                                          |
|----------------------|----------------------------------------------------------------|
| `dot`                | `cd ~/conf/dotfiles`                                           |
| `z <fragment>`       | cd fuzzy via zoxide (`z dot` → dotfiles)                       |
| `cd ~dot` / `~claude` / `~src` / `~conf` | named directories                            |
| `take <dir>`         | `mkdir -p <dir> && cd <dir>`                                   |
| `extract <archive>`  | détecte format (zip, tar.gz, tar.xz, 7z, rar, …) et extrait    |
| `weather [ville]`    | météo via wttr.in                                              |
| `cheat <cmd>`        | antisèche via cht.sh                                           |
| `serve [port]`       | serveur http statique du cwd (`bun` ou python3)                |
| `gbf`                | git branch fuzzy switch (Ctrl-G aussi)                         |
| `fkill`              | kill process via fzf                                           |
| `gi rust,macos`      | génère un `.gitignore` via gitignore.io                        |
| `cdr`                | cd vers la racine du repo git                                  |
| `mkv [nom]`          | crée un venv uv                                                |
| `reload`             | recharge `.zshrc` sans relancer le shell                       |
| `cmd G pattern`      | pipe vers grep (alias global, idem `L`/`H`/`T`/`C`/`NUL`)      |
| `./file.rs` (Enter)  | ouvre dans nvim (suffix aliases sur rs/py/ts/md/toml/json/…)   |

## Keybindings (zsh)

| Raccourci      | Effet                                                              |
|----------------|--------------------------------------------------------------------|
| `Ctrl-R`       | Atuin TUI fuzzy history                                            |
| `Ctrl-T`       | fzf file picker (avec preview bat/eza)                             |
| `Alt-C`        | fzf cd picker (preview eza --tree)                                 |
| `Ctrl-G`       | fuzzy git branch switch                                            |
| `Ctrl-X Ctrl-E`| édite la commande courante dans `$EDITOR`                          |
| flèche haut    | history-substring-search par préfixe (commence à taper)            |

## Comportements automatiques

- **Greeting** quotidien à la première session zsh du jour (mood adapté à
  l'heure, repo + branche si dans un git, tip random 1/3).
- **Titre de tab** du terminal mis à jour selon `cwd` (idle) ou commande en
  cours (preexec).
- **Notif macOS** automatique si une commande prend > 30s.
- **History partagé** en temps réel entre tous les zsh ouverts.
- **Auto cd/pushd** : taper `dir-name` (sans `cd`) y va, `cd -<TAB>` montre
  l'historique des cd.

## `PATH`

`.profile` (POSIX, partagé bash/zsh) ajoute, dans cet ordre de priorité :

| Préfixe                                       | Outil                        |
|-----------------------------------------------|------------------------------|
| `~/.bun/bin`                                  | bun                          |
| `/opt/homebrew/opt/coreutils/libexec/gnubin`  | GNU coreutils                |
| `/opt/homebrew/bin`                           | Homebrew                     |
| `~/.cargo/bin`                                | binaires Rust                |
| `~/.local/bin`                                | scripts du repo + uv         |

## Outils additionnels (gérés hors brew)

- **`uv`** (Python) — installer officiel, son `env` est sourcé par `.profile`
  s'il existe.
- **`bun`** (JS/TS) — installer officiel, `~/.bun/bin` dans le `PATH`.

## Pré-warm du worker claude-mem

`.profile` lance le worker du plugin
[`claude-mem`](https://github.com/thedotmack/claude-mem) au login s'il n'est
pas déjà actif, pour éviter une race condition au `SessionStart` du premier
lancement de Claude Code.

## Migration de l'historique bash vers atuin

Première fois après install :

```sh
atuin import auto       # importe ~/.bash_history (ou zsh_history si existant)
atuin stats             # voir top commandes
```
