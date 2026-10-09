local _, addon = ...

addon.soundDefinitions = {
    {
        id = "death",
        file = "death.ogg",
        label = "Todessound",
    },
    {
        id = "releaseGhost",
        file = "continue.ogg",
        label = "Wiederbelebung",
    },
    {
        id = "itemPickup",
        file = "itemPickup.ogg",
        label = "Gegenstand aufgehoben",
    },
    {
        id = "ration",
        file = "ration.ogg",
        label = "Heil-Items benutzt",
    },
    {
        id = "intro",
        file = "intro.ogg",
        label = "Intro",
    },
    {
        id = "itemEquip",
        label = "Item ausgerüstet",
        variants = {
            {
                id = "itemEquipMGS1",
                file = "itemEquipMGS1.ogg",
                label = "MGS1",
            },
            {
                id = "itemEquipMGS3",
                file = "itemEquipMGS3.ogg",
                label = "MGS3",
            },
        },
    },
}
