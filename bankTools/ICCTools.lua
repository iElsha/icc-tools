local AddonName, TT = ...

local realmToNameHorde = {
        ["Aegwynn"] = "Iccbh-Aegwynn",

        ["AeriePeak"] = "Iccbh-AeriePeak",
        ["Bronzebeard"] = "Iccbh-AeriePeak",
        ["Blade'sEdge"] = "Iccbh-AeriePeak",
        ["Vek'nilash"] = "Iccbh-AeriePeak",
        ["Eonar"] = "Iccbh-AeriePeak",
    
        ["Agamaggan"] = "Iccbh-Agamaggan",
        ["Emeriss"] = "Iccbh-Agamaggan",
        ["Twilight'sHammer"] = "Iccbh-Agamaggan",
        ["Bloodscalp"] = "Iccbh-Agamaggan",
        ["Crushridge"] = "Iccbh-Agamaggan",
        ["Hakkar"] = "Iccbh-Agamaggan",

        ["Aggramar"] = "Iccbh-Aggramar",
        ["Hellscream"] = "Iccbh-Aggramar",

        ["Alexstrasza"] = "Iccbh-Alexstrasza",
        ["Nethersturm"] = "Iccbh-Alexstrasza",
        ["Madmortem"] = "Iccbh-Alexstrasza",
        ["Proudmoore"] = "Iccbh-Alexstrasza",

        ["Alleria"] = "Iccbh-Alleria",
        ["Rexxar"] = "Iccbh-Alleria",
    
        ["Alonsus"] = "Iccbh-Alonsus",
        ["KulTiras"] = "Iccbh-Alonsus",
        ["Anachronos"] = "Iccbh-Alonsus",

        ["Aman'thul"] = "Iccbh-Aman'thul",
        ["Anub'arak"] = "Iccbh-Aman'thul",
        ["Zuluhed"] = "Iccbh-Aman'thul",
        ["Nazjatar"] = "Iccbh-Aman'thul",
        ["Dalvengyr"] = "Iccbh-Aman'thul",
        ["Frostmourne"] = "Iccbh-Aman'thul",
    
        ["Antonidas"] = "Iccbh-Antonidas",

        ["Arathi"] = "Iccbh-Arathi",
        ["Templenoir"] = "Iccbh-Arathi",
        ["Illidan"] = "Iccbh-Arathi",
        ["Naxxramas"] = "Iccbh-Arathi",

        ["Archimonde"] = "Iccbh-Archimonde",

        ["Area52"] = "Iccbh-Area52",
        ["Sen'jin"] = "Iccbh-Area52",
        ["Un'Goro"] = "Iccbh-Area52",
    
        ["Nagrand"] = "Iccbh-Nagrand",
        ["Runetotem"] = "Iccbh-Nagrand",
        ["Kilrogg"] = "Iccbh-Nagrand",
        ["Arathor"] = "Iccbh-Nagrand",
        ["Hellfire"] = "Iccbh-Nagrand",
    
        ["ArgentDawn"] = "Iccbh-ArgentDawn",

        ["Arthas"] = "Iccbh-Arthas",
        ["Vek'lor"] = "Iccbh-Arthas",
        ["Kel'Thuzad"] = "Iccbh-Arthas",
        ["Wrathbringer"] = "Iccbh-Arthas",
        ["Blutkessel"] = "Iccbh-Arthas",
        ["Durotan"] = "Iccbh-Arthas",
        ["Tirion"] = "Iccbh-Arthas",
    
        ["Aszune"] = "Iccbh-Aszune",
        ["Shadowsong"] = "Iccbh-Aszune",

        ["Baelgun"] = "Iccbh-Baelgun",
        ["Lothar"] = "Iccbh-Baelgun",
        ["Azshara"] = "Iccbh-Baelgun",
        ["Krag'jin"] = "Iccbh-Baelgun",

        ["Balnazzar"] = "Iccbh-Balnazzar",
        ["Boulderfist"] = "Iccbh-Balnazzar",
        ["Trollbane"] = "Iccbh-Balnazzar",
        ["LaughingSkull"] = "Iccbh-Balnazzar",
        ["Daggerspine"] = "Iccbh-Balnazzar",
        ["Ahn'Qiraj"] = "Iccbh-Balnazzar",
        ["Talnivarr"] = "Iccbh-Balnazzar",
        ["ShatteredHalls"] = "Iccbh-Balnazzar",
        ["Sunstrider"] = "Iccbh-Balnazzar",
        ["Chromaggus"] = "Iccbh-Balnazzar",
    
        ["Blackhand"] = "Iccbh-Blackhand",
        ["Mal'Ganis"] = "Iccbh-Blackhand",
        ["Taerar"] = "Iccbh-Blackhand",
        ["Echsenkessel"] = "Iccbh-Blackhand",

        ["Blackmoore"] = "Iccbh-Blackmoore",
        ["Lordaeron"] = "Iccbh-Blackmoore",
        ["Tichondrius"] = "Iccbh-Blackmoore",

        ["Blackrock"] = "Iccbh-Blackrock",

        ["Bloodfeather"] = "Iccbh-Bloodfeather",
        ["BurningSteppes"] = "Iccbh-Bloodfeather",
        ["ShatteredHand"] = "Iccbh-Bloodfeather",
        ["Kor'gall"] = "Iccbh-Bloodfeather",
        ["Executus"] = "Iccbh-Bloodfeather",
        ["Darkspear"] = "Iccbh-Bloodfeather",
        ["Saurfang"] = "Iccbh-Bloodfeather",
        ["Terokkar"] = "Iccbh-Bloodfeather",

        ["BurningLegion"] = "Iccbh-BurningLegion",
        ["Xavius"] = "Iccbh-BurningLegion",
        ["Al'Akir"] = "Iccbh-BurningLegion",
        ["Skullcrusher"] = "Iccbh-BurningLegion",

        ["ChamberofAspects"] = "Iccbh-ChamberofAspects",

        ["Dalaran"] = "Iccbh-Dalaran",
        ["MarécagedeZangar"] = "Iccbh-Dalaran",
        ["Sinstralis"] = "Iccbh-Dalaran",
        ["Eldre'Thalas"] = "Iccbh-Dalaran",
        ["Cho'gall"] = "Iccbh-Dalaran",

        ["DasKonsortium"] = "Iccbh-DasKonsortium",
        ["KultderVerdammten"] = "Iccbh-DasKonsortium",
        ["DieTodeskrallen"] = "Iccbh-DasKonsortium",
        ["DieArguswacht"] = "Iccbh-DasKonsortium",
        ["DerabyssischeRat"] = "Iccbh-DasKonsortium",
        ["DasSyndikat"] = "Iccbh-DasKonsortium",
        ["DieSilberneHand"] = "Iccbh-DasKonsortium",
        ["DieewigeWacht"] = "Iccbh-DasKonsortium",

        ["Deathwing"] = "Iccbh-Deathwing",
        ["TheMaelstrom"] = "Iccbh-Deathwing",
        ["Lightning'sBlade"] = "Iccbh-Deathwing",
        ["Karazhan"] = "Iccbh-Deathwing",
        ["Dragonblight"] = "Iccbh-Deathwing",
        ["Ghostlands"] = "Iccbh-Deathwing",

        ["DefiasBrotherhood"] = "Iccbh-DefiasBrotherhood",
        ["TheVentureCo"] = "Iccbh-DefiasBrotherhood",
        ["Sporeggar"] = "Iccbh-DefiasBrotherhood",
        ["ScarshieldLegion"] = "Iccbh-DefiasBrotherhood",
        ["Ravenholdt"] = "Iccbh-DefiasBrotherhood",
        ["DarkmoonFaire"] = "Iccbh-DefiasBrotherhood",
        ["EarthenRing"] = "Iccbh-DefiasBrotherhood",

        ["Destromath"] = "Iccbh-Destromath",
        ["Nera'thor"] = "Iccbh-Destromath",
        ["Nefarian"] = "Iccbh-Destromath",
        ["Mannoroth"] = "Iccbh-Destromath",
        ["Gorgonnash"] = "Iccbh-Destromath",
        ["Gilneas"] = "Iccbh-Destromath",
        ["Ulduar"] = "Iccbh-Destromath",

        ["DieAldor"] = "Iccbh-DieAldor",

        ["DieNachtwache"] = "Iccbh-DieNachtwache",
        ["Forscherliga"] = "Iccbh-DieNachtwache",
        ["ZirkeldesCenarius"] = "Iccbh-DieNachtwache",
        ["Todeswache"] = "Iccbh-DieNachtwache",
        ["DerMithrilorden"] = "Iccbh-DieNachtwache",
        ["DerRatvonDalaran"] = "Iccbh-DieNachtwache",

        ["Doomhammer"] = "Iccbh-Doomhammer",
        ["Turalyon"] = "Iccbh-Doomhammer",

        ["Draenor"] = "Iccbh-Draenor",

        ["Drak'thul"] = "Iccbh-Drak'thul",
        ["BurningBlade"] = "Iccbh-Drak'thul",

        ["Drek'Thar"] = "Iccbh-Drek'Thar",
        ["Uldaman"] = "Iccbh-Drek'Thar",
        ["Eitrigg"] = "Iccbh-Drek'Thar",
        ["Krasus"] = "Iccbh-Drek'Thar",

        ["DunModr"] = "Iccbh-DunModr",
        ["C'Thun"] = "Iccbh-DunModr",

        ["DunMorogh"] = "Iccbh-DunMorogh",
        ["Norgannon"] = "Iccbh-DunMorogh",

        ["Elune"] = "Iccbh-Elune",
        ["Varimathras"] = "Iccbh-Elune",

        ["EmeraldDream"] = "Iccbh-EmeraldDream",
        ["Terenas"] = "Iccbh-EmeraldDream",

        ["Eredar"] = "Iccbh-Eredar",

        ["Exodar"] = "Iccbh-Exodar",
        ["Minahonda"] = "Iccbh-Exodar",

        ["Frostwolf"] = "Iccbh-Frostwolf",

        ["GrimBatol"] = "Iccbh-GrimBatol",
        ["Aggra(Português)"] = "Iccbh-GrimBatol",
        ["Frostmane"] = "Iccbh-GrimBatol",


        ["Hyjal"] = "Iccbh-Hyjal",

        ["Kazzak"] = "Iccbh-Kazzak",

        ["Khadgar"] = "Iccbh-Khadgar",
        ["Bloodhoof"] = "Iccbh-Khadgar",

        ["Khaz'goroth"] = "Iccbh-Khaz'goroth",
        ["Arygos"] = "Iccbh-Khaz'goroth",

        ["KhazModan"] = "Iccbh-KhazModan",

        ["KirinTor"] = "Iccbh-KirinTor",
        ["ConseildesOmbres"] = "Iccbh-KirinTor",
        ["CultedelaRivenoire"] = "Iccbh-KirinTor",
        ["LaCroisadeécarlate"] = "Iccbh-KirinTor",
        ["LesClairvoyants"] = "Iccbh-KirinTor",
        ["LesSentinelles"] = "Iccbh-KirinTor",
        ["ConfrérieduThorium"] = "Iccbh-KirinTor",

        ["Lightbringer"] = "Iccbh-Lightbringer",
        ["Mazrigos"] = "Iccbh-Lightbringer",

        ["Magtheridon"] = "Iccbh-Magtheridon",

        ["Malfurion"] = "Iccbh-Malfurion",
        ["Malygos"] = "Iccbh-Malfurion",

        ["Malorne"] = "Iccbh-Malorne",
        ["Ysera"] = "Iccbh-Malorne",

        ["Medivh"] = "Iccbh-Medivh",
        ["Suramar"] = "Iccbh-Medivh",

        ["Moonglade"] = "Iccbh-Moonglade",
        ["TheSha'tar"] = "Iccbh-Moonglade",
        ["SteamwheedleCartel"] = "Iccbh-Moonglade",

        ["Nathrezim"] = "Iccbh-Nathrezim",
        ["Anetheron"] = "Iccbh-Nathrezim",
        ["FestungderStürme"] = "Iccbh-Nathrezim",
        ["Gul'dan"] = "Iccbh-Nathrezim",
        ["Kil'jaeden"] = "Iccbh-Nathrezim",
        ["Rajaxx"] = "Iccbh-Nathrezim",

        ["Nemesis"] = "Iccbh-Nemesis",

        ["Nordrassil"] = "Iccbh-Nordrassil",
        ["BronzeDragonflight"] = "Iccbh-Nordrassil",

        ["Onyxia"] = "Iccbh-Onyxia",
        ["Terrordar"] = "Iccbh-Onyxia",
        ["Theradras"] = "Iccbh-Onyxia",
        ["Mug'thol"] = "Iccbh-Onyxia",
        ["Dethecus"] = "Iccbh-Onyxia",

        ["Outland"] = "Iccbh-Outland",

        ["Perenolde"] = "Iccbh-Perenolde",
        ["Teldrassil"] = "Iccbh-Perenolde",
        ["Nozdormu"] = "Iccbh-Nozdormu",
        ["Shattrath"] = "Iccbh-Nozdormu",
        ["Garrosh"] = "Iccbh-Nozdormu",

        ["Pozzodell'Eternità"] = "Iccbh-Pozzodell'Eternità",

        ["Quel'Thalas"] = "Iccbh-Quel'Thalas",
        ["AzjolNerub"] = "Iccbh-Quel'Thalas",

        ["Ragnaros"] = "Iccbh-Ragnaros",

        ["Rashgarroth"] = "Iccbh-Rashgarroth",
        ["Arakarahm"] = "Iccbh-Rashgarroth",
        ["Kael'thas"] = "Iccbh-Rashgarroth",
        ["Throk'Feroth"] = "Iccbh-Rashgarroth",

        ["Ravencrest"] = "Iccbh-Ravencrest",

        ["Sanguino"] = "Iccbh-Sanguino",
        ["Zul'jin"] = "Iccbh-Sanguino",
        ["Uldum"] = "Iccbh-Sanguino",
        ["Shen'dralar"] = "Iccbh-Sanguino",

        ["Sargeras"] = "Iccbh-Sargeras",
        ["Ner'zhul"] = "Iccbh-Sargeras",
        ["Garona"] = "Iccbh-Sargeras",

        ["Silvermoon"] = "Iccbh-Silvermoon",

        ["Stormrage"] = "Iccbh-Stormrage",
        ["Azuremyst"] = "Iccbh-Stormrage",

        ["Stormreaver"] = "Iccbh-Stormreaver",
        ["Vashj"] = "Iccbh-Stormreaver",
        ["Spinebreaker"] = "Iccbh-Stormreaver",
        ["Haomarush"] = "Iccbh-Stormreaver",
        ["Dragonmaw"] = "Iccbh-Stormreaver",

        ["Stormscale"] = "Iccbh-Stormscale",

        ["Sylvanas"] = "Iccbh-Sylvanas",
        ["Auchindoun"] = "Iccbh-Sylvanas",
        ["Jaedenar"] = "Iccbh-Sylvanas",
        ["Dunemaul"] = "Iccbh-Sylvanas",

        ["TarrenMill"] = "Iccbh-TarrenMill",
        ["Dentarg"] = "Iccbh-TarrenMill",   

        ["Thrall"] = "Iccbh-Thrall",
        ["Kargath"] = "Iccbh-Thrall",
        ["Ambossar"] = "Iccbh-Thrall",

        ["TwistingNether"] = "Iccbh-TwistingNether",

        ["Tyrande"] = "Iccbh-Tyrande",
        ["LosErrantes"] = "Iccbh-Tyrande",
        ["ColinasPardas"] = "Iccbh-Tyrande",

        ["Vol'jin"] = "Iccbh-Vol'jin",
        ["Chantséternels"] = "Iccbh-Vol'jin",

        ["Wildhammer"] = "Iccbh-Wildhammer",
        ["Thunderhorn"] = "Iccbh-Wildhammer",

        ["Ysondre"] = "Iccbh-Ysondre",

        ["Zenedar"] = "Iccbh-Zenedar",
        ["Darksorrow"] = "Iccbh-Zenedar",
        ["Neptulon"] = "Iccbh-Zenedar",
        ["Genjuros"] = "Iccbh-Zenedar",
        ["Bladefist"] = "Iccbh-Zenedar",
        ["Frostwhisper"] = "Iccbh-Zenedar", 

        ["Anasterian"] = "DO NOT USE",--ptr
}

local realmToNameAlliance = {
    ["Aegwynn"] = "Iccba-Aegwynn",

    ["AeriePeak"] = "Iccba-AeriePeak",
    ["Bronzebeard"] = "Iccba-AeriePeak",
    ["Blade'sEdge"] = "Iccba-AeriePeak",
    ["Vek'nilash"] = "Iccba-AeriePeak",
    ["Eonar"] = "Iccba-AeriePeak",

    ["Agamaggan"] = "Iccba-Agamaggan",
    ["Emeriss"] = "Iccba-Agamaggan",
    ["Twilight'sHammer"] = "Iccba-Agamaggan",
    ["Bloodscalp"] = "Iccba-Agamaggan",
    ["Crushridge"] = "Iccba-Agamaggan",
    ["Hakkar"] = "Iccba-Agamaggan",

    ["Aggramar"] = "Iccba-Aggramar",
    ["Hellscream"] = "Iccba-Aggramar",

    ["Alexstrasza"] = "Iccba-Alexstrasza",
    ["Nethersturm"] = "Iccba-Alexstrasza",
    ["Madmortem"] = "Iccba-Alexstrasza",
    ["Proudmoore"] = "Iccba-Alexstrasza",

    ["Alleria"] = "Iccba-Alleria",
    ["Rexxar"] = "Iccba-Alleria",

    ["Alonsus"] = "Iccba-Alonsus",
    ["KulTiras"] = "Iccba-Alonsus",
    ["Anachronos"] = "Iccba-Alonsus",

    ["Aman'thul"] = "Iccba-Aman'thul",
    ["Anub'arak"] = "Iccba-Aman'thul",
    ["Zuluhed"] = "Iccba-Aman'thul",
    ["Nazjatar"] = "Iccba-Aman'thul",
    ["Dalvengyr"] = "Iccba-Aman'thul",
    ["Frostmourne"] = "Iccba-Aman'thul",

    ["Antonidas"] = "Iccba-Antonidas",

    ["Arathi"] = "Iccba-Arathi",
    ["Templenoir"] = "Iccba-Arathi",
    ["Illidan"] = "Iccba-Arathi",
    ["Naxxramas"] = "Iccba-Arathi",

    ["Archimonde"] = "Iccba-Archimonde",

    ["Area52"] = "Iccba-Area52",
    ["Sen'jin"] = "Iccba-Area52",
    ["Un'Goro"] = "Iccba-Area52",

    ["Nagrand"] = "Iccba-Nagrand",
    ["Runetotem"] = "Iccba-Nagrand",
    ["Kilrogg"] = "Iccba-Nagrand",
    ["Arathor"] = "Iccba-Nagrand",
    ["Hellfire"] = "Iccba-Nagrand",

    ["ArgentDawn"] = "Iccba-ArgentDawn",

    ["Arthas"] = "Iccba-Arthas",
    ["Vek'lor"] = "Iccba-Arthas",
    ["Kel'Thuzad"] = "Iccba-Arthas",
    ["Wrathbringer"] = "Iccba-Arthas",
    ["Blutkessel"] = "Iccba-Arthas",
    ["Durotan"] = "Iccba-Arthas",
    ["Tirion"] = "Iccba-Arthas",

    ["Aszune"] = "Iccba-Aszune",
    ["Shadowsong"] = "Iccba-Aszune",

    ["Baelgun"] = "Iccba-Baelgun",
    ["Lothar"] = "Iccba-Baelgun",
    ["Azshara"] = "Iccba-Baelgun",
    ["Krag'jin"] = "Iccba-Baelgun",

    ["Balnazzar"] = "Iccba-Balnazzar",
    ["Boulderfist"] = "Iccba-Balnazzar",
    ["Trollbane"] = "Iccba-Balnazzar",
    ["LaughingSkull"] = "Iccba-Balnazzar",
    ["Daggerspine"] = "Iccba-Balnazzar",
    ["Ahn'Qiraj"] = "Iccba-Balnazzar",
    ["Talnivarr"] = "Iccba-Balnazzar",
    ["ShatteredHalls"] = "Iccba-Balnazzar",
    ["Sunstrider"] = "Iccba-Balnazzar",
    ["Chromaggus"] = "Iccba-Balnazzar",

    ["Blackhand"] = "Iccba-Blackhand",
    ["Mal'Ganis"] = "Iccba-Blackhand",
    ["Taerar"] = "Iccba-Blackhand",
    ["Echsenkessel"] = "Iccba-Blackhand",

    ["Blackmoore"] = "Iccba-Blackmoore",
    ["Lordaeron"] = "Iccba-Blackmoore",
    ["Tichondrius"] = "Iccba-Blackmoore",

    ["Blackrock"] = "Iccba-Blackrock",

    ["Bloodfeather"] = "Iccba-Bloodfeather",
    ["BurningSteppes"] = "Iccba-Bloodfeather",
    ["ShatteredHand"] = "Iccba-Bloodfeather",
    ["Kor'gall"] = "Iccba-Bloodfeather",
    ["Executus"] = "Iccba-Bloodfeather",
    ["Darkspear"] = "Iccba-Bloodfeather",
    ["Saurfang"] = "Iccba-Bloodfeather",
    ["Terokkar"] = "Iccba-Bloodfeather",

    ["BurningLegion"] = "Iccba-BurningLegion",
    ["Xavius"] = "Iccba-BurningLegion",
    ["Al'Akir"] = "Iccba-BurningLegion",
    ["Skullcrusher"] = "Iccba-BurningLegion",

    ["ChamberofAspects"] = "Iccba-ChamberofAspects",

    ["Dalaran"] = "Iccba-Dalaran",
    ["MarécagedeZangar"] = "Iccba-Dalaran",
    ["Sinstralis"] = "Iccba-Dalaran",
    ["Eldre'Thalas"] = "Iccba-Dalaran",
    ["Cho'gall"] = "Iccba-Dalaran",

    ["DasKonsortium"] = "Iccba-DasKonsortium",
    ["KultderVerdammten"] = "Iccba-DasKonsortium",
    ["DieTodeskrallen"] = "Iccba-DasKonsortium",
    ["DieArguswacht"] = "Iccba-DasKonsortium",
    ["DerabyssischeRat"] = "Iccba-DasKonsortium",
    ["DasSyndikat"] = "Iccba-DasKonsortium",
    ["DieSilberneHand"] = "Iccba-DasKonsortium",
    ["DieewigeWacht"] = "Iccba-DasKonsortium",

    ["Deathwing"] = "Iccba-Deathwing",
    ["TheMaelstrom"] = "Iccba-Deathwing",
    ["Lightning'sBlade"] = "Iccba-Deathwing",
    ["Karazhan"] = "Iccba-Deathwing",
    ["Dragonblight"] = "Iccba-Deathwing",
    ["Ghostlands"] = "Iccba-Deathwing",

    ["DefiasBrotherhood"] = "Iccba-DefiasBrotherhood",
    ["TheVentureCo"] = "Iccba-DefiasBrotherhood",
    ["Sporeggar"] = "Iccba-DefiasBrotherhood",
    ["ScarshieldLegion"] = "Iccba-DefiasBrotherhood",
    ["Ravenholdt"] = "Iccba-DefiasBrotherhood",
    ["DarkmoonFaire"] = "Iccba-DefiasBrotherhood",
    ["EarthenRing"] = "Iccba-DefiasBrotherhood",

    ["Destromath"] = "Iccba-Destromath",
    ["Nera'thor"] = "Iccba-Destromath",
    ["Nefarian"] = "Iccba-Destromath",
    ["Mannoroth"] = "Iccba-Destromath",
    ["Gorgonnash"] = "Iccba-Destromath",
    ["Gilneas"] = "Iccba-Destromath",
    ["Ulduar"] = "Iccba-Destromath",

    ["DieAldor"] = "Iccba-DieAldor",

    ["DieNachtwache"] = "Iccba-DieNachtwache",
    ["Forscherliga"] = "Iccba-DieNachtwache",
    ["ZirkeldesCenarius"] = "Iccba-DieNachtwache",
    ["Todeswache"] = "Iccba-DieNachtwache",
    ["DerMithrilorden"] = "Iccba-DieNachtwache",
    ["DerRatvonDalaran"] = "Iccba-DieNachtwache",

    ["Doomhammer"] = "Iccba-Doomhammer",
    ["Turalyon"] = "Iccba-Doomhammer",

    ["Draenor"] = "Iccba-Draenor",

    ["Drak'thul"] = "Iccba-Drak'thul",
    ["BurningBlade"] = "Iccba-Drak'thul",

    ["Drek'Thar"] = "Iccba-Drek'Thar",
    ["Uldaman"] = "Iccba-Drek'Thar",
    ["Eitrigg"] = "Iccba-Drek'Thar",
    ["Krasus"] = "Iccba-Drek'Thar",

    ["DunModr"] = "Iccba-DunModr",
    ["C'Thun"] = "Iccba-DunModr",

    ["DunMorogh"] = "Iccba-DunMorogh",
    ["Norgannon"] = "Iccba-DunMorogh",

    ["Elune"] = "Iccba-Elune",
    ["Varimathras"] = "Iccba-Elune",

    ["EmeraldDream"] = "Iccba-EmeraldDream",
    ["Terenas"] = "Iccba-EmeraldDream",

    ["Eredar"] = "Iccba-Eredar",

    ["Exodar"] = "Iccba-Exodar",
    ["Minahonda"] = "Iccba-Exodar",

    ["Frostwolf"] = "Iccba-Frostwolf",

    ["GrimBatol"] = "Iccba-GrimBatol",
    ["Aggra(Português)"] = "Iccba-GrimBatol",
    ["Frostmane"] = "Iccba-GrimBatol",


    ["Hyjal"] = "Iccba-Hyjal",

    ["Kazzak"] = "Iccba-Kazzak",

    ["Khadgar"] = "Iccba-Khadgar",
    ["Bloodhoof"] = "Iccba-Khadgar",

    ["Khaz'goroth"] = "Iccba-Khaz'goroth",
    ["Arygos"] = "Iccba-Khaz'goroth",

    ["KhazModan"] = "Iccba-KhazModan",

    ["KirinTor"] = "Iccba-KirinTor",
    ["ConseildesOmbres"] = "Iccba-KirinTor",
    ["CultedelaRivenoire"] = "Iccba-KirinTor",
    ["LaCroisadeécarlate"] = "Iccba-KirinTor",
    ["LesClairvoyants"] = "Iccba-KirinTor",
    ["LesSentinelles"] = "Iccba-KirinTor",
    ["ConfrérieduThorium"] = "Iccba-KirinTor",

    ["Lightbringer"] = "Iccba-Lightbringer",
    ["Mazrigos"] = "Iccba-Lightbringer",

    ["Magtheridon"] = "Iccba-Magtheridon",

    ["Malfurion"] = "Iccba-Malfurion",
    ["Malygos"] = "Iccba-Malfurion",

    ["Malorne"] = "Iccba-Malorne",
    ["Ysera"] = "Iccba-Malorne",

    ["Medivh"] = "Iccba-Medivh",
    ["Suramar"] = "Iccba-Medivh",

    ["Moonglade"] = "Iccba-Moonglade",
    ["TheSha'tar"] = "Iccba-Moonglade",
    ["SteamwheedleCartel"] = "Iccba-Moonglade",

    ["Nathrezim"] = "Iccba-Nathrezim",
    ["Anetheron"] = "Iccba-Nathrezim",
    ["FestungderStürme"] = "Iccba-Nathrezim",
    ["Gul'dan"] = "Iccba-Nathrezim",
    ["Kil'jaeden"] = "Iccba-Nathrezim",
    ["Rajaxx"] = "Iccba-Nathrezim",

    ["Nemesis"] = "Iccba-Nemesis",

    ["Nordrassil"] = "Iccba-Nordrassil",
    ["BronzeDragonflight"] = "Iccba-Nordrassil",

    ["Onyxia"] = "Iccba-Onyxia",
    ["Terrordar"] = "Iccba-Onyxia",
    ["Theradras"] = "Iccba-Onyxia",
    ["Mug'thol"] = "Iccba-Onyxia",
    ["Dethecus"] = "Iccba-Onyxia",

    ["Outland"] = "Iccba-Outland",

    ["Perenolde"] = "Iccba-Perenolde",
    ["Teldrassil"] = "Iccba-Perenolde",
    ["Nozdormu"] = "Iccba-Nozdormu",
    ["Shattrath"] = "Iccba-Nozdormu",
    ["Garrosh"] = "Iccba-Nozdormu",

    ["Pozzodell'Eternità"] = "Iccba-Pozzodell'Eternità",

    ["Quel'Thalas"] = "Iccba-Quel'Thalas",
    ["AzjolNerub"] = "Iccba-Quel'Thalas",

    ["Ragnaros"] = "Iccba-Ragnaros",

    ["Rashgarroth"] = "Iccba-Rashgarroth",
    ["Arakarahm"] = "Iccba-Rashgarroth",
    ["Kael'thas"] = "Iccba-Rashgarroth",
    ["Throk'Feroth"] = "Iccba-Rashgarroth",

    ["Ravencrest"] = "Iccba-Ravencrest",

    ["Sanguino"] = "Iccba-Sanguino",
    ["Zul'jin"] = "Iccba-Sanguino",
    ["Uldum"] = "Iccba-Sanguino",
    ["Shen'dralar"] = "Iccba-Sanguino",

    ["Sargeras"] = "Iccba-Sargeras",
    ["Ner'zhul"] = "Iccba-Sargeras",
    ["Garona"] = "Iccba-Sargeras",

    ["Silvermoon"] = "Iccba-Silvermoon",

    ["Stormrage"] = "Iccba-Stormrage",
    ["Azuremyst"] = "Iccba-Stormrage",

    ["Stormreaver"] = "Iccba-Stormreaver",
    ["Vashj"] = "Iccba-Stormreaver",
    ["Spinebreaker"] = "Iccba-Stormreaver",
    ["Haomarush"] = "Iccba-Stormreaver",
    ["Dragonmaw"] = "Iccba-Stormreaver",

    ["Stormscale"] = "Iccba-Stormscale",

    ["Sylvanas"] = "Iccba-Sylvanas",
    ["Auchindoun"] = "Iccba-Sylvanas",
    ["Jaedenar"] = "Iccba-Sylvanas",
    ["Dunemaul"] = "Iccba-Sylvanas",

    ["TarrenMill"] = "Iccba-TarrenMill",
    ["Dentarg"] = "Iccba-TarrenMill",   

    ["Thrall"] = "Iccba-Thrall",
    ["Kargath"] = "Iccba-Thrall",
    ["Ambossar"] = "Iccba-Thrall",

    ["TwistingNether"] = "Iccba-TwistingNether",

    ["Tyrande"] = "Iccba-Tyrande",
    ["LosErrantes"] = "Iccba-Tyrande",
    ["ColinasPardas"] = "Iccba-Tyrande",

    ["Vol'jin"] = "Iccba-Vol'jin",
    ["Chantséternels"] = "Iccba-Vol'jin",

    ["Wildhammer"] = "Iccba-Wildhammer",
    ["Thunderhorn"] = "Iccba-Wildhammer",

    ["Ysondre"] = "Iccba-Ysondre",

    ["Zenedar"] = "Iccba-Zenedar",
    ["Darksorrow"] = "Iccba-Zenedar",
    ["Neptulon"] = "Iccba-Zenedar",
    ["Genjuros"] = "Iccba-Zenedar",
    ["Bladefist"] = "Iccba-Zenedar",
    ["Frostwhisper"] = "Iccba-Zenedar", 

    ["Anasterian"] = "DO NOT USE",--ptr
}



--saved vars
local defaultSavedVars = {
    global = {
        getcharEnabled = true,
        copygoldEnabled = false,
        realmDisplayEnabled = true,
        helpDisplayEnabled = true,
    },
}
-- Init db
local db
do
    local dframe = CreateFrame("Frame")
    dframe:RegisterEvent("ADDON_LOADED")
    dframe:SetScript("OnEvent", function(self, event, ...)
        return TT[event](self,...)
    end)
    function TT.ADDON_LOADED(self,addon)
        if addon == "ICCTools" then
            db = LibStub("AceDB-3.0"):New("ICCToolsDB", defaultSavedVars).global
            self:UnregisterEvent("ADDON_LOADED")
        end
    end
end
--slash
SLASH_TOLLSTOOLS1 = "/icctools"
function SlashCmdList.TOLLSTOOLS(cmd, editbox)
    local rqst, arg = strsplit(' ', cmd)
    if rqst == "showchar" then
        db.getcharEnabled = not db.getcharEnabled
    elseif rqst == "showgold" then
        db.copygoldEnabled = not db.copygoldEnabled
    elseif rqst == "showrealm" then
        db.realmDisplayEnabled = not db.realmDisplayEnabled 
    elseif rqst == "showhelp" then
        db.helpDisplayEnabled = not db.helpDisplayEnabled                     
    else
        print("Usage:\n/icctools showchar\n/icctools showgold\n/icctools showrealm\n/icctools showhelp")
        return
    end
    TT:ToggleDisplays()

end


--GBC.mount
local macroName = "MyMount"
local frame = CreateFrame("FRAME")

local guildGold = 0

local updateStuff = function(realm)
    local _,realm = UnitFullName("player")
    if realm then frame.realmString:SetText(realm) end
    local copper = GetMoney()
    local gold = math.floor(copper/100/100)
    frame.b:SetText(gold)

    guildGold = GetGuildBankMoney()
    if guildGold>0 then
        local copper = guildGold
        local gold = math.floor(copper/100/100)
        frame.c:SetText(gold)
    end

    local englishFaction = UnitFactionGroup("player")
    local _,realm = UnitFullName("player")
    local char
    if englishFaction == "Alliance" then
        char = realmToNameAlliance[realm] or ""
    elseif englishFaction == "Horde" then
        char = realmToNameHorde[realm] or ""
    end
    frame.d:SetText(char)

end

StaticPopupDialogs["TOLLSTOOLS_DIALOG"] = {
    text = "Copy Text",
    button2 = OKAY,
    timeout = 10,
    whileDead = true,
    hideOnEscape = true,
    exclusive = true,
    enterClicksFirstButton = true,
    preferredIndex = 3,
    hasEditBox = true
}

local function ShowPopup(text)
    local dialog = StaticPopup_Show("TOLLSTOOLS_DIALOG")
    dialog.editBox:SetScript("OnEscapePressed", function() dialog:Hide() end)
    dialog.editBox:SetScript("OnEnterPressed", function() dialog:Hide() end)
    dialog.editBox:SetScript("OnTabPressed", function() dialog:Hide() end)
    dialog.editBox:SetScript("OnSpacePressed", function() dialog:Hide() end)
    dialog.editBox:SetText(text)
    dialog.editBox:SetFocus()
    dialog.editBox:HighlightText()
end

function TT:ToggleDisplays()
    
        if db.getcharEnabled then
            frame.d:Show()
        else
            frame.d:Hide()
        end

        if db.copygoldEnabled then
            frame.b:Show()
            frame.c:Show()
        else
            frame.b:Hide()
            frame.c:Hide()
        end

        if db.realmDisplayEnabled then
            frame.realmString:Show()
        else
            frame.realmString:Hide()
        end

        if db.helpDisplayEnabled then
            frame.helpString:Show()
        else
            frame.helpString:Hide()
        end

        
end


frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
--copyright gallywixboosting
frame:RegisterEvent("PLAYER_MONEY")
frame:RegisterEvent("GUILDBANKFRAME_OPENED")
frame:SetScript("OnEvent", function(self,event,addon)
    if event == "PLAYER_ENTERING_WORLD" then
        SetCVar("showTutorials",0)
        if not InCombatLockdown() then
            if not GetMacroInfo(macroName) then
                CreateMacro(macroName, "INV_Misc_QuestionMark", "/use [flyable]Obsidian Nightwing\n/use Summon Chauffeur", nil, 1)
            end
            SetBinding("F1","MACRO "..macroName)
        end

        --Realm Display
        local _,realm = UnitFullName("player")
        frame.realmString = frame:CreateFontString("TTrealmName")
        frame.realmString:SetFontObject("GameFontNormalMed3")
        frame.realmString:SetTextColor(1, 1, 1, 1)
        frame.realmString:SetJustifyH("CENTER")
        frame.realmString:SetJustifyV("CENTER")
        --frame.topPanel.Gally.String:SetWidth(600)
        frame.realmString:SetHeight(25)
        frame.realmString:SetText(realm)
        frame.realmString:ClearAllPoints()
        frame.realmString:SetPoint("TOP", UIParent, "TOP", 0, 5)
        frame.realmString:Show()
        frame.realmString:SetScale(3)

        --Help Display
        frame.helpString = frame:CreateFontString("TThelpString")
        frame.helpString:SetFontObject("GameFontNormalMed1")
        frame.helpString:SetTextColor(1, 1, 1, 1)
        frame.helpString:SetJustifyH("CENTER")
        frame.helpString:SetJustifyV("CENTER")
        --frame.topPanelString:SetWidth(600)
        frame.helpString:SetHeight(12)
        frame.helpString:SetText("/icctools for options - click buttons to copy")
        frame.helpString:ClearAllPoints()
        frame.helpString:SetPoint("TOP",frame.realmString,"BOTTOM")
        frame.helpString:Show()
        frame.helpString:SetScale(1)

        --gold box
        frame.b = CreateFrame("Button", "MyButton", frame, "UIPanelButtonTemplate")
        frame.b:SetSize(140 ,22) -- width, height
        frame.b:SetText("Copy Gold")
        frame.b:SetPoint("TOP",frame.helpString,"BOTTOM")
        frame.b:SetScript("OnClick", function()
            local copper = GetMoney()
            local gold = math.floor(copper/100/100)
            ShowPopup(gold)
        end)

        --guild gold box
        frame.c = CreateFrame("Button", "MyButton", frame, "UIPanelButtonTemplate")
        frame.c:SetSize(140 ,22) -- width, height
        frame.c:SetText("Go to Gbank")
        frame.c:SetPoint("TOP",frame.b,"BOTTOM")
        frame.c:SetScript("OnClick", function()
            local copper = guildGold
            if copper>0 then
                local gold = math.floor(copper/100/100)
                ShowPopup(gold)
            end
        end)
        --charname copy box
        frame.d = CreateFrame("Button", "MyButton", frame, "UIPanelButtonTemplate")
        frame.d:SetSize(180 ,22) -- width, height
        frame.d:SetText("Copy CharName")
        frame.d:SetPoint("TOP",frame.c,"BOTTOM")
        frame.d:SetScript("OnClick", function()
            local englishFaction = UnitFactionGroup("player")
            local _,realm = UnitFullName("player")
            local char
            if englishFaction == "Alliance" then
                char = realmToNameAlliance[realm] or ""
            elseif englishFaction == "Horde" then
                char = realmToNameHorde[realm] or ""
            end
            ShowPopup(char)
        end)
        TT:ToggleDisplays()
        updateStuff()
		--anyoblivionfaggotgonnacopythisiwonder
        frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _,realm = UnitFullName("player")
        if realm and frame.realmString then
            updateStuff(realm)
            frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        end
    end

    if event == "PLAYER_MONEY" or event == "GUILDBANKFRAME_OPENED" then
        updateStuff()
    end


end)



