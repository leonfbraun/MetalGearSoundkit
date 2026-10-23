local _, addon = ...

local currentInstanceID

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, isInitialLogin, isReloadingUi)
    local inInstance, instanceType = IsInInstance()

    local newID
    if inInstance and (instanceType == "party" or instanceType == "raid") then
        local _, _, _, _, _, _, _, instanceID = GetInstanceInfo()
        newID = instanceID

        local isFreshLoad = isInitialLogin or isReloadingUi
        if newID ~= currentInstanceID and not isFreshLoad then
            addon:PlayAddonSound("vrMission", "SFX")
        end
    end

    currentInstanceID = newID
end)