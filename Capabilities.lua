local ADDON_NAME, ns = ...
local symbols = {
    { "C_Map.GetBestMapForUnit", C_Map, "GetBestMapForUnit", "player" }, { "C_Map.GetMapInfo", C_Map, "GetMapInfo", nil },
    { "C_QuestLog.GetNumQuestLogEntries", C_QuestLog, "GetNumQuestLogEntries", "" }, { "C_QuestLog.GetInfo", C_QuestLog, "GetInfo", nil },
    { "C_QuestLog.GetQuestObjectives", C_QuestLog, "GetQuestObjectives", nil }, { "C_QuestLog.IsQuestReadyForTurnIn", C_QuestLog, "IsQuestReadyForTurnIn", nil },
    { "C_TaskQuest.GetQuestsForPlayerByMapID", C_TaskQuest, "GetQuestsForPlayerByMapID", nil }, { "C_SuperTrack.GetSuperTrackedQuestID", C_SuperTrack, "GetSuperTrackedQuestID", "" },
    { "C_Navigation", _G, "C_Navigation", nil }, { "GetNumQuestLogEntries", _G, "GetNumQuestLogEntries", "" }, { "GetQuestLogTitle", _G, "GetQuestLogTitle", nil },
    { "QuestPOIGetIconInfo", _G, "QuestPOIGetIconInfo", nil }, { "WorldMapFrame.EnumeratePins", WorldMapFrame, "EnumeratePins", "context" },
}
function ns.DetectCapabilities()
    local results, callable, tested = {}, 0, 0
    for _, spec in ipairs(symbols) do
        local name, owner, key, arg = unpack(spec); local value = owner and owner[key] or nil
        local item = { name = name, state = value == nil and "missing" or type(value) ~= "function" and "not_callable" or "callable" }
        if item.state == "callable" then
            callable = callable + 1
            if arg == "context" or arg == nil then item.call = "not_attempted_missing_context"
            else local ok, values, err = ns.SafeCall(name, value, arg == "" and nil or arg); item.call = ok and "succeeded" or "failed"; item.error = err; item.returns = ok and tostring(values[1]) or nil; tested = tested + 1 end
        end
        results[#results + 1] = item
    end
    return { results = results, callableCount = callable, testedCount = tested }
end
