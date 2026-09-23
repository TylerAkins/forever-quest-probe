local ADDON_NAME, ns = ...
ns.name = ADDON_NAME
ns.version = "@project-version@"
ns.INTERFACE = 16001
ns.LIMITS = { label = 80, pins = 150, fields = 24, string = 240, depth = 6, entries = 120 }

local function printMessage(message)
    print("|cff4fc3f7FQP|r " .. message)
end
ns.Print = printMessage

function ns.NormalizeLabel(value)
    local label = tostring(value or ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    return label:sub(1, ns.LIMITS.label)
end

function ns.SafeCall(context, fn, ...)
    if type(fn) ~= "function" then return false, nil, "not callable" end
    local result = { pcall(fn, ...) }
    if not result[1] then return false, nil, tostring(result[2]) end
    table.remove(result, 1)
    return true, result, nil
end

local function clientInfo()
    local version, build, date, interface = GetBuildInfo()
    return { version = version, build = build, date = date, interface = interface, project = WOW_PROJECT_ID, locale = GetLocale() }
end

function ns.InitializeDatabase()
    ForeverQuestProbeDB = ForeverQuestProbeDB or {}
    local db = ForeverQuestProbeDB
    db.schemaVersion = db.schemaVersion or 1
    db.client = db.client or clientInfo()
    db.captures = type(db.captures) == "table" and db.captures or {}
    db.settings = type(db.settings) == "table" and db.settings or {}
    db.settings.nextCaptureID = tonumber(db.settings.nextCaptureID) or (#db.captures + 1)
    ns.DB = db
end

function ns.CreateCapture(label)
    label = ns.NormalizeLabel(label)
    if label == "" then return nil, "A non-empty capture label is required." end
    local pins = ns.ScanPins()
    local quests = ns.ScanQuests()
    local capabilities = ns.DetectCapabilities()
    local capture = {
        id = ns.DB.settings.nextCaptureID, label = label, timestamp = time and time() or nil,
        client = clientInfo(), viewedMapID = ns.GetViewedMapID(), playerMapID = ns.GetPlayerMapID(),
        selectedQuestID = ns.GetSelectedQuestID(), trackedQuestIDs = ns.GetTrackedQuestIDs(),
        superTrackedQuestID = ns.GetSuperTrackedQuestID(), capabilities = capabilities, quests = quests,
        pins = pins, selectedPin = ns.ScanSelectedPin(), warnings = {}, truncation = pins.truncation,
    }
    capture.correlations = ns.Correlate(quests, pins, capture.warnings)
    ns.DB.captures[#ns.DB.captures + 1] = capture
    ns.DB.settings.nextCaptureID = capture.id + 1
    return capture
end

function ns.FindCapture(id)
    for _, capture in ipairs(ns.DB.captures) do if capture.id == id then return capture end end
end

local function showHelp()
    printMessage("help, status, apis, pins, selected-pin, quests, capture <label>, list, show <number>, export <number>, clear [confirm]")
end

local function handleCommand(input)
    local command, rest = (input or ""):match("^(%S*)%s*(.-)%s*$")
    command = (command or "help"):lower()
    if command == "" or command == "help" then showHelp()
    elseif command == "status" then printMessage(string.format("v%s | map=%s | pins=%d | captures=%d", ns.version, tostring(ns.GetViewedMapID()), #ns.ScanPins().pins, #ns.DB.captures))
    elseif command == "apis" then local r = ns.DetectCapabilities(); printMessage(string.format("%d callable, %d tested", r.callableCount, r.testedCount))
    elseif command == "pins" then local r = ns.ScanPins(); printMessage(string.format("%d pins%s", #r.pins, r.warning and "; " .. r.warning or ""))
    elseif command == "selected-pin" then local r = ns.ScanSelectedPin(); if r.pin then printMessage("selected pin: " .. (r.pin.questID and "quest " .. r.pin.questID.value or "no explicit quest ID") .. (r.pin.x and ", coordinates exposed" or ", coordinates unavailable")) else printMessage(r.warning or "No safely readable selected-pin data.") end
    elseif command == "quests" then local r = ns.ScanQuests(); printMessage(string.format("%d quest entries", #r.entries))
    elseif command == "capture" then local capture, err = ns.CreateCapture(rest); printMessage(capture and ("saved capture #" .. capture.id) or err)
    elseif command == "list" then for _, c in ipairs(ns.DB.captures) do printMessage("#" .. c.id .. " " .. c.label) end
    elseif command == "show" then local c = ns.FindCapture(tonumber(rest)); printMessage(c and string.format("#%d %s: %d quests, %d pins", c.id, c.label, #c.quests.entries, #c.pins.pins) or "Capture not found.")
    elseif command == "export" then local c = ns.FindCapture(tonumber(rest)); if c then ns.UI.Show(c) else printMessage("Capture not found.") end
    elseif command == "clear" then if rest:lower() == "confirm" then ns.DB.captures = {}; ns.DB.settings.nextCaptureID = 1; printMessage("Probe captures deleted.") else printMessage("This deletes probe captures only. Run /fqp-probe clear confirm.") end
    else printMessage("Unknown command. Try /fqp-probe help.") end
end

SLASH_FOREVERQUESTPROBE1 = "/fqp-probe"
SlashCmdList.FOREVERQUESTPROBE = handleCommand
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, addon)
    if event == "ADDON_LOADED" and addon == ADDON_NAME then ns.InitializeDatabase(); printMessage("loaded. Run /fqp-probe help.") end
end)
