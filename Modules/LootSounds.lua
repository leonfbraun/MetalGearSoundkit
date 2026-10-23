local _, addon = ...

local singleItemLootPattern = LOOT_ITEM_SELF:gsub("%%s", "(.+)")
local multipleItemLootPattern = LOOT_ITEM_SELF_MULTIPLE
    :gsub("%%s", "(.+)")
    :gsub("%%d", "(%%d+)")

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_LOOT")

local function GetLootItemLink(message)
    return message:match(multipleItemLootPattern) or message:match(singleItemLootPattern)
end

local winPattern = LOOT_ROLL_YOU_WON:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")

frame:SetScript("OnEvent", function(_, _, message)
    local itemLink = GetLootItemLink(message)
    if itemLink and itemLink:match("item:(%d+)") then
        addon:PlayAddonSound("itemPickup", "SFX")
    end

    local itemLink, rollValue = message:match(winPattern)

    if itemLink then
        local itemID = itemLink:match("item:(%d+)")
        
        if itemID then
            local _, _, itemQuality = C_Item.GetItemInfo(itemID)
            
            if itemQuality and itemQuality < 3 then
                addon:PlayAddonSound("newItem", "SFX")
            end
        end
    end
end)
