local _, addon = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("PLAYER_ALIVE")

frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_LOGIN" then
        print("|cff505050[MGSoundkit]|r This is Snake. Colonel, can you hear me?")
    elseif event == "PLAYER_DEAD" then
        addon:PlayAddonSound("death")
    elseif event == "PLAYER_ALIVE" then
        addon:PlayAddonSound("releaseGhost")
    end
end)
