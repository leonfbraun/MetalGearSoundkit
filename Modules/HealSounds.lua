local _, addon = ...

local HEALING_ITEM_SPELLS = {
    -- Healing potions
    [439] = true,   -- Minor Healing Potion
    [440] = true,   -- Lesser Healing Potion
    [441] = true,   -- Healing Potion
    [2024] = true,  -- Greater Healing Potion
    [4042] = true,  -- Superior Healing Potion
    [17534] = true, -- Major Healing Potion

    -- Warlock Healthstones
    [6262] = true,  -- Minor Healthstone
    [6263] = true,  -- Lesser Healthstone
    [5720] = true,  -- Healthstone
    [5723] = true,  -- Greater Healthstone
    [11732] = true, -- Major Healthstone
    [23475] = true, -- Greater Healthstone (Improved Healthstone)
    [23476] = true, -- Major Healthstone (Improved Healthstone)
    [23477] = true, -- Major Healthstone (Improved Healthstone)
}

local BANDAGE_SPELLS = {
    [746] = true,   -- Linen Bandage
    [1159] = true,  -- Heavy Linen Bandage
    [3267] = true,  -- Wool Bandage
    [3268] = true,  -- Heavy Wool Bandage
    [7926] = true,  -- Silk Bandage
    [7927] = true,  -- Heavy Silk Bandage
    [10838] = true, -- Mageweave Bandage
    [10839] = true, -- Heavy Mageweave Bandage
    [18608] = true, -- Runecloth Bandage
    [18610] = true, -- Heavy Runecloth Bandage
}

local frame = CreateFrame("Frame")
frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")

frame:SetScript("OnEvent", function(_, _, unit, _, spellID)
    if unit == "player" and (HEALING_ITEM_SPELLS[spellID] or BANDAGE_SPELLS[spellID]) then
        addon:PlayAddonSound("ration", "SFX")
    end
end)
