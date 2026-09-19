#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
socket="dotfiles-test-$$"
session=config-test

cleanup() {
    tmux -L "$socket" kill-server 2>/dev/null || true
}
trap cleanup EXIT INT TERM

tmux -L "$socket" -f "$repo/.tmux.conf" new-session -d -s "$session" -x 120 -y 40

test "$(tmux -L "$socket" show-options -gv prefix)" = C-Space
test "$(tmux -L "$socket" show-options -gv mouse)" = on
test "$(tmux -L "$socket" show-options -gv set-titles)" = on
test "$(tmux -L "$socket" show-options -gv set-titles-string)" = '#{pane_title}'

binding() {
    tmux -L "$socket" list-keys -T prefix | awk -v key="$1" '
        $1 == "bind-key" && $2 == "-T" && $3 == "prefix" && $4 == key {
            $1 = $2 = $3 = $4 = ""
            sub(/^ +/, "")
            print
        }
    '
}

test "$(binding h)" = 'select-pane -L'
test "$(binding j)" = 'select-pane -D'
test "$(binding k)" = 'select-pane -U'
test "$(binding l)" = 'select-pane -R'
test "$(binding d)" = 'split-window -h -c "#{pane_current_path}"'
test "$(binding D)" = 'split-window -v -c "#{pane_current_path}"'
test "$(binding x)" = 'kill-pane'
test "$(binding H)" = 'resize-pane -L 5'
test "$(binding J)" = 'resize-pane -D 5'
test "$(binding K)" = 'resize-pane -U 5'
test "$(binding L)" = 'resize-pane -R 5'
test -z "$(binding C-b)"
test "$(binding r)" = "source-file $HOME/.tmux.conf \\; display-message \"tmux config reloaded\""

test "$(tmux -L "$socket" show-options -gv status-style)" = 'bg=#1d2021,fg=#ebdbb2'
test "$(tmux -L "$socket" show-options -gv window-status-current-format)" = '#[bg=#d65d0e,fg=#1d2021,bold] #I:#W#F #[bg=#1d2021]'
test "$(tmux -L "$socket" show-options -gv status-right)" = '#[bg=#3c3836,fg=#bdae93] %d/%m #[bg=#458588,fg=#1d2021,bold] %H:%M '
