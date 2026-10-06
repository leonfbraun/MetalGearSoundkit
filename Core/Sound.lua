local addonName, addon = ...

if type(MetalGearSoundkitDB) ~= "table" then
    MetalGearSoundkitDB = {}
end
if type(MetalGearSoundkitDB.sounds) ~= "table" then
    MetalGearSoundkitDB.sounds = {}
end
if MetalGearSoundkitDB.itemEquipSound ~= "itemEquipMGS1"
    and MetalGearSoundkitDB.itemEquipSound ~= "itemEquipMGS3" then
    MetalGearSoundkitDB.itemEquipSound = "itemEquipMGS1"
end

local soundsById = {}
local settingsById = {}
local settingSounds = {}
local savedSounds = MetalGearSoundkitDB.sounds

for _, definition in ipairs(addon.soundDefinitions) do
    local settingId = definition.id
    local setting = {
        id = settingId,
        label = definition.label,
    }
    settingSounds[#settingSounds + 1] = setting
    settingsById[settingId] = setting

    local savedSettings = savedSounds[settingId]
    if type(savedSettings) ~= "table" then
        savedSettings = {}
        savedSounds[settingId] = savedSettings
    end

    if type(savedSettings.enabled) ~= "boolean" then
        local legacyId = definition.variants and MetalGearSoundkitDB.itemEquipSound
        local legacySettings = legacyId and savedSounds[legacyId]
        if type(legacySettings) == "table" and type(legacySettings.enabled) == "boolean" then
            savedSettings.enabled = legacySettings.enabled
        else
            savedSettings.enabled = true
        end
    end

    local sounds = definition.variants or { definition }
    if definition.variants then
        addon.itemEquipSounds = definition.variants
    end
    for _, sound in ipairs(sounds) do
        soundsById[sound.id] = {
            id = sound.id,
            file = sound.file,
            settingId = settingId,
        }
    end
end

addon.sounds = settingSounds

function addon:IsSoundEnabled(soundId)
    local sound = settingsById[soundId]
    if not sound then
        error("Unknown sound: " .. tostring(soundId))
    end

    return savedSounds[soundId].enabled
end

function addon:SetSoundEnabled(soundId, enabled)
    local sound = settingsById[soundId]
    if not sound then
        error("Unknown sound: " .. tostring(soundId))
    end
    if type(enabled) ~= "boolean" then
        error("Sound enabled state must be a boolean")
    end

    savedSounds[soundId].enabled = enabled
end

function addon:GetItemEquipSound()
    return MetalGearSoundkitDB.itemEquipSound
end

function addon:SetItemEquipSound(soundId)
    local sound = soundsById[soundId]
    if not sound or sound.settingId ~= "itemEquip" then
        error("Unknown item equip sound: " .. tostring(soundId))
    end

    MetalGearSoundkitDB.itemEquipSound = soundId
end

function addon:PlayAddonSound(soundName, soundChannel)
    local sound = soundsById[soundName]
    if not sound then
        error("Unknown sound: " .. tostring(soundName))
    end
    if not self:IsSoundEnabled(sound.settingId) then
        return
    end

    local soundPath = "Interface\\AddOns\\" .. addonName .. "\\Media\\Sounds\\" .. sound.file
    local willPlay = PlaySoundFile(soundPath, soundChannel or "Master")

    if not willPlay then
        print("|cff505050[MGSoundkit]|r Fehler: Sound konnte nicht abgespielt werden. Pfad prüfen: " .. soundPath)
    end
end
