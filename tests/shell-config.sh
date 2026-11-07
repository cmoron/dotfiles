#!/bin/sh
set -eu
repo=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
home_dir=$(mktemp -d)
trap 'rm -rf "$home_dir"' EXIT INT TERM
mkdir -p "$home_dir/.config/nvm"
printf 'printf "%%s\\n" "$*" > "$HOME/nvm-args"\n' > "$home_dir/.config/nvm/nvm.sh"
printf 'export FORCE_HYPERLINK=0\n' > "$home_dir/.zshrc.local"
export HOME="$home_dir" PATH=/usr/bin:/bin XDG_STATE_HOME="$home_dir/state"
zsh -f -ic 'source "$1"; test "$FORCE_HYPERLINK" = 0' audit "$repo/.zshrc" 2>"$home_dir/zsh.stderr"
test "$(cat "$home_dir/nvm-args")" = --no-use
zsh -f -ic '
    command() { if [[ "$*" == "-v eza" ]]; then return 1; fi; builtin command "$@"; }
    OSTYPE=darwin
    source "$1"
    [[ ${aliases[ls]} == "ls -G" ]]
' audit "$repo/.zshrc" 2>"$home_dir/zsh-mac.stderr"
bash --noprofile --norc -ic '. "$1"; alias t; alias vim' audit "$repo/.bashrc" >"$home_dir/bash.stdout" 2>"$home_dir/bash.stderr"
if grep -E 'atuin|__git_ps1' "$home_dir/bash.stderr"; then
    exit 1
fi
printf 'Shell startup: deferred NVM, local overrides and standalone Bash OK\n'
