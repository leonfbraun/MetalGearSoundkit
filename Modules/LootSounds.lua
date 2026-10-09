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

frame:SetScript("OnEvent", function(_, _, chatMessage)
    local itemLink = GetLootItemLink(chatMessage)
    if itemLink and itemLink:match("item:(%d+)") then
        addon:PlayAddonSound("itemPickup", "SFX")
    end
end)
