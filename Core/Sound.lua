local addonName, addon = ...

local sounds = {
    { id = "death", file = "death.ogg", label = "Todessound" },
    { id = "releaseGhost", file = "continue.ogg", label = "Wiederbelebung" },
    { id = "itemPickup", file = "itemPickup.ogg", label = "Gegenstand aufgehoben" },
}

if type(MetalGearSoundkitDB) ~= "table" then
    MetalGearSoundkitDB = {}
end
if type(MetalGearSoundkitDB.sounds) ~= "table" then
    MetalGearSoundkitDB.sounds = {}
end

local soundsById = {}
local savedSounds = MetalGearSoundkitDB.sounds

for _, sound in ipairs(sounds) do
    soundsById[sound.id] = sound

    local savedSettings = savedSounds[sound.id]
    if type(savedSettings) ~= "table" then
        savedSettings = {}
        savedSounds[sound.id] = savedSettings
    end

    if type(savedSettings.enabled) ~= "boolean" then
        savedSettings.enabled = true
    end
end

addon.sounds = sounds

function addon:IsSoundEnabled(soundId)
    local sound = soundsById[soundId]
    if not sound then
        error("Unknown sound: " .. tostring(soundId))
    end

    return savedSounds[soundId].enabled
end

function addon:SetSoundEnabled(soundId, enabled)
    local sound = soundsById[soundId]
    if not sound then
        error("Unknown sound: " .. tostring(soundId))
    end
    if type(enabled) ~= "boolean" then
        error("Sound enabled state must be a boolean")
    end

    savedSounds[soundId].enabled = enabled
end

function addon:PlayAddonSound(soundName)
    local sound = soundsById[soundName]
    if not sound then
        error("Unknown sound: " .. tostring(soundName))
    end
    if not self:IsSoundEnabled(soundName) then
        return
    end

    local soundPath = "Interface\\AddOns\\" .. addonName .. "\\Media\\Sounds\\" .. sound.file
    local willPlay = PlaySoundFile(soundPath, "Master")

    if not willPlay then
        print("|cff505050[MGSoundkit]|r Fehler: Sound konnte nicht abgespielt werden. Pfad prüfen: " .. soundPath)
    end
end
