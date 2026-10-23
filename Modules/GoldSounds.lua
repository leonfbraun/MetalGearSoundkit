local _, addon = ...

-- ===== Einstellungen =====
local FONT        = "Fonts\\FRIZQT__.TTF"   -- besser: eigene .ttf im Addon-Ordner
local FONT_SIZE   = 16
local COLOR       = { 0.95, 0.90, 0.67 }    -- aus dem Screenshot gemessen
local OFFSET_X    = -113                    -- Abstand vom rechten Rand
local OFFSET_Y    = 390                     -- Oberkante des Textblocks, von unten gemessen
local LINE_H      = 17                      -- Zeilenabstand
local ENTRY_GAP   = 0
local CHARS_PER_S = 45                      -- Tipp-Geschwindigkeit
local HOLD_TIME   = 3.0                     -- Sekunden stehen, nachdem fertig getippt
local FADE_TIME   = 0.6
local MAX_ENTRIES = 3
-- =========================

local container = CreateFrame("Frame", nil, UIParent)
container:SetSize(420, 120)
container:SetPoint("TOPRIGHT", UIParent, "BOTTOMRIGHT", OFFSET_X, OFFSET_Y)
container:SetFrameStrata("HIGH")

local entries, pool = {}, {}

local function FormatMoney(copper)
    local g = math.floor(copper / 10000)
    local s = math.floor((copper % 10000) / 100)
    local k = copper % 100
    local parts = {}
    if g > 0 then parts[#parts + 1] = g .. "G" end
    if s > 0 then parts[#parts + 1] = s .. "S" end
    if k > 0 or #parts == 0 then parts[#parts + 1] = k .. "C" end
    return "+" .. table.concat(parts, " ")
end

local function AddEntry(line1, line2, soundId)
    -- Nur ASCII verwenden (kein Ä/Ö/Ü), weil die Tipp-Animation nach Bytes kürzt
    if #entries >= MAX_ENTRIES then
        local old = table.remove(entries, 1)
        old.fs:Hide()
        pool[#pool + 1] = old.fs
    end

    local fs = table.remove(pool)
    if not fs then
        fs = container:CreateFontString(nil, "OVERLAY")
        fs:SetFont(FONT, FONT_SIZE, "")
        fs:SetTextColor(COLOR[1], COLOR[2], COLOR[3])
        fs:SetShadowColor(0, 0, 0, 0.8)
        fs:SetShadowOffset(1, -1)
        fs:SetJustifyH("RIGHT")
        fs:SetSpacing(LINE_H - FONT_SIZE)
    end
    fs:SetText("")
    fs:SetAlpha(1)
    fs:Show()

    entries[#entries + 1] = {
        fs = fs, full = line1 .. "\n" .. line2, shown = 0, age = 0,
    }
    addon:PlayAddonSound(soundId, "SFX")
end

container:SetScript("OnUpdate", function(self, dt)
    -- Update + abgelaufene entfernen
    for i = #entries, 1, -1 do
        local e = entries[i]
        e.shown = math.min(#e.full, e.shown + CHARS_PER_S * dt)
        if e.shown >= #e.full then e.age = e.age + dt end

        local alpha = 1
        if e.age > HOLD_TIME then alpha = 1 - (e.age - HOLD_TIME) / FADE_TIME end

        if alpha <= 0 then
            e.fs:Hide()
            pool[#pool + 1] = e.fs
            table.remove(entries, i)
        else
            e.fs:SetText(e.full:sub(1, math.floor(e.shown)))
            e.fs:SetAlpha(alpha)
        end
    end
    -- Layout: Einträge untereinander, neuester ganz unten
    local y = 0
    for _, e in ipairs(entries) do
        e.fs:ClearAllPoints()
        e.fs:SetPoint("TOPRIGHT", container, "TOPRIGHT", 0, -y)
        y = y + 2 * LINE_H + ENTRY_GAP
    end
end)

local SOURCE_TEXT = {
    LOOT    = "LOOT COLLECTED",
    QUEST   = "QUEST COMPLETED",
    VERKAUF = "ITEM SOLD",
    POST    = "MAIL RECEIVED",
    HANDEL  = "TRADE COMPLETED",
    AUCTION = "AUCTION SETTLED",
    DEFAULT = "MONEY RECEIVED",
}

local lastMoney = 0
local pendingDelta, pendingCount, flushScheduled = 0, 0, false
local atMerchant, atMail, atTrade, atAuction = false, false, false, false
local questUntil, lootUntil = 0, 0
local COPPER_PER_GOLD = 10000

local function GetSource()
    local now = GetTime()
    if now < questUntil then return "QUEST" end
    if atMerchant then return "VERKAUF" end
    if atMail     then return "POST" end
    if atTrade    then return "HANDEL" end
    if atAuction  then return "AUCTION" end
    if now < lootUntil  then return "LOOT" end
    return "DEFAULT"
end

local function Flush()
    flushScheduled = false
    local delta, count = pendingDelta, pendingCount
    pendingDelta, pendingCount = 0, 0
    if delta <= 0 then return end

    local line2 = FormatMoney(delta)
    if count > 1 then line2 = line2 .. " x" .. count end
    local source = GetSource()
    local soundId = "drebinJingleSmall"
    if source == "QUEST" then
        soundId = "drebinJingleMedium"
    elseif delta >= COPPER_PER_GOLD then
        soundId = "drebinJingleLarge"
    end
    AddEntry(SOURCE_TEXT[source] or SOURCE_TEXT.DEFAULT, line2, soundId)
end

local HANDLERS = {
    PLAYER_ENTERING_WORLD = function() lastMoney = GetMoney() end,
    PLAYER_MONEY = function()
        local now = GetMoney()
        local delta = now - lastMoney
        lastMoney = now
        if delta > 0 then
            pendingDelta = pendingDelta + delta
            pendingCount = pendingCount + 1
            if not flushScheduled then
                flushScheduled = true
                C_Timer.After(0.2, Flush)
            end
        end
    end,
    CHAT_MSG_MONEY        = function() lootUntil  = GetTime() + 1.5 end,
    QUEST_TURNED_IN       = function() questUntil = GetTime() + 2.0 end,
    MERCHANT_SHOW         = function() atMerchant = true  end,
    MERCHANT_CLOSED       = function() atMerchant = false end,
    MAIL_SHOW             = function() atMail     = true  end,
    MAIL_CLOSED           = function() atMail     = false end,
    TRADE_SHOW            = function() atTrade    = true  end,
    TRADE_CLOSED          = function() atTrade    = false end,
    AUCTION_HOUSE_SHOW    = function() atAuction  = true  end,
    AUCTION_HOUSE_CLOSED  = function() atAuction  = false end,
}

local frame = CreateFrame("Frame")
for event in pairs(HANDLERS) do
    pcall(frame.RegisterEvent, frame, event)
end
frame:SetScript("OnEvent", function(self, event, ...)
    HANDLERS[event](...)
end)