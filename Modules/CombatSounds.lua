local _, addon = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("ENCOUNTER_START")

frame:SetScript("OnEvent", function()
    addon:PlayAddonSound("alert", "SFX")
end)