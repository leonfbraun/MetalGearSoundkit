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
        id = "newItem",
        file = "NewItem.ogg",
        label = "Neuer Gegenstand (Roll unter Selten)",
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
        id = "vrMission",
        file = "VRMission.ogg",
        label = "VR Mission (Instanz betreten)",
    },
    {
        id = "alert",
        file = "Alert.ogg",
        label = "Alert (Bosskampf beginnt)",
    },
    {
        id = "drebinJingleSmall",
        file = "DrebinJingleSmall.ogg",
        label = "Drebin-Jingle (Kleingeld)",
    },
    {
        id = "drebinJingleMedium",
        file = "DrebinJingleMedium.ogg",
        label = "Drebin-Jingle (Questbelohnung)",
    },
    {
        id = "drebinJingleLarge",
        file = "DrebinJingleLarge.ogg",
        label = "Drebin-Jingle (Goldbetrag)",
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
