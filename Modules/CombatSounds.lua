local _, addon = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTER_COMBAT")


--! DRAFT
frame:RegisterEvent("ENCOUNTER_END")

frame:SetScript("OnEvent", function(self, event, encounterID, encounterName, difficultyID, groupSize, success)
    if success == 1 then
        print("Der Boss " .. encounterName .. " wurde ERFOLGREICH besiegt!")
    else
        print("Die Gruppe ist an " .. encounterName .. " GEWIPT.")
    end
end)