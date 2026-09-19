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
    if binding["key"] in "&é\"'(-è_ç":
        assert modifiers == {"alt"}, "Keep AltGr available for AZERTY symbols"

assert tmux_keys == set("hjkldDxHJKL")
assert config["shell"]["program"] == "wsl.exe"
print("Rio Windows: unique shortcuts, Alt/AltGr separation and tmux commands OK")
