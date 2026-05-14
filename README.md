# dotfiles (branche `MACOS`)

Configuration personnelle pour **macOS** : shell (bash), neovim, kitty, git.

> La configuration Arch Linux (X11 + i3 + sxhkd + picom + dunst + …) vit sur
> la branche [`master`](../../tree/master) — cette branche `MACOS` est durable
> et séparée, jamais mergée vers master.

## Structure

| Fichier / dossier         | Rôle                                                |
|---------------------------|-----------------------------------------------------|
| `.profile`                | Variables d'env (PATH, HIST*, EDITOR, …), POSIX     |
| `.bash_profile`           | Symlink vers `.profile`                             |
| `.bashrc`                 | Shell bash interactif (prompt, aliases, fzf, completions) |
| `.config/kitty/`          | Émulateur de terminal                               |
| `.config/nvim/`           | Neovim (lazy-lock géré séparément dans `nvim-config`) |
| `.config/git/`            | Config git globale + ignore                         |
| `.local/bin/`             | Scripts utilitaires (`mount_nas`, …)                |
| `.local/share/fonts/`     | Polices (Hack, Roboto, FontAwesome, Ubuntu Mono, …) |

D'autres répertoires `.config/*` (`i3`, `i3blocks`, `i3status`, `picom`,
`sxhkd`, `dunst`, `sxiv`) sont des restes de la conf Linux non utilisés sur
macOS. Idem pour `progs.csv` (liste de paquets Arch). Conservés pour limiter
la divergence avec `master`.

## Installation

Convention : repo cloné dans `~/conf/dotfiles/`, fichiers déployés par
symlinks vers `$HOME` (stow ou à la main).

### Prérequis Homebrew

```sh
brew install bash coreutils fzf bash-completion git neovim ripgrep fd
```

- **`coreutils`** — fournit `dircolors`, GNU `ls`, GNU `diff`, … Le `.profile`
  préfixe `/opt/homebrew/opt/coreutils/libexec/gnubin` au `PATH`, ce qui rend
  ces commandes disponibles **sans préfixe `g`**. Requis pour la colorisation
  `ls` via `~/.dircolors` et pour l'alias `diff --color=auto`.
- **`bash`** — le bash natif de macOS est en 3.2 (figé pour licence GPLv3) ;
  bash 4+ est nécessaire pour `shopt -s autocd` et autres usages modernes.
  Activer le shell : ajouter `/opt/homebrew/bin/bash` à `/etc/shells` puis
  `chsh -s /opt/homebrew/bin/bash`.
- **`fzf`** — `.bashrc` source `key-bindings.bash` et `completion.bash` depuis
  `/opt/homebrew/opt/fzf/shell`.
- **`bash-completion`** + **`git`** — pour `git-prompt.sh` (intégration
  `__git_ps1` dans le prompt) et la complétion git, sourcés depuis
  `/opt/homebrew/etc/bash_completion.d/`.

### Outils additionnels (gérés ailleurs)

- **`uv`** (Python) — installé via son installer officiel, son `env` est sourcé
  par `.profile` s'il existe.
- **`bun`** (JavaScript / TypeScript) — installé via son installer officiel,
  `~/.bun/bin` ajouté au `PATH`.

## Shell

- **Prompt** PS1 : utilisateur (rouge pour user, bleu pour root), host, cwd,
  branche git (via `__git_ps1`).
- **Aliases** principaux : `ll`/`la`/`l`/`lla`, `g=git`, `vim`/`vi=nvim`,
  `rg=rg --hidden`, `fd=fd -HI`.
- **fzf** : raccourcis clavier (`Ctrl-R`, `Ctrl-T`, `Alt-C`) + complétion.
- **Historique** illimité (`HISTSIZE=` / `HISTFILESIZE=`),
  `HISTCONTROL=ignoreboth`.

## Pré-warm du worker claude-mem

`.profile` lance le worker du plugin
[`claude-mem`](https://github.com/thedotmack/claude-mem) au login s'il n'est
pas déjà actif, pour éviter une race condition au `SessionStart` du premier
lancement de Claude Code.

## `PATH`

Le `.profile` ajoute les répertoires suivants au `PATH` s'ils existent
(ordre de précédence, le premier listé étant en tête) :

| Préfixe                                       | Outil                        |
|-----------------------------------------------|------------------------------|
| `~/.bun/bin`                                  | bun (runtime / package mgr)  |
| `/opt/homebrew/opt/coreutils/libexec/gnubin`  | GNU coreutils                |
| `/opt/homebrew/bin`                           | Homebrew                     |
| `~/.cargo/bin`                                | binaires Rust (cargo install)|
| `~/.local/bin`                                | scripts du repo + uv         |
