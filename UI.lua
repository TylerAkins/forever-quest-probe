local ADDON_NAME, ns = ...
ns.UI = {}
function ns.UI.Show(capture)
    local ui = ns.UI.frame
    if not ui then
        ui = CreateFrame("Frame", "ForeverQuestProbeReport", UIParent, "BackdropTemplate")
        ui:SetSize(760, 500); ui:SetPoint("CENTER"); ui:SetMovable(true); ui:EnableMouse(true); ui:RegisterForDrag("LeftButton"); ui:SetScript("OnDragStart", ui.StartMoving); ui:SetScript("OnDragStop", ui.StopMovingOrSizing)
        ui:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 } })
        local title = ui:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); title:SetPoint("TOP", 0, -14); ui.title = title
        local close = CreateFrame("Button", nil, ui, "UIPanelCloseButton"); close:SetPoint("TOPRIGHT", -4, -4)
        local scroll = CreateFrame("ScrollFrame", nil, ui, "UIPanelScrollFrameTemplate"); scroll:SetPoint("TOPLEFT", 18, -42); scroll:SetPoint("BOTTOMRIGHT", -32, 18)
        local edit = CreateFrame("EditBox", nil, scroll); edit:SetMultiLine(true); edit:SetFontObject("ChatFontNormal"); edit:SetWidth(700); edit:SetAutoFocus(false); edit:EnableMouse(true); edit:SetScript("OnEscapePressed", function() ui:Hide() end); edit:SetScript("OnKeyDown", function(self, key) if (IsControlKeyDown() or IsMetaKeyDown and IsMetaKeyDown()) and key == "A" then self:HighlightText() end end)
        scroll:SetScrollChild(edit); ui.edit = edit; ns.UI.frame = ui
    end
    ui.title:SetText("Forever Quest Probe: #" .. capture.id .. " " .. capture.label); ui.edit:SetText(ns.Export(capture)); ui.edit:HighlightText(); ui:Show()
end
