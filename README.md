# Forever Quest Probe

`ForeverQuestProbe` is a small, read-only developer diagnostic addon for World of Warcraft: Forever (Interface 16001). It records the quest-log, map-pin, selected/tracked, and waypoint APIs that the actual client exposes. It does not navigate, automate quests, replace pins, send data, or collect player identity.

The first in-game captures are recorded in [FINDINGS.md](FINDINGS.md). On Forever 1.60.1 build 69977, the client exposes detailed quest-log state and the super-tracked quest ID, but not a readable Blizzard objective-pin destination. Treat those results as build-specific evidence, not a promise about future client builds.

## Install

Download the release archive, extract it, and copy its `ForeverQuestProbe` folder into the Forever client's `Interface/AddOns` directory. On macOS, the default location is `/Applications/World of Warcraft/_classic_beta_/Interface/AddOns/ForeverQuestProbe`. Restart the game or run `/reload`.

For a source checkout, build the same folder with `python3 tools/compile_addon.py`. The addon is only for the Forever client, not Retail or other Classic clients.

## Commands

| Command | Purpose |
| --- | --- |
| `/fqp-probe apis` | Report the client APIs the probe can safely detect. |
| `/fqp-probe quests` | Summarize active quest-log records. |
| `/fqp-probe pins` | Attempt a bounded scan of native world-map pins. |
| `/fqp-probe selected-pin` | Inspect only already-exposed selected-pin fields. It never changes selection. |
| `/fqp-probe capture <label>` | Save a structured, bounded diagnostic capture. |
| `/fqp-probe export <number>` | Open a copyable deterministic export for a capture. |
| `/fqp-probe list`, `show <number>`, `clear confirm` | Manage saved captures. |

Create a capture while the relevant map is open, then use `export` to open copyable diagnostic text. Do not paste unrelated SavedVariables into reports.

Saved data is stored only in this addon's `ForeverQuestProbe.lua`: on macOS under `World of Warcraft/_classic_beta_/WTF/Account/<account>/SavedVariables/`, and on Windows under `World of Warcraft/_classic_beta_/WTF/Account/<account>/SavedVariables/`. Use `clear confirm` before sharing a clean report, or delete the addon folder and that one SavedVariables file to uninstall.

Visible Blizzard pins may be visual-only frames with no quest ID, map ID, or normalized coordinate exposed to addons. An **explicit** correlation comes from the same source supplying a quest ID and position; an **inferred** correlation is only a timing, appearance, or tracking-state guess and is never promoted to explicit. A native minimap arrow similarly does not prove its destination coordinates are available to addons.

## Validation

Run `python3 -m unittest discover -s tests` and `python3 tools/compile_addon.py --dry-run`. Automated tests simulate the addon contracts; only a real in-game capture validates Forever behavior.

## License

GPL-3.0-or-later. No Blizzard artwork is bundled.
