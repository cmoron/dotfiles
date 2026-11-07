# Dotfiles — branche `master`

Configuration Linux/WSL de Cyril. La branche `MACOS` conserve les réglages Mac ;
les changements portables sont reportés individuellement.

L'ancienne configuration Arch Linux/X11 est conservée dans le tag Git
`archive/archlinux` (i3, services graphiques, scripts de barre et liste de paquets).
Pour consulter un ancien fichier :

```sh
git show archive/archlinux:.config/i3/config
```

## Rio Windows + tmux dans WSL

| Source versionnée                                                    | Destination                                              |
| -------------------------------------------------------------------- | -------------------------------------------------------- |
| [`.tmux.conf`](.tmux.conf)                                           | `~/.tmux.conf` dans WSL, par lien symbolique             |
| [`.config/rio/config.windows.toml`](.config/rio/config.windows.toml) | `%LOCALAPPDATA%\rio\config.toml` sous Windows, par copie |
| [Thème Gruvbox](.config/rio/themes/gruvbox-dark.toml)                | `%LOCALAPPDATA%\rio\themes\gruvbox-dark.toml`            |

Le fichier Rio Windows est distinct de `.config/rio/config.toml`, qui contient
encore un shell Homebrew et des raccourcis `Super` destinés au Mac.
Modifier la source versionnée, puis recopier le fichier Windows pour le déployer.

### Installation et lancement

Prérequis : Rio Windows (fork `mnc` pour les actions `SelectSplit*`), distribution
WSL `Ubuntu-24.04`, et `tmux` installé dans cette distribution.

Depuis `~/src/dotfiles` dans WSL, à la première installation :

```sh
ln -s "$PWD/.tmux.conf" "$HOME/.tmux.conf"
```

Si `~/.tmux.conf` existe déjà, vérifier sa cible et sauvegarder toute autre
configuration avant de le remplacer. Le lien en place suit les modifications du dépôt.

Déployer Rio depuis ce même répertoire (chemin du profil Windows de Cyril) :

```sh
rio_dir=/mnt/c/Users/cyril/AppData/Local/rio
mkdir -p "$rio_dir/themes"
cp --backup=numbered .config/rio/config.windows.toml "$rio_dir/config.toml"
cp --backup=numbered .config/rio/themes/gruvbox-dark.toml "$rio_dir/themes/gruvbox-dark.toml"
```

Ces copies conservent des sauvegardes numérotées des fichiers remplacés.
Ouvrir une nouvelle fenêtre Rio, puis lancer `t` (alias de `tmux` dans Zsh et Bash)
dans WSL. Pour un shell déjà ouvert, exécuter `alias t='tmux'` ou ouvrir un nouveau shell.
Rio lance WSL,
mais ne démarre pas tmux automatiquement. Les raccourcis ci-dessous envoient
des commandes tmux : les utiliser dans une session tmux active.

### Raccourcis

`Préfixe` signifie appuyer sur `Ctrl+Espace`, relâcher, puis taper la touche.
Sous Windows, utiliser **Alt gauche**, pas AltGr.

La navigation accepte `Alt+h/j/k/l` directement et Préfixe puis `h/j/k/l`, pour
rester compatible avec les anciennes configurations Rio déjà déployées.

| Action                               | Rio Windows        | tmux dans tout terminal     |
| ------------------------------------ | ------------------ | --------------------------- |
| Focus gauche / bas / haut / droite   | `Alt+h/j/k/l`      | Préfixe puis `h/j/k/l`      |
| Diviser à droite                     | `Alt+d`            | Préfixe puis `%`            |
| Diviser en bas                       | `Alt+Shift+d`      | Préfixe puis `"`            |
| Fermer le pane et son processus      | `Alt+w`            | Préfixe puis `x`            |
| Déplacer la séparation de 5 cellules | `Ctrl+Alt+flèches` | Préfixe puis `H/J/K/L`      |
| Recharger la configuration tmux      | —                  | Préfixe puis `r`            |
| Entrer en mode copie (Vim)           | `Alt+i`            | `Alt+i` ou Préfixe puis `[` |
| Détacher la session                  | —                  | Préfixe puis `d`            |

Dans le mode copie : `h/j/k/l` pour se déplacer, `v` pour commencer une
sélection, `V` pour sélectionner des lignes, puis `y` pour copier et revenir au
shell. `q` quitte sans copier. `J` défile de 2 lignes vers le bas et `K` de
3 vers le haut, comme dans la configuration Neovim, même pendant une sélection.
`Ctrl+u/d` défile d'une demi-page, `g` / `G` rejoint le début / la fin de l'historique.

La copie utilise OSC 52 via Rio pour atteindre le presse-papier Windows :
coller avec `Ctrl+Shift+V` dans Rio ou `Ctrl+V` dans une autre application.
Aucun outil de presse-papier supplémentaire n'est nécessaire. Ce mécanisme
demande un terminal compatible OSC 52 ; Rio le prend en charge.

tmux utilise son propre historique : l'ascenseur Rio ne représente plus celui
du pane. La molette entre dans cet historique et défile de 10 lignes par cran
(au lieu de 5). Les applications qui capturent la souris, comme Vim, conservent
leur propre gestion du défilement.

Après une modification, recharger tmux avec Préfixe puis `r` (ou
`tmux source-file ~/.tmux.conf`). Pour le raccourci Rio, recopier aussi la
configuration Windows comme indiqué ci-dessus et ouvrir une nouvelle fenêtre.

En SSH, installer et recharger aussi `.tmux.conf` sur la machine distante : Rio
envoie les mêmes touches, mais c'est le tmux distant qui les interprète. Une
ancienne configuration peut encore associer Préfixe puis `l` à la liste des
sessions au lieu du focus à droite. La liste reste accessible avec Préfixe puis `s`.

La même `.tmux.conf` fonctionne sur Linux/WSL et macOS (tmux 3.4 ou plus récent).
La configuration Rio Mac prévoit aussi `Option+i` pour le mode copie. Le yank
atteint le presse-papier de la machine qui exécute Rio, même depuis un tmux en
SSH : `Cmd+V` pour coller sur Mac. Les fichiers Rio restent propres à chaque OS
(shell et raccourcis d'onglets différents) ; seule la configuration tmux est commune.

Les onglets Rio restent accessibles avec `Alt` + touches AZERTY `& é " ' ( - è _ ç`
(1 à 8, puis dernier onglet), `Ctrl+Tab` / `Ctrl+Shift+Tab`, ou `Ctrl+PageUp/PageDown`.
`Ctrl+Shift+PageUp/PageDown` déplace l'onglet courant.

### Coexistence avec les splits Rio

Rio conserve ses splits natifs : `Ctrl+Shift+r/d` pour diviser,
`Ctrl+Shift+h/j/k/l` pour leur focus et `Ctrl+Shift+Alt+flèches` pour les redimensionner.
Ces raccourcis agissent sur Rio ; les raccourcis `Alt` ci-dessus agissent sur tmux.
`Ctrl+Shift+w` ferme le split ou l'onglet Rio, tandis que `Alt+w` ferme le pane tmux.

L'audit de la source du fork Rio 0.5.8 (`beccd1be`) confirme que les modificateurs
sont comparés exactement : aucun chevauchement trouvé avec les raccourcis tmux.
AltGr est traité séparément pour préserver les symboles AZERTY. Dans les bindings
Rio, écrire `control`, pas `ctrl` : le parseur de cette version ignore `ctrl`.

### Vérification

Depuis la racine du dépôt :

```sh
sh tests/tmux-config.sh
uv run --no-project tests/rio-windows-config.py
```

Le premier test charge la configuration dans un serveur tmux isolé. Le second
vérifie le TOML, les doublons de raccourcis, les commandes tmux et les modificateurs.
Il ne remplace pas un test clavier dans Rio.

Validation du 19 septembre 2026 : tests passés ; `Alt+d` testé avec succès dans
Rio Windows 0.5.8 vers tmux 3.4. Les autres combinaisons ont été vérifiées dans
la configuration et le code de Rio ; leur test GUI reste à faire, Windows ayant
refusé de redonner le focus à la fenêtre de test.
