#!/bin/sh
set -eu

repo=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
home_dir=$(mktemp -d)
trap 'rm -rf "$home_dir"' EXIT INT TERM
mkdir -p "$home_dir/bin"
# A configuration deployment must not provision the machine or access the network.
for tool in sudo apt-get cargo curl git chsh; do
    printf '#!/bin/sh\necho "Unexpected provisioning: %s" >&2\nexit 99\n' "$tool" > "$home_dir/bin/$tool"
    chmod +x "$home_dir/bin/$tool"
done
export HOME="$home_dir" DOTFILES="$repo" PATH="$home_dir/bin:/usr/bin:/bin"
printf 'original config\n' > "$HOME/.zshrc.bak"
printf 'current config\n' > "$HOME/.zshrc"
bash "$repo/.local/bin/install-zsh-setup"
test "$(readlink "$HOME/.zshrc")" = "$repo/.zshrc"
test "$(readlink "$HOME/.tmux.conf")" = "$repo/.tmux.conf"
test "$(readlink "$HOME/.bash_profile")" = "$repo/.bash_profile"
test "$(cat "$HOME/.zshrc.bak")" = 'original config'
test "$(cat "$HOME/.zshrc.bak.1")" = 'current config'
bash "$repo/.local/bin/install-zsh-setup"
test ! -e "$HOME/.zshrc.bak.2"
printf '#!/bin/sh\necho Darwin\n' > "$HOME/bin/uname"
chmod +x "$HOME/bin/uname"
bash "$repo/.local/bin/install-zsh-setup"
test "$(readlink "$HOME/.config/rio/config.toml")" = "$repo/.config/rio/config.toml"
test "$(readlink "$HOME/.config/rio/themes/gruvbox-dark.toml")" = "$repo/.config/rio/themes/gruvbox-dark.toml"
printf 'Configuration deployment: links, repeat runs and backups OK\n'
