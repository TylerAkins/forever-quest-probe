local ADDON_NAME, ns = ...
local questKeys = { questID = true, questId = true, questIDToQuestInfo = true }
local mapKeys = { mapID = true, mapId = true, uiMapID = true }
local function scalar(value) local kind = type(value); if kind == "string" then return value:sub(1, ns.LIMITS.string) end; if kind == "number" or kind == "boolean" then return value end end
local function inspectTable(source, prefix)
    local values, explicit = {}, {}; if type(source) ~= "table" then return values, explicit end
    local n = 0; for key, value in pairs(source) do if n >= ns.LIMITS.fields then break end; local v = scalar(value); if v ~= nil then values[tostring(key)] = v; if questKeys[key] and type(v) == "number" then explicit.questID = { value = v, source = prefix .. "." .. key } elseif mapKeys[key] and type(v) == "number" then explicit.mapID = { value = v, source = prefix .. "." .. key } end; n = n + 1 end end; return values, explicit
end
function ns.ScanPins()
    local output = { pins = {}, warning = nil, truncation = false }; if not (WorldMapFrame and type(WorldMapFrame.EnumeratePins) == "function") then output.warning = "World map pin enumeration is unavailable."; return output end
    local ok, iterator = pcall(WorldMapFrame.EnumeratePins, WorldMapFrame); if not ok or type(iterator) ~= "function" then output.warning = "World map pin enumeration failed."; return output end
    while #output.pins < ns.LIMITS.pins do local good, pin = pcall(iterator); if not good then output.warning = "Pin iterator failed."; break end; if not pin then break end
        local entry = { number = #output.pins + 1, objectType = type(pin), sources = {} }
        entry.visible = pin.IsVisible and select(2, ns.SafeCall("pin:IsVisible", pin.IsVisible, pin)) or nil
        entry.template = scalar(pin.template); entry.type = scalar(pin.pinType)
        local raw, ids = inspectTable(pin, "pin"); entry.fields = raw
        for _, tableName in ipairs({ "data", "info", "poiInfo" }) do local values, discovered = inspectTable(pin[tableName], "pin." .. tableName); entry[tableName] = values; ids.questID = ids.questID or discovered.questID; ids.mapID = ids.mapID or discovered.mapID end
        if type(pin.GetQuestID) == "function" then local call, value = ns.SafeCall("pin:GetQuestID", pin.GetQuestID, pin); if call and type(value[1]) == "number" then ids.questID = { value = value[1], source = "pin:GetQuestID()" } end end
        if type(pin.GetPosition) == "function" then local call, value = ns.SafeCall("pin:GetPosition", pin.GetPosition, pin); if call and type(value[1]) == "number" and type(value[2]) == "number" then entry.x, entry.y, entry.positionSource = value[1], value[2], "pin:GetPosition()" end end
        entry.questID, entry.mapID = ids.questID, ids.mapID; output.pins[#output.pins + 1] = entry
    end
    if #output.pins >= ns.LIMITS.pins then output.truncation = true; output.warning = "Pin limit reached." end; return output
end
