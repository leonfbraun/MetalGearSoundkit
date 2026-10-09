local addonName, addon = ...

local panel = CreateFrame("Frame", "MetalGearSoundkitOptionsPanel", UIParent)
panel.name = "Metal Gear Soundkit"
panel.checkboxes = {}

local itemEquipDropdown

local function CreatePanelHeading()
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(panel.name)

    local description = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    description:SetText("Aktiviere oder deaktiviere einzelne Soundeffekte.")
end

local function OnSoundToggle(self)
    addon:SetSoundEnabled(self.soundId, self:GetChecked() and true or false)
end

local function CreateSoundCheckbox(index, sound)
    local checkbox = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", panel, "TOPLEFT", 16, -68 - (index - 1) * 36)
    checkbox:SetSize(26, 26)
    checkbox.soundId = sound.id
    checkbox:SetChecked(addon:IsSoundEnabled(sound.id))
    checkbox:SetScript("OnClick", OnSoundToggle)

    local label = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    label:SetPoint("LEFT", checkbox, "RIGHT", 4, 0)
    label:SetText(sound.label)

    panel.checkboxes[sound.id] = checkbox
    return label
end

local function UpdateItemEquipDropdown()
    local selectedSound = addon:GetItemEquipSound()
    UIDropDownMenu_SetSelectedValue(itemEquipDropdown, selectedSound)

    for _, sound in ipairs(addon.itemEquipSounds) do
        if sound.id == selectedSound then
            UIDropDownMenu_SetText(itemEquipDropdown, sound.label)
            return
        end
    end
end

local function OnItemEquipSoundSelected(_, soundId)
    addon:SetItemEquipSound(soundId)
    UpdateItemEquipDropdown()
end

local function CreateItemEquipDropdown(anchor)
    local dropdown = CreateFrame("Frame", nil, panel, "UIDropDownMenuTemplate")
    dropdown:SetPoint("LEFT", anchor, "RIGHT", 8, 0)
    UIDropDownMenu_SetWidth(dropdown, 100)

    UIDropDownMenu_Initialize(dropdown, function(_, level)
        if level ~= 1 then
            return
        end

        for _, sound in ipairs(addon.itemEquipSounds) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = sound.label
            info.value = sound.id
            info.arg1 = sound.id
            info.func = OnItemEquipSoundSelected
            info.checked = addon:GetItemEquipSound() == sound.id
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    return dropdown
end

local function CreateSoundOptions()
    for index, sound in ipairs(addon.sounds) do
        local label = CreateSoundCheckbox(index, sound)
        if sound.id == "itemEquip" then
            itemEquipDropdown = CreateItemEquipDropdown(label)
        end
    end
end

panel:SetScript("OnShow", function(self)
    if itemEquipDropdown then
        UpdateItemEquipDropdown()
    end

    for soundId, checkbox in pairs(self.checkboxes) do
        checkbox:SetChecked(addon:IsSoundEnabled(soundId))
    end
end)

CreatePanelHeading()
CreateSoundOptions()

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
