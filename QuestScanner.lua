local ADDON_NAME, ns = ...
function ns.GetViewedMapID() return WorldMapFrame and WorldMapFrame.GetMapID and WorldMapFrame:GetMapID() or nil end
function ns.GetPlayerMapID() return C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player") or nil end
function ns.GetSelectedQuestID() return C_QuestLog and C_QuestLog.GetSelectedQuest and C_QuestLog.GetSelectedQuest() or (GetSelectedQuest and GetSelectedQuest()) end
function ns.GetSuperTrackedQuestID() return C_SuperTrack and C_SuperTrack.GetSuperTrackedQuestID and C_SuperTrack.GetSuperTrackedQuestID() or nil end
function ns.GetTrackedQuestIDs()
    local ids = {}; if C_QuestLog and C_QuestLog.GetNumQuestWatches and C_QuestLog.GetQuestIDForQuestWatchIndex then for i = 1, C_QuestLog.GetNumQuestWatches() do ids[#ids + 1] = C_QuestLog.GetQuestIDForQuestWatchIndex(i) end end; return ids
end
local function modernEntries()
    local entries = {}; if not (C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo) then return entries end
    local count = C_QuestLog.GetNumQuestLogEntries()
    for index = 1, count do local info = C_QuestLog.GetInfo(index); if info and not info.isHeader then
        local q = { index = index, id = info.questID, title = info.title, level = info.level, isHeader = false, source = "C_QuestLog.GetInfo" }
        q.isComplete = C_QuestLog.IsComplete and C_QuestLog.IsComplete(q.id) or nil; q.readyForTurnIn = C_QuestLog.IsQuestReadyForTurnIn and C_QuestLog.IsQuestReadyForTurnIn(q.id) or nil
        if C_QuestLog.GetQuestObjectives then local objectives = C_QuestLog.GetQuestObjectives(q.id); q.objectives = {}; for objectiveIndex, o in ipairs(objectives or {}) do q.objectives[#q.objectives + 1] = { index = objectiveIndex, text = o.text, type = o.type, finished = o.finished, numFulfilled = o.numFulfilled, numRequired = o.numRequired } end end
        entries[#entries + 1] = q
    end end; return entries
end
function ns.ScanQuests() return { entries = modernEntries(), adapter = C_QuestLog and "modern" or "unavailable" } end
