local addonName, addon = ...

local INTRO_SOUND_DELAY = 3
local INTRO_SOUND_DURATION = 11.23
local INTRO_LOGO_PHASE_DURATION = INTRO_SOUND_DURATION / 2
local INTRO_LOGO_FADE_DURATION = 1.5

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")

local logoFrame = CreateFrame("Frame", nil, UIParent)
logoFrame:SetSize(320, 180)
logoFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 165)
logoFrame:SetFrameStrata("DIALOG")
logoFrame:SetAlpha(0)
logoFrame:Hide()

local konamiLogo = logoFrame:CreateTexture(nil, "ARTWORK")
konamiLogo:SetSize(160, 170)
konamiLogo:SetPoint("CENTER")
konamiLogo:SetTexture("Interface\\AddOns\\" .. addonName .. "\\Media\\Images\\KonamiLogo.png")

local cceLogo = logoFrame:CreateTexture(nil, "ARTWORK")
cceLogo:SetAllPoints()
cceLogo:SetTexture("Interface\\AddOns\\" .. addonName .. "\\Media\\Images\\CceLogo.png")
cceLogo:Hide()

local function ShowIntroLogos()
    logoFrame:SetAlpha(0)
    konamiLogo:Show()
    cceLogo:Hide()
    logoFrame:Show()

    local elapsed = 0
    logoFrame:SetScript("OnUpdate", function(self, delta)
        elapsed = elapsed + delta

        if elapsed >= INTRO_SOUND_DURATION then
            self:SetAlpha(0)
            self:Hide()
            self:SetScript("OnUpdate", nil)
        else
            local phaseElapsed = elapsed % INTRO_LOGO_PHASE_DURATION
            if elapsed >= INTRO_LOGO_PHASE_DURATION then
                konamiLogo:Hide()
                cceLogo:Show()
            end

            if phaseElapsed < INTRO_LOGO_FADE_DURATION then
                self:SetAlpha(phaseElapsed / INTRO_LOGO_FADE_DURATION)
            elseif phaseElapsed > INTRO_LOGO_PHASE_DURATION - INTRO_LOGO_FADE_DURATION then
                self:SetAlpha((INTRO_LOGO_PHASE_DURATION - phaseElapsed) / INTRO_LOGO_FADE_DURATION)
            else
                self:SetAlpha(1)
            end
        end
    end)
end

frame:SetScript("OnEvent", function()
    print("|cff505050[MGSoundkit]|r This is Snake. Colonel, can you hear me?")
    C_Timer.After(INTRO_SOUND_DELAY, function()
        if addon:PlayAddonSound("intro", "SFX") then
            ShowIntroLogos()
        end
    end)
end)
