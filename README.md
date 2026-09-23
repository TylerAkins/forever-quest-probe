# Forever Quest Probe

`ForeverQuestProbe` is a small, read-only developer diagnostic addon for World of Warcraft: Forever (Interface 16001). It records the quest-log, map-pin, selected/tracked, and waypoint APIs that the actual client exposes. It does not navigate, automate quests, replace pins, send data, or collect player identity.

## Install

Download the source and copy the compiled `ForeverQuestProbe` folder into `Interface/AddOns`. Build it locally with `python3 tools/compile_addon.py`. The addon is only for the Forever client, not Retail or other Classic clients.

## Commands

`/fqp-probe help`, `status`, `apis`, `pins`, `quests`, `capture <label>`, `list`, `show <number>`, `export <number>`, and `clear confirm` are available. Create a capture while the relevant map is open, then use `export` to open copyable deterministic text. Do not paste unrelated SavedVariables into reports.

Saved data is stored only in this addon's `ForeverQuestProbe.lua`: on macOS under `World of Warcraft/_classic_beta_/WTF/Account/<account>/SavedVariables/`, and on Windows under `World of Warcraft/_classic_beta_/WTF/Account/<account>/SavedVariables/`. Use `clear confirm` before sharing a clean report, or delete the addon folder and that one SavedVariables file to uninstall.

Visible Blizzard pins may be visual-only frames with no quest ID, map ID, or normalized coordinate exposed to addons. An **explicit** correlation comes from the same source supplying a quest ID and position; an **inferred** correlation is only a timing, appearance, or tracking-state guess and is never promoted to explicit.

## Validation

Run `python3 -m unittest discover -s tests` and `python3 tools/compile_addon.py --dry-run`. Automated tests simulate the addon contracts; only a real in-game capture validates Forever behavior.

## License

GPL-3.0-or-later. No Blizzard artwork is bundled.
