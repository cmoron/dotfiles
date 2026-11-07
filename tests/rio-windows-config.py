"""Run with: uv run --no-project tests/rio-windows-config.py."""

import tomllib
from pathlib import Path

repo = Path(__file__).resolve().parents[1]
config = tomllib.loads((repo / ".config/rio/config.windows.toml").read_text())
bindings = config["bindings"]["keys"]
triggers = set()
tmux_keys = set()
for binding in bindings:
    modifiers = frozenset(binding["with"].replace(" ", "").split("|"))
    trigger = (binding["key"], modifiers, binding.get("mode", ""))
    assert trigger not in triggers, f"Duplicate shortcut: {trigger}"
    triggers.add(trigger)
    assert "super" not in modifiers, binding
    if binding.get("esc", "").startswith("\0"):
        assert "alt" in modifiers, binding
        tmux_keys.add(binding["esc"][1:])
    if binding["key"] in "hjkl" and modifiers == {"alt"}:
        assert binding["esc"] == "\x1b" + binding["key"], "Alt+hjkl = tmux M-hjkl"
    if binding["key"] in "&é\"'(-è_ç":
        assert modifiers == {"alt"}, "Keep AltGr available for AZERTY symbols"

assert tmux_keys == set('%"xHJKL[')
assert {"key": "i", "with": "alt", "esc": "\0["} in bindings
assert config["shell"]["program"] == "wsl.exe"
mac_config = tomllib.loads((repo / ".config/rio/config.toml").read_text())
assert {"key": "i", "with": "alt", "esc": "\0["} in mac_config["bindings"]["keys"]
assert mac_config["shell"] == {"program": "/bin/zsh", "args": ["--login"]}
assert mac_config["option-as-alt"] == "left"
mac_triggers = set()
for binding in mac_config["bindings"]["keys"]:
    modifiers = frozenset(binding["with"].replace(" ", "").split("|"))
    trigger = (binding["key"], modifiers, binding.get("mode", ""))
    assert trigger not in mac_triggers, f"Duplicate macOS shortcut: {trigger}"
    mac_triggers.add(trigger)
    if binding["key"] in "hjkl" and modifiers == {"super"}:
        assert binding["esc"] == "\x1b" + binding["key"]
print("Rio Windows/macOS: unique shortcuts, tmux commands and Zsh on Mac OK")
