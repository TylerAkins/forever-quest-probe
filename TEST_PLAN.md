# Manual test plan

For each test, open the relevant native world map, run `/fqp-probe apis`, `/fqp-probe pins`, `/fqp-probe quests`, then `/fqp-probe capture <label>` and inspect/export it. Record client build and whether a pin gives an explicit `questID` plus `GetPosition()` (explicit), has only a stable shared quest ID (correlated), depends on state or appearance (inferred), or supplies neither (missing/unknown).

| Scenario | Setup and map state | Label and fields to examine |
| --- | --- | --- |
| 1. Available quest | Recommended: any low-level one-objective quest with a different finisher, if available; open giver zone map. | `available-start`; pins, explicit IDs/map/coords, quest absence from log. |
| 2. One kill objective | Accept a one-kill quest; open its objective zone. | `kill-one`; objectives and objective pin. |
| 3. Multiple objectives | Accept a quest with two objectives. | `multi-objective`; separate objective records and pins. |
| 4. Item use | Accept an item-use quest. | `item-use`; objective type/progress and waypoint. |
| 5. Object interaction | Accept an interact quest. | `object-use`; objective type/progress and pin. |
| 6. Original turn-in | Complete a quest returning to giver. | `turnin-giver`; ready state and turn-in pin. |
| 7. Different turn-in | Complete a quest with another finisher. | `turnin-other`; turn-in location evidence. |
| 8. Cross-zone objective | Open remote objective-zone map. | `cross-zone-objective`; viewed/quest map IDs. |
| 9. Cross-zone turn-in | Complete remotely then open finisher map. | `cross-zone-turnin`; turn-in evidence. |
| 10. Cave/interior | Stand at or view a cave objective. | `cave`; map hierarchy and coordinate source. |
| 11. Multi-floor | Select each relevant floor. | `multi-floor`; map IDs and pin position. |
| 12. Dungeon | Accept a dungeon quest and open dungeon map. | `dungeon`; provider/template and map IDs. |
| 13. Tracking | Toggle a quest tracked/untracked without changing it. | `tracked`; tracked IDs and changed pins. |
| 14. Selection | Select then deselect a quest. | `selected`; selected ID and inferred-only links. |
| 15. Super-track | Super-track a normally tracked quest. | `supertracked`; super-track API result. |
| 16. Remote map | Compare current and remote map captures. | `remote-map`; enumeration availability. |
| 17. Shared area | Take multiple quests sharing an area. | `shared-area`; one-to-many correlations. |
| 18. Completion disappearance | Capture before/after objective completion. | `objective-disappears`; pin diff. |
| 19. Completion appearance | Capture before/after a turn-in appears. | `turnin-appears`; pin diff. |

In every row, a numeric field without a `questID`-named source is raw evidence, never an explicit ID. Note missing APIs/errors verbatim in `FINDINGS.md`.
