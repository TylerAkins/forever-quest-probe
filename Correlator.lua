local ADDON_NAME, ns = ...
function ns.Correlate(quests, pins, warnings)
    local out = {}; for _, quest in ipairs(quests.entries or {}) do local record = { questID = quest.id, classification = "unknown", pins = {}, evidence = {}, missing = {} }
        for _, pin in ipairs(pins.pins or {}) do if pin.questID and pin.questID.value == quest.id then local kind = pin.x and pin.y and "explicit" or "correlated"; record.classification = kind; record.pins[#record.pins + 1] = pin.number; record.evidence[#record.evidence + 1] = pin.questID.source end end
        if #record.pins == 0 then record.missing[#record.missing + 1] = "No pin with an explicit matching quest ID." end; out[#out + 1] = record
    end; return out
end
