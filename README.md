# Dotfiles — branche `master`

Configuration Linux/WSL de Cyril. La branche `MACOS` conserve les réglages Mac ;
les changements portables sont reportés individuellement.

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

| Action                               | Rio Windows        | tmux dans tout terminal                   |
| ------------------------------------ | ------------------ | ----------------------------------------- |
| Focus gauche / bas / haut / droite   | `Alt+h/j/k/l`      | Préfixe puis `h/j/k/l`                    |
| Diviser à droite                     | `Alt+d`            | Préfixe puis `d`                          |
| Diviser en bas                       | `Alt+Shift+d`      | Préfixe puis `D`                          |
| Fermer le pane et son processus      | `Alt+w`            | Préfixe puis `x`                          |
| Déplacer la séparation de 5 cellules | `Ctrl+Alt+flèches` | Préfixe puis `H/J/K/L`                    |
| Recharger la configuration tmux      | —                  | Préfixe puis `r`                          |
| Détacher la session                  | —                  | Préfixe puis `:detach-client` et `Entrée` |

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
