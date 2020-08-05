local AddonName, TT = ...

local realmToNameHorde = {
    --
        ["Aegwynn"] = "TheProHordi-Aegwynn",
    --
        ["AeriePeak"] = "TheProHordi-AeriePeak",
        ["Bronzebeard"] = "TheProHordi-AeriePeak",
    --
        ["Agamaggan"] = "TheProHordi-Agamaggan",
        ["Emeriss"] = "TheProHordi-Agamaggan",
        ["Twilight'sHammer"] = "TheProHordi-Agamaggan",
        ["Bloodscalp"] = "TheProHordi-Agamaggan",
        ["Crushridge"] = "TheProHordi-Agamaggan",
        ["Hakkar"] = "TheProHordi-Agamaggan",
    --
        ["Aggramar"] = "TheProHordi-Aggramar",
        ["Hellscream"] = "TheProHordi-Aggramar",
    --
        ["Alexstrasza"] = "TheProHordi-Alexstrasza",
        ["Nethersturm"] = "TheProHordi-Alexstrasza",
    --
        ["Alleria"] = "TheProHordi-Alleria",
        ["Rexxar"] = "TheProHordi-Alleria",
    --
        ["Alonsus"] = "TheProHordi-Alonsus",
        ["KulTiras"] = "TheProHordi-Alonsus",
        ["Anachronos"] = "TheProHordi-Alonsus",
    --
        ["Aman'thul"] = "TheProHordi-Aman'thul",
    --
        ["Antonidas"] = "TheProHordi-Antonidas",
    --
        ["Anub'arak"] = "TheProHordi-Anub'arak",
        ["Zuluhed"] = "TheProHordi-Anub'arak",
        ["Nazjatar"] = "TheProHordi-Anub'arak",
        ["Dalvengyr"] = "TheProHordi-Anub'arak",
        ["Frostmourne"] = "TheProHordi-Anub'arak",
    --    
        ["Arathi"] = "TheProHordi-Arathi",
        ["Templenoir"] = "TheProHordi-Arathi",
        ["Illidan"] = "TheProHordi-Arathi",
        ["Naxxramas"] = "TheProHordi-Arathi",
    --
        ["Arathor"] = "TheProHordi-Arathor",
        ["Hellfire"] = "TheProHordi-Arathor",
    --
        ["Archimonde"] = "TheProHordi-Archimonde",
    --
        ["Area52"] = "TheProHordi-Area52",
        ["Sen'jin"] = "TheProHordi-Area52",
        ["Un'Goro"] = "TheProHordi-Area52",
    --
        ["ArgentDawn"] = "TheProHordi-ArgentDawn",
    --
        ["Arthas"] = "TheProHordi-Arthas",
        ["Vek'lor"] = "TheProHordi-Arthas",
        ["Kel'Thuzad"] = "TheProHordi-Arthas",
        ["Wrathbringer"] = "TheProHordi-Arthas",
        ["Blutkessel"] = "TheProHordi-Arthas",
    --    
        ["Aszune"] = "TheProHordi-Aszune",
        ["Shadowsong"] = "TheProHordi-Aszune",
    --
        ["Auchindoun"] = "TheProHordi-Auchindoun",
        ["Jaedenar"] = "TheProHordi-Auchindoun",
        ["Dunemaul"] = "TheProHordi-Auchindoun",
    --
        ["Azshara"] = "TheProHordi-Azshara",
        ["Krag'jin"] = "TheProHordi-Azshara",
    --
        ["Baelgun"] = "TheProHordi-Baelgun",
        ["Lothar"] = "TheProHordi-Baelgun",
    --
        ["Balnazzar"] = "TheProHordi-Balnazzar",
        ["Boulderfist"] = "TheProHordi-Balnazzar",
        ["Trollbane"] = "TheProHordi-Balnazzar",
        ["LaughingSkull"] = "TheProHordi-Balnazzar",
        ["Daggerspine"] = "TheProHordi-Balnazzar",
        ["Ahn'Qiraj"] = "TheProHordi-Balnazzar",
        ["Talnivarr"] = "TheProHordi-Balnazzar",
        ["ShatteredHalls"] = "TheProHordi-Balnazzar",
        ["Sunstrider"] = "TheProHordi-Balnazzar",
        ["Chromaggus"] = "TheProHordi-Balnazzar",
    --
        ["Blackhand"] = "TheProHordi-Blackhand",
    --
        ["Blackmoore"] = "TheProHordi-Blackmoore",
    --
        ["Blackrock"] = "TheProHordi-Blackrock",
    --
        ["Blade'sEdge"] = "TheProHordi-Blade'sEdge",
        ["Vek'nilash"] = "TheProHordi-Blade'sEdge",
        ["Eonar"] = "TheProHordi-Blade'sEdge",
    --
        ["Bloodfeather"] = "TheProHordi-Bloodfeather",
        ["BurningSteppes"] = "TheProHordi-Bloodfeather",
        ["ShatteredHand"] = "TheProHordi-Bloodfeather",
        ["Kor'gall"] = "TheProHordi-Bloodfeather",
        ["Executus"] = "TheProHordi-Bloodfeather",
    --
        ["BurningLegion"] = "TheProHordi-BurningLegion",
    --
        ["ChamberofAspects"] = "TheProHordi-ChamberofAspects",
    --
        ["ConseildesOmbres"] = "TheProHordi-ConseildesOmbres",
        ["CultedelaRivenoire"] = "TheProHordi-ConseildesOmbres",
        ["LaCroisadeécarlate"] = "TheProHordi-ConseildesOmbres",
    --
        ["C'Thun"] = "TheProHordi-C'Thun",
    --
        ["Dalaran"] = "TheProHordi-Dalaran",
        ["MarécagedeZangar"] = "TheProHordi-Dalaran",
    --
        ["DarkmoonFaire"] = "TheProHordi-DarkmoonFaire",
        ["EarthenRing"] = "TheProHordi-DarkmoonFaire",
    --
        ["Darksorrow"] = "TheProHordi-Darksorrow",
        ["Neptulon"] = "TheProHordi-Darksorrow",
        ["Genjuros"] = "TheProHordi-Darksorrow",
    --
        ["Darkspear"] = "TheProHordi-Darkspear",
        ["Saurfang"] = "TheProHordi-Darkspear",
        ["Terokkar"] = "TheProHordi-Darkspear",
    --
        ["DasKonsortium"] = "TheProHordi-DasKonsortium",
        ["KultderVerdammten"] = "TheProHordi-DasKonsortium",
        ["DieTodeskrallen"] = "TheProHordi-DasKonsortium",
        ["DieArguswacht"] = "TheProHordi-DasKonsortium",
        ["DerabyssischeRat"] = "TheProHordi-DasKonsortium",
        ["DasSyndikat"] = "TheProHordi-DasKonsortium",
    --
        ["Deathwing"] = "TheProHordi-Deathwing",
        ["TheMaelstrom"] = "TheProHordi-Deathwing",
        ["Lightning'sBlade"] = "TheProHordi-Deathwing",
        ["Karazhan"] = "TheProHordi-Deathwing",
    --
        ["DefiasBrotherhood"] = "TheProHordi-DefiasBrotherhood",
        ["TheVentureCo"] = "TheProHordi-DefiasBrotherhood",
        ["Sporeggar"] = "TheProHordi-DefiasBrotherhood",
        ["ScarshieldLegion"] = "TheProHordi-DefiasBrotherhood",
        ["Ravenholdt"] = "TheProHordi-DefiasBrotherhood",
    --
        ["DerMithrilorden"] = "TheProHordi-DerMithrilorden",
        ["DerRatvonDalaran"] = "TheProHordi-DerMithrilorden",
    --
        ["Destromath"] = "TheProHordi-Destromath",
        ["Nera'thor"] = "TheProHordi-Destromath",
        ["Nefarian"] = "TheProHordi-Destromath",
        ["Mannoroth"] = "TheProHordi-Destromath",
        ["Gorgonnash"] = "TheProHordi-Destromath",
    --
        ["DieAldor"] = "TheProHordi-DieAldor",
    --
        ["DieNachtwache"] = "TheProHordi-DieNachtwache",
        ["Forscherliga"] = "TheProHordi-DieNachtwache",
    --
        ["DieSilberneHand"] = "TheProHordi-DieSilberneHand",
        ["DieewigeWacht"] = "TheProHordi-DieSilberneHand",
    --
        ["Doomhammer"] = "TheProHordi-Doomhammer",
        ["Turalyon"] = "TheProHordi-Doomhammer",
    --
        ["Draenor"] = "TheProHordi-Draenor",
    --
        ["Dragonblight"] = "TheProHordi-Dragonblight",
        ["Ghostlands"] = "TheProHordi-Dragonblight",
    --
        ["Drak'thul"] = "TheProHordi-Drak'thul",
        ["BurningBlade"] = "TheProHordi-Drak'thul",
    --
        ["Drek'Thar"] = "TheProHordi-Drek'Thar",
        ["Uldaman"] = "TheProHordi-Drek'Thar",
    --
        ["DunModr"] = "TheProHordi-DunModr",
    --
        ["DunMorogh"] = "TheProHordi-DunMorogh",
        ["Norgannon"] = "TheProHordi-DunMorogh",
    --
        ["Durotan"] = "TheProHordi-Durotan",
        ["Tirion"] = "TheProHordi-Durotan",
    --
        ["Eitrigg"] = "TheProHordi-Eitrigg",
        ["Krasus"] = "TheProHordi-Eitrigg",
    --
        ["Elune"] = "TheProHordiixh-Elune",
        ["Varimathras"] = "TheProHordi-Elune",
    --
        ["EmeraldDream"] = "TheProHordi-EmeraldDream",
        ["Terenas"] = "TheProHordi-EmeraldDream",
    --
        ["Eredar"] = "TheProHordi-Eredar",
    --
        ["Exodar"] = "TheProHordi-Exodar",
        ["Minahonda"] = "TheProHordi-Exodar",
    --
        ["Frostmane"] = "TheProHordi-Frostmane",
    --
        ["Frostwolf"] = "TheProHordi-Frostwolf",
    --
        ["Gilneas"] = "TheProHordi-Gilneas",
        ["Ulduar"] = "TheProHordi-Gilneas",
    --
        ["GrimBatol"] = "TheProHordi-GrimBatol",
        ["Aggra(Português)"] = "TheProHordi-GrimBatol",
    --
        ["Hyjal"] = "TheProHordi-Hyjal",
    --
        ["Kargath"] = "TheProHordi-Kargath",
        ["Ambossar"] = "TheProHordi-Kargath",
    --
        ["Kazzak"] = "TheProHordi-Kazzak",
    --
        ["Khadgar"] = "TheProHordi-Khadgar",
        ["Bloodhoof"] = "TheProHordi-Khadgar",
    --
        ["Khaz'goroth"] = "TheProHordi-Khaz'goroth",
        ["Arygos"] = "TheProHordi-Khaz'goroth",
    --
        ["KhazModan"] = "TheProHordi-KhazModan",
    --
        ["KirinTor"] = "TheProHordi-KirinTor",
    --
        ["LesClairvoyants"] = "TheProHordi-LesClairvoyants",
        ["LesSentinelles"] = "TheProHordi-LesClairvoyants",
        ["ConfrérieduThorium"] = "TheProHordi-LesClairvoyants",
    --
        ["Lightbringer"] = "TheProHordi-Lightbringer",
        ["Mazrigos"] = "TheProHordi-Lightbringer",
    --
        ["Lordaeron"] = "TheProHordi-Lordaeron",
        ["Tichondrius"] = "TheProHordi-Lordaeron",
    --
        ["Madmortem"] = "TheProHordi-Madmortem",
        ["Proudmoore"] = "TheProHordi-Madmortem",
    --
        ["Magtheridon"] = "TheProHordi-Magtheridon",
    --
        ["Malfurion"] = "TheProHordi-Malfurion",
        ["Malygos"] = "TheProHordi-Malfurion",
    --
        ["Mal'Ganis"] = "TheProHordi-Mal'Ganis",
        ["Taerar"] = "TheProHordi-Mal'Ganis",
        ["Echsenkessel"] = "TheProHordi-Mal'Ganis",
    --
        ["Malorne"] = "TheProHordi-Malorne",
        ["Ysera"] = "TheProHordi-Malorne",
    --
        ["Medivh"] = "TheProHordi-Medivh",
        ["Suramar"] = "TheProHordi-Medivh",
    --
        ["Moonglade"] = "TheProHordi-Moonglade",
        ["TheSha'tar"] = "TheProHordi-Moonglade",
        ["SteamwheedleCartel"] = "TheProHordi-Moonglade",
    --
        ["Nagrand"] = "TheProHordi-Nagrand",
        ["Runetotem"] = "TheProHordi-Nagrand",
        ["Kilrogg"] = "TheProHordi-Nagrand",
    --
        ["Nathrezim"] = "TheProHordi-Nathrezim",
        ["Anetheron"] = "TheProHordi-Nathrezim",
        ["FestungderStürme"] = "TheProHordi-Nathrezim",
        ["Gul'dan"] = "TheProHordi-Nathrezim",
        ["Kil'jaeden"] = "TheProHordi-Nathrezim",
        ["Rajaxx"] = "TheProHordi-Nathrezim",
    --
        ["Nemesis"] = "TheProHordi-Nemesis",
    --
        ["Nordrassil"] = "TheProHordi-Nordrassil",
        ["BronzeDragonflight"] = "TheProHordi-Nordrassil",
    --
        ["Nozdormu"] = "TheProHordi-Nozdormu",
        ["Shattrath"] = "TheProHordi-Nozdormu",
        ["Garrosh"] = "TheProHordi-Nozdormu",
    --
        ["Onyxia"] = "TheProHordi-Onyxia",
        ["Terrordar"] = "TheProHordi-Onyxia",
        ["Theradras"] = "TheProHordi-Onyxia",
        ["Mug'thol"] = "TheProHordi-Onyxia",
        ["Dethecus"] = "TheProHordi-Onyxia",
    --
        ["Outland"] = "TheProHordi-Outland",
    --
        ["Perenolde"] = "TheProHordi-Perenolde",
        ["Teldrassil"] = "TheProHordi-Perenolde",
    --
        ["Pozzodell'Eternità"] = "TheProHordi-Pozzodell'Eternità",
    --
        ["Quel'Thalas"] = "TheProHordi-Quel'Thalas",
        ["AzjolNerub"] = "TheProHordi-Quel'Thalas",
    --
        ["Ragnaros"] = "TheProHordi-Ragnaros",
    --
        ["Rashgarroth"] = "TheProHordi-Rashgarroth",
        ["Arakarahm"] = "TheProHordi-Rashgarroth",
        ["Kael'thas"] = "TheProHordi-Rashgarroth",
        ["Throk'Feroth"] = "TheProHordi-Rashgarroth",
    --
        ["Ravencrest"] = "TheProHordi-Ravencrest",
    --
        ["Sanguino"] = "TheProHordi-Sanguino",
        ["Zul'jin"] = "TheProHordi-Sanguino",
        ["Uldum"] = "TheProHordi-Sanguino",
        ["Shen'dralar"] = "TheProHordi-Sanguino",
    --
        ["Sargeras"] = "TheProHordi-Sargeras",
        ["Ner'zhul"] = "TheProHordi-Sargeras",
        ["Garona"] = "TheProHordi-Sargeras",
    --
        ["Silvermoon"] = "TheProHordi-Silvermoon",
    --
        ["Sinstralis"] = "TheProHordi-Sinstralis",
        ["Eldre'Thalas"] = "TheProHordi-Sinstralis",
        ["Cho'gall"] = "TheProHordi-Sinstralis",
    --
        ["Stormrage"] = "TheProHordi-Stormrage",
        ["Azuremyst"] = "TheProHordi-Stormrage",
    --
        ["Stormreaver"] = "TheProHordi-Stormreaver",
        ["Vashj"] = "TheProHordi-Stormreaver",
        ["Spinebreaker"] = "TheProHordi-Stormreaver",
        ["Haomarush"] = "TheProHordi-Stormreaver",
        ["Dragonmaw"] = "TheProHordi-Stormreaver",
    --
        ["Stormscale"] = "TheProHordi-Stormscale",
    --
        ["Sylvanas"] = "TheProHordi-Sylvanas",
    --
        ["TarrenMill"] = "TheProHordi-TarrenMill",
        ["Dentarg"] = "TheProHordi-TarrenMill",   
    --
        ["Thrall"] = "TheProHordi-Thrall",
    --
        ["TwistingNether"] = "TheProHordi-TwistingNether",
    --
        ["Tyrande"] = "TheProHordi-Tyrande",
        ["LosErrantes"] = "TheProHordi-Tyrande",
        ["ColinasPardas"] = "TheProHordi-Tyrande",
    --
        ["Vol'jin"] = "TheProHordi-Vol'jin",
        ["Chantséternels"] = "TheProHordi-Vol'jin",
    --
        ["Wildhammer"] = "TheProHordi-Wildhammer",
        ["Thunderhorn"] = "TheProHordi-Wildhammer",
    --
        ["Xavius"] = "TheProHordi-Xavius",
        ["Al'Akir"] = "TheProHordi-Xavius",
        ["Skullcrusher"] = "TheProHordi-Xavius",
    --
        ["Ysondre"] = "TheProHordi-Ysondre",
    --
        ["Zenedar"] = "TheProHordi-Zenedar",
        ["Bladefist"] = "TheProHordi-Zenedar",
        ["Frostwhisper"] = "TheProHordi-Zenedar",
    --
        ["ZirkeldesCenarius"] = "TheProHordi-ZirkeldesCenarius",
        ["Todeswache"] = "TheProHordi-ZirkeldesCenarius",
    --
        ["Anasterian"] = "CharName-Realm",--ptr
}

local realmToNameAlliance = {
    ["Arathi"] = "Proalibank-Arathi",
    ["Templenoir"] = "Proalibank-Arathi",
    ["Naxxramas"] = "Proalibank-Arathi",
    ["Illidan"] = "Proalibank-Arathi",

    ["Alonsus"] = "Proalibank-Alonsus",
    ["KulTiras"] = "Proalibank-Alonsus",
    ["Anachronos"] = "Proalibank-Alonsus",

    ["Azuremyst"] = "Proalibank-Azuremyst",
    ["Stormrage"] = "Proalibank-Azuremyst",

    ["Auchindoun"] = "Proalibank-Auchindoun",
    ["Jaedenar"] = "Proalibank-Auchindoun",
    ["Dunemaul"] = "Proalibank-Auchindoun",

    ["Balnazzar"] = "Proalibank-Balnazzar",
    ["Trollbane"] = "Proalibank-Balnazzar",
    ["Talnivarr"] = "Proalibank-Balnazzar",
    ["Sunstrider"] = "Proalibank-Balnazzar",
    ["ShatteredHalls"] = "Proalibank-Balnazzar",
    ["LaughingSkull"] = "Proalibank-Balnazzar",
    ["Daggerspine"] = "Proalibank-Balnazzar",
    ["Chromaggus"] = "Proalibank-Balnazzar",
    ["Boulderfist"] = "Proalibank-Balnazzar",
    ["Ahn'Qiraj"] = "Proalibank-Balnazzar",

    ["Bloodfeather"] = "Proalibank-Bloodfeather",
    ["ShatteredHand"] = "Proalibank-Bloodfeather",
    ["Kor'gall"] = "Proalibank-Bloodfeather",
    ["Executus"] = "Proalibank-Bloodfeather",
    ["BurningSteppes"] = "Proalibank-Bloodfeather",

    ["DarkmoonFaire"] = "Proalibank-DarkmoonFaire",
    ["EarthenRing"] = "Proalibank-DarkmoonFaire",

    ["Darksorrow"] = "Proalibank-Darksorrow",
    ["Neptulon"] = "Proalibank-Darksorrow",
    ["Genjuros"] = "Proalibank-Darksorrow",

    ["Dragonblight"] = "Proalibank-Dragonblight",
    ["Ghostlands"] = "Proalibank-Dragonblight",

    ["Darkspear"] = "Proalibank-Darkspear",
    ["Terokkar"] = "Proalibank-Darkspear",
    ["Saurfang"] = "Proalibank-Darkspear",

    ["Deathwing"] = "Proalibank-Deathwing",
    ["TheMaelstrom"] = "Proalibank-Deathwing",
    ["Lightning'sBlade"] = "Proalibank-Deathwing",
    ["Karazhan"] = "Proalibank-Deathwing",

    ["DieAldor"] = "Proalibank-DieAldor",

    ["DunMorogh"] = "Proalibank-DunMorogh",
    ["Norgannon"] = "Proalibank-DunMorogh",

    ["Eredar"] = "Proalibank-Eredar",

    ["Frostwolf"] = "Proalibank-Frostwolf",

    ["Gilneas"] = "Proalibank-Gilneas",
    ["Ulduar"] = "Proalibank-Gilneas",

    ["KhazModan"] = "Proalibank-KhazModan",

    ["Kargath"] = "Proalibank-Kargath",
    ["Ambossar"] = "Proalibank-Kargath",

    ["KirinTor"] = "Proalibank-KirinTor",

    ["Lightbringer"] = "Proalibank-Lightbringer",
    ["Mazrigos"] = "Proalibank-Lightbringer",

    ["LesSentinelles"] = "Proalibank-LesSentinelles",
    ["LesClairvoyants"] = "Proalibank-LesSentinelles",
    ["ConfrérieduThorium"] = "Proalibank-LesSentinelles",

    ["Madmortem"] = "Proalibank-Madmortem",
    ["Proudmoore"] = "Proalibank-Madmortem",

    ["Malfurion"] = "Proalibank-Malfurion",
    ["Malygos"] = "Proalibank-Malfurion",

    ["Mal'Ganis"] = "Proalibank-Mal'Ganis",
    ["Taerar"] = "Proalibank-Mal'Ganis",
    ["Echsenkessel"] = "Proalibank-Mal'Ganis",

    ["Malorne"] = "Proalibank-Malorne",
    ["Ysera"] = "Proalibank-Malorne",

    ["Moonglade"] = "Proalibank-Moonglade",
    ["SteamwheedleCartel"] = "Proalibank-Moonglade",
    ["TheSha'tar"] = "Proalibank-Moonglade",

    ["Nathrezim"] = "Proalibank-Nathrezim",
    ["Rajaxx"] = "Proalibank-Nathrezim",
    ["Kil'jaeden"] = "Proalibank-Nathrezim",
    ["Gul'dan"] = "Proalibank-Nathrezim",
    ["FestungderStürme"] = "Proalibank-Nathrezim",
    ["Anetheron"] = "Proalibank-Nathrezim",

    ["Nemesis"] = "Proalibank-Nemesis",

    ["Onyxia"] = "Proalibank-Onyxia",
    ["Theradras"] = "Proalibank-Onyxia",
    ["Terrordar"] = "Proalibank-Onyxia",
    ["Mug'thol"] = "Proalibank-Onyxia",
    ["Dethecus"] = "Proalibank-Onyxia",

    ["Perenolde"] = "Proalibank-Perenolde",
    ["Teldrassil"] = "Proalibank-Perenolde",

    ["Pozzodell'Eternità"] = "Proalibank-Pozzodell'Eternità",

    ["Sargeras"] = "Proalibank-Sargeras",
    ["Ner'zhul"] = "Proalibank-Sargeras",
    ["Garona"] = "Proalibank-Sargeras",

    ["Tyrande"] = "Proalibank-Tyrande",
    ["LosErrantes"] = "Proalibank-Tyrande",
    ["ColinasPardas"] = "Proalibank-Tyrande",

    ["Vol'jin"] = "Proalibank-Vol'jin",
    ["Chantséternels"] = "Proalibank-Vol'jin",

    ["Xavius"] = "Proalibank-Xavius",
    ["Skullcrusher"] = "Proalibank-Xavius",
    ["Al'Akir"] = "Proalibank-Xavius",

    ["Aegwynn"] = "Proalibank-Aegwynn",

    ["AeriePeak"] = "Proalibank-AeriePeak",
    ["Bronzebeard"] = "Proalibank-AeriePeak",

    ["Agamaggan"] = "Proalibank-Agamaggan",
    ["Twilight'sHammer"] = "Proalibank-Agamaggan",
    ["Hakkar"] = "Proalibank-Agamaggan",
    ["Emeriss"] = "Proalibank-Agamaggan",
    ["Crushridge"] = "Proalibank-Agamaggan",
    ["Bloodscalp"] = "Proalibank-Agamaggan",
    
    ["Aggra(Português)"] = "Proalibank-Aggra(Português)",
    ["GrimBatol"] = "Proalibank-Aggra(Português)",

    ["Alexstrasza"] = "Proalibank-Alexstrasza",
    ["Nethersturm"] = "Proalibank-Alexstrasza",

    ["Alleria"] = "Proalibank-Alleria",
    ["Rexxar"] = "Proalibank-Alleria",

    ["Aman'thul"] = "Proalibank-Aman'thul",

    ["Antonidas"] = "Proalibank-Antonidas",

    ["Anub'arak"] = "Proalibank-Anub'arak",
    ["Zuluhed"] = "Proalibank-Anub'arak",
    ["Nazjatar"] = "Proalibank-Anub'arak",
    ["Frostmourne"] = "Proalibank-Anub'arak",
    ["Dalvengyr"] = "Proalibank-Anub'arak",

    ["Archimonde"] = "Proalibank-Archimonde",

    ["ArgentDawn"] = "Proalibank-ArgentDawn",

    ["Arthas"] = "Proalibank-Arthas",
    ["Vek'lor"] = "Proalibank-Arthas",
    ["Wrathbringer"] = "Proalibank-Arthas",
    ["Kel'Thuzad"] = "Proalibank-Arthas",
    ["Blutkessel"] = "Proalibank-Arthas",

    ["Aszune"] = "Proalibank-Aszune",
    ["Shadowsong"] = "Proalibank-Aszune",

    ["Blackhand"] = "Proalibank-Blackhand",

    ["Blackmoore"] = "Proalibank-Blackmoore",

    ["Blackrock"] = "Proalibank-Blackrock",

    ["Blade'sEdge"] = "Proalibank-Blade'sEdge",
    ["Vek'nilash"] = "Proalibank-Blade'sEdge",
    ["Eonar"] = "Proalibank-Blade'sEdge",

    ["BurningLegion"] = "Proalibank-BurningLegion",

    ["ChamberofAspects"] = "Proalibank-ChamberofAspects",

    ["Dalaran"] = "Proalibank-Dalaran",
    ["MarécagedeZangar"] = "Proalibank-Dalaran",

    ["DefiasBrotherhood"] = "Proalibank-DefiasBrotherhood",
    ["TheVentureCo"] = "Proalibank-DefiasBrotherhood",
    ["Sporeggar"] = "Proalibank-DefiasBrotherhood",
    ["ScarshieldLegion"] = "Proalibank-DefiasBrotherhood",
    ["Ravenholdt"] = "Proalibank-DefiasBrotherhood",

    ["Doomhammer"] = "Proalibank-Doomhammer",
    ["Turalyon"] = "Proalibank-Doomhammer",

    ["Draenor"] = "Proalibank-Draenor",

    ["Drak'thul"] = "Proalibank-Drak'thul",
    ["BurningBlade"] = "Proalibank-Drak'thul",

    ["DunModr"] = "Proalibank-DunModr",

    ["Elune"] = "Proalibank-Elune",
    ["Varimathras"] = "Proalibank-Elune",

    ["EmeraldDream"] = "Proalibank-EmeraldDream",
    ["Terenas"] = "Proalibank-EmeraldDream",

    ["Frostmane"] = "Proalibank-Frostmane",

    ["Frostwhisper"] = "Proalibank-Frostwhisper",
    ["Bladefist"] = "Proalibank-Frostwhisper",
    ["Zenedar"] = "Proalibank-Frostwhisper",

    ["Hellfire"] = "Proalibank-Hellfire",
    ["Arathor"] = "Proalibank-Hellfire",

    ["Hyjal"] = "Proalibank-Hyjal",

    ["Kazzak"] = "Proalibank-Kazzak",

    ["Khadgar"] = "Proalibank-Khadgar",
    ["Bloodhoof"] = "Proalibank-Khadgar",

    ["Magtheridon"] = "Proalibank-Magtheridon",

    ["Nagrand"] = "Proalibank-Nagrand",
    ["Runetotem"] = "Proalibank-Nagrand",
    ["Kilrogg"] = "Proalibank-Nagrand",

    ["Outland"] = "Proalibank-Outland",

    ["Quel'Thalas"] = "Proalibank-Quel'Thalas",
    ["AzjolNerub"] = "Proalibank-Quel'Thalas",

    ["Ragnaros"] = "Proalibank-Ragnaros",

    ["Ravencrest"] = "Proalibank-Ravencrest",

    ["Sanguino"] = "Proalibank-Sanguino",
    ["Zul'jin"] = "Proalibank-Sanguino",
    ["Uldum"] = "Proalibank-Sanguino",
    ["Shen'dralar"] = "Proalibank-Sanguino",

    ["Shattrath"] = "Proalibank-Shattrath",
    ["Nozdormu"] = "Proalibank-Shattrath",
    ["Garrosh"] = "Proalibank-Shattrath",

    ["Silvermoon"] = "Proalibank-Silvermoon",

    ["Stormreaver"] = "Proalibank-Stormreaver",
    ["Vashj"] = "Proalibank-Stormreaver",
    ["Spinebreaker"] = "Proalibank-Stormreaver",
    ["Haomarush"] = "Proalibank-Stormreaver",
    ["Dragonmaw"] = "Proalibank-Stormreaver",

    ["Stormscale"] = "Proalibank-Stormscale",

    ["Sylvanas"] = "Proalibank-Sylvanas",

    ["TarrenMill"] = "Proalibank-TarrenMill",
    ["Dentarg"] = "Proalibank-TarrenMill",

    ["Thrall"] = "Proalibank-Thrall",

    ["TwistingNether"] = "Proalibank-TwistingNether",

    ["Aggramar"] = "NOBANK",    
    ["Arakarahm"] = "NOBANK",
    ["Area52"] = "NOBANK",
    ["Arygos"] = "NOBANK",
    ["Azshara"] = "NOBANK",
    ["Baelgun"] = "NOBANK",
    ["BronzeDragonflight"] = "NOBANK",
    ["C'Thun"] = "NOBANK",
    ["Cho'gall"] = "NOBANK",
    ["ConseildesOmbres"] = "NOBANK",
    ["CultedelaRivenoire"] = "NOBANK",
    ["DasKonsortium"] = "NOBANK",
    ["DasSyndikat"] = "NOBANK",
    ["DerabyssischeRat"] = "NOBANK",
    ["DerMithrilorden"] = "NOBANK",
    ["DerRatvonDalaran"] = "NOBANK",
    ["Destromath"] = "NOBANK",
    ["DieArguswacht"] = "NOBANK",
    ["DieewigeWacht"] = "NOBANK",
    ["DieNachtwache"] = "NOBANK",
    ["DieSilberneHand"] = "NOBANK",
    ["DieTodeskrallen"] = "NOBANK",
    ["Drek'Thar"] = "NOBANK",
    ["Durotan"] = "NOBANK",
    ["Eitrigg"] = "NOBANK",
    ["Eldre'Thalas"] = "NOBANK",
    ["Exodar"] = "NOBANK",
    ["Forscherliga"] = "NOBANK",
    ["Gorgonnash"] = "NOBANK",
    ["Hellscream"] = "NOBANK",
    ["Kael'thas"] = "NOBANK",
    ["Khaz'goroth"] = "NOBANK",
    ["Krag'jin"] = "NOBANK",
    ["Krasus"] = "NOBANK",
    ["KultderVerdammten"] = "NOBANK",
    ["LaCroisadeécarlate"] = "NOBANK",
    ["Lordaeron"] = "NOBANK",
    ["Lothar"] = "NOBANK",
    ["Mannoroth"] = "NOBANK",
    ["Medivh"] = "NOBANK",
    ["Minahonda"] = "NOBANK",
    ["Nefarian"] = "NOBANK",
    ["Nera'thor"] = "NOBANK",
    ["Nordrassil"] = "NOBANK",
    ["Rashgarroth"] = "NOBANK",
    ["Sen'jin"] = "NOBANK",
    ["Sinstralis"] = "NOBANK",
    ["Suramar"] = "NOBANK",
    ["Throk'Feroth"] = "NOBANK",
    ["Thunderhorn"] = "NOBANK",
    ["Tichondrius"] = "NOBANK",
    ["Tirion"] = "NOBANK",
    ["Todeswache"] = "NOBANK",
    ["Uldaman"] = "NOBANK",
    ["Un'Goro"] = "NOBANK",
    ["Wildhammer"] = "NOBANK",
    ["Ysondre"] = "NOBANK",
    ["ZirkeldesCenarius"] = "NOBANK",
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



