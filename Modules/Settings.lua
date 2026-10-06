local addonName, addon = ...

local panel = CreateFrame("Frame", "MetalGearSoundkitOptionsPanel", UIParent)
panel.name = "Metal Gear Soundkit"
panel.checkboxes = {}

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Metal Gear Soundkit")

local description = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
description:SetText("Aktiviere oder deaktiviere einzelne Soundeffekte.")

for index, sound in ipairs(addon.sounds) do
    local soundId = sound.id
    local checkbox = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -68 - (index - 1) * 36)
    checkbox:SetSize(26, 26)
    checkbox:SetChecked(addon:IsSoundEnabled(soundId))

    local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    label:SetPoint("LEFT", checkbox, "RIGHT", 4, 0)
    label:SetText(sound.label)

    checkbox:SetScript("OnClick", function(self)
        addon:SetSoundEnabled(soundId, self:GetChecked() and true or false)
    end)

    panel.checkboxes[soundId] = checkbox
end

panel:SetScript("OnShow", function(self)
    for soundId, checkbox in pairs(self.checkboxes) do
        checkbox:SetChecked(addon:IsSoundEnabled(soundId))
    end
end)

local settingsCategory
local function OpenSettings()
    if settingsCategory and Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(settingsCategory:GetID())
        return
    end

    local openLegacySettings = _G.InterfaceOptionsFrame_OpenToCategory
    if openLegacySettings then
        openLegacySettings(panel)
        openLegacySettings(panel)
    end
end

local registrationFrame = CreateFrame("Frame")
registrationFrame:RegisterEvent("ADDON_LOADED")
registrationFrame:SetScript("OnEvent", function(self, _, loadedAddonName)
    if loadedAddonName ~= addonName then
        return
    end

    local interfaceOptionsAddCategory = _G.InterfaceOptions_AddCategory

    if Settings and Settings.RegisterCanvasLayoutCategory then
        settingsCategory = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
        Settings.RegisterAddOnCategory(settingsCategory)
    elseif interfaceOptionsAddCategory then
        interfaceOptionsAddCategory(panel)
    else
        error("No supported interface options registration API found")
    end

    local compartment = _G.AddonCompartmentFrame
    if compartment and compartment.RegisterAddon then
        compartment:RegisterAddon({
            text = panel.name,
            func = OpenSettings,
        })
    end

    self:UnregisterEvent("ADDON_LOADED")
end)
