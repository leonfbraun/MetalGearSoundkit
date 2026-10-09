# Metal Gear Soundkit

A World of Warcraft addon that plays Metal Gear-themed sounds for selected in-game events.

## How the addon is organized

```text
Core/
  SoundDefinitions.lua  Sound IDs, labels, files, and variants
  Sound.lua             Playback API and SavedVariables
Media/
  Sounds/               Audio files referenced by the definitions
Modules/
  PlayerSounds.lua      Player login, death, resurrection, and equipment events
  LootSounds.lua        Loot chat events
  HealSounds.lua        Healing item and bandage spell events
  Settings.lua          Options panel built from the sound definitions
MetalGearSoundkit.toc   Addon metadata and file load order
```

Lua files are listed explicitly in `MetalGearSoundkit.toc`. Its order matters:
the sound definitions load before the shared sound service, and the service
loads before the event and settings modules. Files in this addon share the
`addon` table passed through WoW's addon namespace (`local addonName, addon = ...`).

## Add a configurable sound

1. Put the audio file in `Media/Sounds/`.
2. Add a definition to `Core/SoundDefinitions.lua`:

   ```lua
   {
       id = "mySound",
       file = "mySound.ogg",
       label = "My sound",
   },
   ```

   The `id` is the stable settings key. Keep it unique and do not rename it
   after users have saved settings for it.
3. Play it from an event module:

   ```lua
   addon:PlayAddonSound("mySound", "SFX")
   ```

   The settings panel and SavedVariables entry are generated from the
   definition. New sounds are enabled by default.

## Add a sound variant

The existing ItemEquip setting demonstrates variants: its setting has the ID
`itemEquip`, and each variant has its own unique `id`, `file`, and `label`.
`addon:GetItemEquipSound()` returns the selected variant ID, which can be passed
to `addon:PlayAddonSound()`. The current settings panel only provides a variant
dropdown for ItemEquip; adding another variant selector also requires extending
the setting API in `Core/Sound.lua` and the panel in `Modules/Settings.lua`.

## Add a new event module

Create a Lua file under `Modules/`, obtain the shared addon table at the top,
register the relevant WoW event on a frame, then play a configured sound when
the event matches. For example:

```lua
local _, addon = ...

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_DEAD")
frame:SetScript("OnEvent", function()
    addon:PlayAddonSound("death", "SFX")
end)
```

Add the new file to `MetalGearSoundkit.toc` after the definitions and shared
sound service.

## Settings and persistence

The settings panel is under **Options > AddOns > Metal Gear Soundkit**. Sound
enable states are stored in `MetalGearSoundkitDB.sounds[soundId].enabled` in
WoW's SavedVariables. Item equipment has two separate settings: the on/off
state is `sounds.itemEquip.enabled`, while the selected MGS1/MGS3 variant is
`itemEquipSound`.
