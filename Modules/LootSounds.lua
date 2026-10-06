local _, addon = ...

local singleItemPattern = LOOT_ITEM_SELF:gsub("%%s", "(.+)")
local multipleItemsPattern = LOOT_ITEM_SELF_MULTIPLE
    :gsub("%%s", "(.+)")
    :gsub("%%d", "(%%d+)")

local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_LOOT")

frame:SetScript("OnEvent", function(_, _, message)
    local itemLink = message:match(multipleItemsPattern) or message:match(singleItemPattern)
    if itemLink and itemLink:match("item:(%d+)") then
        addon:PlayAddonSound("itemPickup", "SFX")
    end
end)
