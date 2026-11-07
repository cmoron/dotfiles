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
test "$(tmux -L "$socket" show-options -sv escape-time)" = 10
test "$(tmux -L "$socket" show-options -gv mouse)" = on
test "$(tmux -L "$socket" show-options -gv set-titles)" = on
test "$(tmux -L "$socket" show-options -gv set-titles-string)" = '#{pane_title}'

binding() {
    tmux -L "$socket" list-keys -T "${2:-prefix}" | awk -v key="$1" '
        $1 == "bind-key" && $2 == "-T" && $4 == key {
            $1 = $2 = $3 = $4 = ""
            sub(/^ +/, "")
            print
        }
    '
}

test "$(tmux -L "$socket" show-options -gwv mode-keys)" = vi
test "$(tmux -L "$socket" show-options -sv set-clipboard)" = external
test "$(binding M-i root)" = 'copy-mode'
test "$(binding v copy-mode-vi)" = 'send-keys -X begin-selection'
test "$(binding y copy-mode-vi)" = 'send-keys -X copy-selection-and-cancel'
test "$(binding J copy-mode-vi)" = 'send-keys -X -N 2 scroll-down'
test "$(binding K copy-mode-vi)" = 'send-keys -X -N 3 scroll-up'
test "$(binding WheelUpPane copy-mode-vi)" = 'select-pane \; send-keys -X -N 10 scroll-up'
test "$(binding WheelDownPane copy-mode-vi)" = 'select-pane \; send-keys -X -N 10 scroll-down'
test "$(binding WheelUpPane root)" = 'if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" { send-keys -M } { copy-mode -e -t = ;; send-keys -X -N 10 -t = scroll-up }'

test "$(binding M-h root)" = 'select-pane -L'
test "$(binding M-j root)" = 'select-pane -D'
test "$(binding M-k root)" = 'select-pane -U'
test "$(binding M-l root)" = 'select-pane -R'
test "$(binding h)" = 'select-pane -L'
test "$(binding j)" = 'select-pane -D'
test "$(binding k)" = 'select-pane -U'
test "$(binding l)" = 'select-pane -R'
test "$(binding '\\%')" = 'split-window -h -c "#{pane_current_path}"'
test "$(binding '\\"')" = 'split-window -v -c "#{pane_current_path}"'
test "$(binding d)" = 'detach-client'
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
