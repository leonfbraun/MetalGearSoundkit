local _, addon = ...

local INTRO_SOUND_DELAY = 3

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        print("|cff505050[MGSoundkit]|r This is Snake. Colonel, can you hear me?")
        C_Timer.After(INTRO_SOUND_DELAY, function()
            addon:PlayAddonSound("intro", "SFX")
        end)
    elseif event == "PLAYER_DEAD" then
        addon:PlayAddonSound("death", "SFX")
    elseif event == "PLAYER_ALIVE" then
        addon:PlayAddonSound("releaseGhost", "SFX")
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        addon:PlayAddonSound(addon:GetItemEquipSound(), "SFX")
    end
end)
