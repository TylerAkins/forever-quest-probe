local ADDON_NAME, ns = ...
local function quote(text) return string.format("%q", tostring(text):sub(1, ns.LIMITS.string)) end
local function sortedKeys(value)
    local keys = {}; for key in pairs(value) do keys[#keys + 1] = key end; table.sort(keys, function(a, b) return tostring(a) < tostring(b) end); return keys
end
function ns.Serialize(value, options)
    options = options or {}; local maxDepth, maxEntries = options.maxDepth or ns.LIMITS.depth, options.maxEntries or ns.LIMITS.entries; local seen = {}
    local function emit(item, depth)
        local kind = type(item)
        if kind == "nil" or kind == "number" or kind == "boolean" then return tostring(item)
        elseif kind == "string" then return quote(item)
        elseif kind ~= "table" then return "<unsupported:" .. kind .. ">" end
        if seen[item] then return "<cycle>" end; if depth >= maxDepth then return "<max-depth>" end
        seen[item] = true; local pieces, count = { "{" }, 0
        for _, key in ipairs(sortedKeys(item)) do count = count + 1; if count > maxEntries then pieces[#pieces + 1] = "<truncated>"; break end; pieces[#pieces + 1] = string.rep("  ", depth + 1) .. "[" .. emit(key, depth + 1) .. "] = " .. emit(item[key], depth + 1) .. "," end
        pieces[#pieces + 1] = string.rep("  ", depth) .. "}"; seen[item] = nil; return table.concat(pieces, "\n")
    end
    return emit(value, 0)
end
function ns.Export(capture)
    return "Forever Quest Probe export\nCapture #" .. tostring(capture.id) .. ": " .. tostring(capture.label) .. "\n---\n" .. ns.Serialize(capture)
end
