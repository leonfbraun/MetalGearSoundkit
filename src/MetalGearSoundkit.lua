local addonName, addonTable = ...

local deathSound = "Interface\\AddOns\\MetalGearSoundkit\\sounds\\death.ogg"
local releaseGhostSound = "Interface\\AddOns\\MetalGearSoundkit\\sounds\\continue.ogg"
local itemPickupSound = "Interface\\AddOns\\MetalGearSoundkit\\sounds\\itemPickup.ogg"


local frame = CreateFrame("Frame")


frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("PLAYER_ALIVE")

frame:RegisterEvent("CHAT_MSG_LOOT")
local searchPatternSingle = LOOT_ITEM_SELF:gsub("%%s", "(.+)")
local searchPatternMultiple = LOOT_ITEM_SELF_MULTIPLE:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")

frame:SetScript("OnEvent", function(self, event, message)
    if event == "PLAYER_LOGIN" then
        print("|cff505050[MGSoundkit]|r This is Snake. Colonel, can you hear me?")
    elseif event == "PLAYER_DEAD" then
        PlayCustomAddonSound(deathSound)
    elseif event == "PLAYER_ALIVE" then
        PlayCustomAddonSound(releaseGhostSound)
    elseif event == "CHAT_MSG_LOOT" then
        local matched = false
        
        local itemLink, qty = message:match(searchPatternMultiple)
        if itemLink then
            matched = true
        else
            itemLink = message:match(searchPatternSingle)
            if itemLink then
                matched = true
            end
        end

        if matched and itemLink then
            local itemID = itemLink:match("item:(%d+)")
            if itemID then
                PlayCustomAddonSound(itemPickupSound)
            end
        end
    end
end)

function PlayCustomAddonSound(soundPath)
    local willPlay, soundHandle = PlaySoundFile(soundPath, "Master")
    
    if not willPlay then
        print("|cff505050[MGSoundkit]|r Fehler: Sound konnte nicht abgespielt werden. Pfad prüfen!")
    end
end

