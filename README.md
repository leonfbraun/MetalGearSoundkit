# Metal Gear Soundkit

A World of Warcraft addon that plays Metal Gear-themed sounds for selected in-game events.

## Project structure

```text
Core/
  Sound.lua             Shared sound playback and sound registry
Media/
  Sounds/               Addon audio assets
Modules/
  PlayerSounds.lua      Login, death, and resurrection sounds
  LootSounds.lua        Item pickup sounds
  HealSounds.lua        Healing potion, Healthstone, and bandage sounds
  Settings.lua          Persistent per-sound enable/disable options
MetalGearSoundkit.toc   Addon metadata and Lua load order
```

Lua files are listed explicitly in `MetalGearSoundkit.toc`. The shared sound
service is loaded before the event modules, which call it through the addon
namespace. Add new event-specific behavior as a module and register its file in
the TOC after any code it depends on. Sound enable states are stored in the
`MetalGearSoundkitDB` saved variable and can be changed in the add-on's settings
under **Options > AddOns**. The healing potion sound module expects its audio
file at `Media/Sounds/healPotion.ogg`.
