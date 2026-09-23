# Findings

These are real captures from World of Warcraft: Forever 1.60.1 build 69977, Interface 16001, enUS. They describe that build only. No player identity, account data, or full SavedVariables are recorded here.

| Scenario | Quest ID | Pin enumerated | Explicit quest ID | Explicit map ID | Explicit coordinates | Objective data | Turn-in data | Waypoint data | Correlation classification | Client build | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Multiple-objective quest log | 5723, 872, 821 | No | No | No | No | Separate objective text, types, progress, and completion | Not exposed | Not exposed | unknown | 69977 | Modern quest-log APIs return separate objective records. |
| Ready to turn in | 788 | No | No | No | No | Complete quest and completed objective exposed | `isComplete` true; dedicated ready API missing | Not exposed | unknown | 69977 | Quest was tracked and super-tracked before hand-in. |
| After turn-in | 788 | No | No | No | No | Quest removed from log | No dedicated turn-in signal | Not exposed | unknown | 69977 | New follow-up quest 3090 was super-tracked. |
| Selected native objective pin | N/A | No | No | No | No | N/A | N/A | Not exposed | unknown | 69977 | No readable selected-pin field and no `WorldMapFrame:EnumeratePins()`. |

## Confirmed capabilities

- `C_Map.GetBestMapForUnit("player")` returned a player map ID.
- `C_QuestLog.GetNumQuestLogEntries`, `C_QuestLog.GetInfo`, and `C_QuestLog.GetQuestObjectives` expose quest-log state and individual objectives.
- `C_SuperTrack.GetSuperTrackedQuestID()` exposes the quest Blizzard is super-tracking.
- A completed quest remains in the log with `isComplete = true` until it is turned in, then disappears.

## Missing capabilities

- `WorldMapFrame:EnumeratePins()` was absent.
- No selected native objective-pin field was safely readable.
- Legacy quest-log APIs, `QuestPOIGetIconInfo`, `C_TaskQuest.GetQuestsForPlayerByMapID`, and `C_QuestLog.IsQuestReadyForTurnIn` were absent.
- No waypoint destination or explicit objective/turn-in coordinates were exposed by the tested paths.

## Client-specific errors

No Lua errors were recorded. Missing optional symbols are reported as capability results, not errors.

## Reliable integration options

- Quest-state displays based on quest ID, title, objective text, progress, completion, and super-tracked state.
- Diffing captured quest-log state before and after turn-in.

## Unreliable approaches

- Treating visible Blizzard world-map pins or the minimap arrow as addon-readable coordinates.
- Inferring a destination from a super-tracked quest ID without a separate location source.

## Recommended navigation architecture

Use an independent, versioned Forever quest-location database keyed by quest ID and objective/turn-in state. The client data can select the relevant record, but cannot currently provide destination coordinates on its own.

## Remaining experiments

- Repeat these captures after Forever client builds change.
- Test remote maps, caves, multi-floor maps, and dungeons if new pin or waypoint APIs appear.
