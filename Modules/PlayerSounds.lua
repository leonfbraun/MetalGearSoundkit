local _, addon = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_DEAD" then
        addon:PlayAddonSound("death", "SFX")
    elseif event == "PLAYER_ALIVE" then
        addon:PlayAddonSound("releaseGhost", "SFX")
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        addon:PlayAddonSound(addon:GetItemEquipSound(), "SFX")
    end
end)
