addonName, addonTable = ...

local deathSound = "Interface\\AddOns\\SnakeDeath\\sounds\\death.ogg"
local releaseGhostSound = "Interface\\AddOns\\SnakeDeath\\sounds\\continue.ogg"
local itemPickupSound = "Interface\\AddOns\\SnakeDeath\\sounds\\itemPickup.ogg"


local frame = CreateFrame("Frame")


frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("PLAYER_ALIVE")

frame:RegisterEvent("CHAT_MSG_LOOT")

frame:SetScript("OnEvent", function(self, event, message)
    if event == "PLAYER_LOGIN" then
        print("|cff505050[SnakeDeath]|r This is Snake. Colonel, can you hear me?")
    elseif event == "PLAYER_DEAD" then
        PlayCustomAddonSound(deathSound)
    elseif event == "PLAYER_ALIVE" then
        PlayCustomAddonSound(releaseGhostSound)
    elseif event == "CHAT_MSG_LOOT" then
        if message:find("^Ihr") or message:find("^You") then
        
            local itemID, quantity = message:match("item:(%d+):.-x?(%d*)")
            
            if itemID then
                PlayCustomAddonSound(itemPickupSound)
            end
        end
    end
end)

function PlayCustomAddonSound(soundPath)
    local willPlay, soundHandle = PlaySoundFile(soundPath, "Master")
    
    if not willPlay then
        print("|cff505050[SnakeDeath]|r Fehler: Sound konnte nicht abgespielt werden. Pfad prüfen!")
    end
end

