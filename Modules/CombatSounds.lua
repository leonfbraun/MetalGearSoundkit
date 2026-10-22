local _, addon = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTER_COMBAT")


--! DRAFT
frame:RegisterEvent("ENCOUNTER_END")
frame:RegisterEvent("ENCOUNTER_START")

frame:SetScript("OnEvent", function(self, event, encounterID, encounterName, difficultyID, groupSize, success)
    if event == "ENCOUNTER_START" then
        addon:PlayAddonSound()
    elseif event == "ENCOUNTER_END" then
        if success == 1 then
            addon:PlayAddonSound()
        else
            addon:PlayAddonSound()
        end
    end
end)