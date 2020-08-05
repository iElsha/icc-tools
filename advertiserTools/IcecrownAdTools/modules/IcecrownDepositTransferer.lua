local IcecrownAdTools = LibStub("AceAddon-3.0"):GetAddon("IcecrownAdTools")
local IcecrownDepositTransferer =
    IcecrownAdTools:NewModule(
    "IcecrownDepositTransferer",
    "AceEvent-3.0",
    "AceHook-3.0",
    "AceConsole-3.0",
    "AceTimer-3.0"
)
local StdUi = LibStub("StdUi")

function IcecrownDepositTransferer:OnEnable()
    self:RegisterEvent("MAIL_FAILED", "OnEvent")
    self:RegisterEvent("MAIL_SUCCESS", "OnEvent")
    self.db = IcecrownAdTools.db.global.mail
    self.configDB = IcecrownAdTools.db.char
end

function IcecrownDepositTransferer:OpenPanel()
    -- If we already made all our frames previously, don't make them again.
    if (self.sendWindow == nil) then
        self:DrawWindow()
    else
        self.sendWindow:Show()
    end
end

function IcecrownDepositTransferer:Toggle()
    if not self.sendWindow then
        IcecrownDepositTransferer:OpenPanel()
    elseif self.sendWindow:IsVisible() then
        self.sendWindow:Hide()
    else
        self.sendWindow:Show()
    end
end
function IcecrownDepositTransferer:DrawWindow()
    local sendWindow = StdUi:Window(UIParent, 300, 275, "Transfer Icecrown Deposit")
    sendWindow:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    sendWindow:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())

    sendWindow:SetScript(
        "OnMouseDown",
        function(self)
            self:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
        end
    )

    local playerBox = StdUi:EditBox(sendWindow, 190, 30, nil, nil)
    StdUi:GlueTop(playerBox, sendWindow, 0, -80, "CENTER")
    playerBox:SetFocus()

    if (self.configDB.defaultTransferCharacter ~= nil) then
        playerBox:SetText(self.configDB.defaultTransferCharacter)
    end

    playerBox:SetScript(
        "OnTextChanged",
        function(self)
            return true
        end
    )

    playerBox:SetScript(
        "OnTabPressed",
        function(self)
            if (IcecrownDepositTransferer.sendWindow.serverBox) then
                IcecrownDepositTransferer.sendWindow.serverBox:SetFocus()
            end
        end
    )

    local serverBox = StdUi:EditBox(sendWindow, 190, 30, nil, nil)
    StdUi:GlueBottom(serverBox, playerBox, 0, -50, "CENTER")

    if (self.configDB.defaultTransferServer ~= nil) then
        serverBox:SetText(self.configDB.defaultTransferServer)
    end

    serverBox:SetScript(
        "OnTabPressed",
        function(self)
            if (IcecrownDepositTransferer.sendWindow.goldBox) then
                IcecrownDepositTransferer.sendWindow.goldBox:SetFocus()
            end
        end
    )

    serverBox:SetScript(
        "OnTextChanged",
        function(self)
            return true
        end
    )

    local goldBox = StdUi:NumericBox(sendWindow, 190, 30, nil, nil)
    StdUi:GlueBottom(goldBox, serverBox, 0, -50, "CENTER")

    goldBox:SetScript(
        "OnTextChanged",
        function(self)
            return true
        end
    )

    local sendButton = StdUi:Button(sendWindow, 80, 30, "Send")
    StdUi:GlueBottom(sendButton, sendWindow, 0, 5, "CENTER")
    sendButton:SetScript(
        "OnClick",
        function()
            IcecrownDepositTransferer:Send()
        end
    )

    local logoFrame = StdUi:Frame(sendWindow, 32, 32)
    local logoTexture = StdUi:Texture(logoFrame, 32, 32, [=[Interface\Addons\IcecrownAdTools\media\Icecrown32.tga]=])

    StdUi:GlueTop(logoTexture, logoFrame, 0, 0, "CENTER")
    StdUi:GlueBottom(logoFrame, sendWindow, -10, 10, "RIGHT")

    local player
    local region = GetCurrentRegion()
    local _, server = UnitFullName("player")
    local faction = UnitFactionGroup("player")
    if (faction == "Alliance") then
        player = IcecrownDepositTransferer.allianceMailTargets[region][server]
    else
        player = IcecrownDepositTransferer.hordeMailTargets[region][server]
    end

    if (player) then
        local sendString = StdUi:FontString(sendWindow, "Sending mail to: " .. player)
        StdUi:GlueTop(sendString, sendWindow, 0, -30, "CENTER")
    else
        local sendString = StdUi:FontString(sendWindow, "No valid mail target found!")
        StdUi:GlueTop(sendString, sendWindow, 0, -30, "CENTER")
    end

    local playerString = StdUi:FontString(sendWindow, "Character to transfer balance to:")
    StdUi:GlueTop(playerString, playerBox, 0, 15, "CENTER")

    local serverString = StdUi:FontString(sendWindow, "Server that character is on:")
    StdUi:GlueTop(serverString, serverBox, 0, 15, "CENTER")

    local goldString = StdUi:FontString(sendWindow, "Gold to add transfer:")
    StdUi:GlueTop(goldString, goldBox, 0, 15, "CENTER")

    self.sendWindow = sendWindow
    self.sendWindow.sendButton = sendButton
    self.sendWindow.playerBox = playerBox
    self.sendWindow.serverBox = serverBox
    self.sendWindow.goldBox = goldBox
    self.player = player

    self.sendWindow:Show()
end

function IcecrownDepositTransferer:Send()
    local unformattedGold = self.sendWindow.goldBox:GetText()
    local playerToAddBalance = self.sendWindow.playerBox:GetText()
    local serverToAddBalance = self.sendWindow.serverBox:GetText()
    if (unformattedGold ~= nil and playerToAddBalance ~= nil and serverToAddBalance ~= nil and self.player ~= nil) then
        local numberGold = tonumber(unformattedGold)
        if (numberGold) then
            local formattedGold = numberGold * 10000
            if (IcecrownDepositTransferer:HasEnoughGold(formattedGold)) then
                local subject = "Icecrown Deposit Transfer"
                local body = playerToAddBalance .. "-" .. serverToAddBalance
                SetSendMailMoney(formattedGold)
                SendMail(self.player, subject, body)
                self.configDB.defaultTransferCharacter = playerToAddBalance
                self.configDB.defaultTransferServer = serverToAddBalance
                self.pendingMail = {gold = unformattedGold, target = self.player}
                self.expectingMailEvent = true
            else
                print("|CFFFF0000[IcecrownDepositTransferer]: Not enough gold.")
                print("|CFFFF0000[IcecrownDepositTransferer]: Couldn't send a valid deposit.")
                IcecrownDepositTransferer:Finish()
            end
        else
            print("|CFFFF0000[IcecrownDepositTransferer]: Couldn't send a valid deposit.")
            IcecrownDepositTransferer:Finish()
        end
    else
        print("|CFFFF0000[IcecrownDepositTransferer]: Couldn't send a valid deposit.")
        IcecrownDepositTransferer:Finish()
    end
end

function IcecrownDepositTransferer:OnEvent(event, ...)
    if (event == "MAIL_SUCCESS" and self.expectingMailEvent) then
        print(
            "|CFF00FF00[IcecrownDepositTransferer]: Sent " ..
                self.pendingMail.gold .. " gold to " .. self.pendingMail.target
        )
        wipe(self.pendingMail)
        self.expectingMailEvent = false
        IcecrownDepositTransferer:Finish()
    elseif (event == "MAIL_FAILED" and self.expectingMailEvent) then
        wipe(self.pendingMail)
        self.expectingMailEvent = false
        IcecrownDepositTransferer:Finish()
    end
end

function IcecrownDepositTransferer:HasEnoughGold(gold)
    return (GetMoney() > gold)
end

function IcecrownDepositTransferer:Finish()
    print("|CFF00FF00[IcecrownDepositTransferer]: Done!")
    if (self.sendWindow and self.sendWindow.playerBox and self.sendWindow.serverBox and self.sendWindow.goldBox) then
        self.sendWindow.goldBox:SetText("")
        self.sendWindow:Hide()
    end
end

IcecrownDepositTransferer.hordeMailTargets = {
    -- NA
    [1]={
        ["aegwynn"]="CharName-Realm",
    },
    -- EU
    [3] = {
        --
        ["Aegwynn"]="TheProHordi-Aegwynn",
        --
        ["AeriePeak"]="TheProHordi-AeriePeak",
        ["Bronzebeard"]="TheProHordi-AeriePeak",
        --
        ["Agamaggan"]="TheProHordi-Agamaggan",
        ["Emeriss"]="TheProHordi-Agamaggan",
        ["Twilight'sHammer"]="TheProHordi-Agamaggan",
        ["Bloodscalp"]="TheProHordi-Agamaggan",
        ["Crushridge"]="TheProHordi-Agamaggan",
        ["Hakkar"]="TheProHordi-Agamaggan",
        --
        ["Aggramar"]="TheProHordi-Aggramar",
        ["Hellscream"]="TheProHordi-Aggramar",
        --
        ["Alexstrasza"]="TheProHordi-Alexstrasza",
        ["Nethersturm"]="TheProHordi-Alexstrasza",
        --
        ["Alleria"]="TheProHordi-Alleria",
        ["Rexxar"]="TheProHordi-Alleria",
        --
        ["Alonsus"]="TheProHordi-Alonsus",
        ["KulTiras"]="TheProHordi-Alonsus",
        ["Anachronos"]="TheProHordi-Alonsus",
        --
        ["Aman'thul"]="TheProHordi-Aman'thul",
        --
        ["Antonidas"]="TheProHordi-Antonidas",
        --
        ["Anub'arak"]="TheProHordi-Anub'arak",
        ["Zuluhed"]="TheProHordi-Anub'arak",
        ["Nazjatar"]="TheProHordi-Anub'arak",
        ["Dalvengyr"]="TheProHordi-Anub'arak",
        ["Frostmourne"]="TheProHordi-Anub'arak",
        --
        ["Arathi"]="TheProHordi-Arathi",
        ["Templenoir"]="TheProHordi-Arathi",
        ["Illidan"]="TheProHordi-Arathi",
        ["Naxxramas"]="TheProHordi-Arathi",
        --
        ["Arathor"]="TheProHordi-Arathor",
        ["Hellfire"]="TheProHordi-Arathor",
        --
        ["Archimonde"]="TheProHordi-Archimonde",
        --
        ["Area52"]="TheProHordi-Area52",
        ["Sen'jin"]="TheProHordi-Area52",
        ["Un'Goro"]="TheProHordi-Area52",
        --
        ["ArgentDawn"]="TheProHordi-ArgentDawn",
        --
        ["Arthas"]="TheProHordi-Arthas",
        ["Vek'lor"]="TheProHordi-Arthas",
        ["Kel'Thuzad"]="TheProHordi-Arthas",
        ["Wrathbringer"]="TheProHordi-Arthas",
        ["Blutkessel"]="TheProHordi-Arthas",
        --
        ["Aszune"]="TheProHordi-Aszune",
        ["Shadowsong"]="TheProHordi-Aszune",
        --
        ["Auchindoun"]="TheProHordi-Auchindoun",
        ["Jaedenar"]="TheProHordi-Auchindoun",
        ["Dunemaul"]="TheProHordi-Auchindoun",
        --
        ["Azshara"]="TheProHordi-Azshara",
        ["Krag'jin"]="TheProHordi-Azshara",
        --
        ["Baelgun"]="TheProHordi-Baelgun",
        ["Lothar"]="TheProHordi-Baelgun",
        --
        ["Balnazzar"]="TheProHordi-Balnazzar",
        ["Boulderfist"]="TheProHordi-Balnazzar",
        ["Trollbane"]="TheProHordi-Balnazzar",
        ["LaughingSkull"]="TheProHordi-Balnazzar",
        ["Daggerspine"]="TheProHordi-Balnazzar",
        ["Ahn'Qiraj"]="TheProHordi-Balnazzar",
        ["Talnivarr"]="TheProHordi-Balnazzar",
        ["ShatteredHalls"]="TheProHordi-Balnazzar",
        ["Sunstrider"]="TheProHordi-Balnazzar",
        ["Chromaggus"]="TheProHordi-Balnazzar",
        --
        ["Blackhand"]="TheProHordi-Blackhand",
        --
        ["Blackmoore"]="TheProHordi-Blackmoore",
        --
        ["Blackrock"]="TheProHordi-Blackrock",
        --
        ["Blade'sEdge"]="TheProHordi-Blade'sEdge",
        ["Vek'nilash"]="TheProHordi-Blade'sEdge",
        ["Eonar"]="TheProHordi-Blade'sEdge",
        --
        ["Bloodfeather"]="TheProHordi-Bloodfeather",
        ["BurningSteppes"]="TheProHordi-Bloodfeather",
        ["ShatteredHand"]="TheProHordi-Bloodfeather",
        ["Kor'gall"]="TheProHordi-Bloodfeather",
        ["Executus"]="TheProHordi-Bloodfeather",
        --
        ["BurningLegion"]="TheProHordi-BurningLegion",
        --
        ["ChamberofAspects"]="TheProHordi-ChamberofAspects",
        --
        ["ConseildesOmbres"]="TheProHordi-ConseildesOmbres",
        ["CultedelaRivenoire"]="TheProHordi-ConseildesOmbres",
        ["LaCroisadeécarlate"]="TheProHordi-ConseildesOmbres",
        --
        ["C'Thun"]="TheProHordi-C'Thun",
        --
        ["Dalaran"]="TheProHordi-Dalaran",
        ["MarécagedeZangar"]="TheProHordi-Dalaran",
        --
        ["DarkmoonFaire"]="TheProHordi-DarkmoonFaire",
        ["EarthenRing"]="TheProHordi-DarkmoonFaire",
        --
        ["Darksorrow"]="TheProHordi-Darksorrow",
        ["Neptulon"]="TheProHordi-Darksorrow",
        ["Genjuros"]="TheProHordi-Darksorrow",
        --
        ["Darkspear"]="TheProHordi-Darkspear",
        ["Saurfang"]="TheProHordi-Darkspear",
        ["Terokkar"]="TheProHordi-Darkspear",
        --
        ["DasKonsortium"]="TheProHordi-DasKonsortium",
        ["KultderVerdammten"]="TheProHordi-DasKonsortium",
        ["DieTodeskrallen"]="TheProHordi-DasKonsortium",
        ["DieArguswacht"]="TheProHordi-DasKonsortium",
        ["DerabyssischeRat"]="TheProHordi-DasKonsortium",
        ["DasSyndikat"]="TheProHordi-DasKonsortium",
        --
        ["Deathwing"]="TheProHordi-Deathwing",
        ["TheMaelstrom"]="TheProHordi-Deathwing",
        ["Lightning'sBlade"]="TheProHordi-Deathwing",
        ["Karazhan"]="TheProHordi-Deathwing",
        --
        ["DefiasBrotherhood"]="TheProHordi-DefiasBrotherhood",
        ["TheVentureCo"]="TheProHordi-DefiasBrotherhood",
        ["Sporeggar"]="TheProHordi-DefiasBrotherhood",
        ["ScarshieldLegion"]="TheProHordi-DefiasBrotherhood",
        ["Ravenholdt"]="TheProHordi-DefiasBrotherhood",
        --
        ["DerMithrilorden"]="TheProHordi-DerMithrilorden",
        ["DerRatvonDalaran"]="TheProHordi-DerMithrilorden",
        --
        ["Destromath"]="TheProHordi-Destromath",
        ["Nera'thor"]="TheProHordi-Destromath",
        ["Nefarian"]="TheProHordi-Destromath",
        ["Mannoroth"]="TheProHordi-Destromath",
        ["Gorgonnash"]="TheProHordi-Destromath",
        --
        ["DieAldor"]="TheProHordi-DieAldor",
        --
        ["DieNachtwache"]="TheProHordi-DieNachtwache",
        ["Forscherliga"]="TheProHordi-DieNachtwache",
        --
        ["DieSilberneHand"]="TheProHordi-DieSilberneHand",
        ["DieewigeWacht"]="TheProHordi-DieSilberneHand",
        --
        ["Doomhammer"]="TheProHordi-Doomhammer",
        ["Turalyon"]="TheProHordi-Doomhammer",
        --
        ["Draenor"]="TheProHordi-Draenor",
        --
        ["Dragonblight"]="TheProHordi-Dragonblight",
        ["Ghostlands"]="TheProHordi-Dragonblight",
        --
        ["Drak'thul"]="TheProHordi-Drak'thul",
        ["BurningBlade"]="TheProHordi-Drak'thul",
        --
        ["Drek'Thar"]="TheProHordi-Drek'Thar",
        ["Uldaman"]="TheProHordi-Drek'Thar",
        --
        ["DunModr"]="TheProHordi-DunModr",
        --
        ["DunMorogh"]="TheProHordi-DunMorogh",
        ["Norgannon"]="TheProHordi-DunMorogh",
        --
        ["Durotan"]="TheProHordi-Durotan",
        ["Tirion"]="TheProHordi-Durotan",
        --
        ["Eitrigg"]="TheProHordi-Eitrigg",
        ["Krasus"]="TheProHordi-Eitrigg",
        --
        ["Elune"]="TheProHordiixh-Elune",
        ["Varimathras"]="TheProHordi-Elune",
        --
        ["EmeraldDream"]="TheProHordi-EmeraldDream",
        ["Terenas"]="TheProHordi-EmeraldDream",
        --
        ["Eredar"]="TheProHordi-Eredar",
        --
        ["Exodar"]="TheProHordi-Exodar",
        ["Minahonda"]="TheProHordi-Exodar",
        --
        ["Frostmane"]="TheProHordi-Frostmane",
        --
        ["Frostwolf"]="TheProHordi-Frostwolf",
        --
        ["Gilneas"]="TheProHordi-Gilneas",
        ["Ulduar"]="TheProHordi-Gilneas",
        --
        ["GrimBatol"]="TheProHordi-GrimBatol",
        ["Aggra(Português)"]="TheProHordi-GrimBatol",
        --
        ["Hyjal"]="TheProHordi-Hyjal",
        --
        ["Kargath"]="TheProHordi-Kargath",
        ["Ambossar"]="TheProHordi-Kargath",
        --
        ["Kazzak"]="TheProHordi-Kazzak",
        --
        ["Khadgar"]="TheProHordi-Khadgar",
        ["Bloodhoof"]="TheProHordi-Khadgar",
        --
        ["Khaz'goroth"]="TheProHordi-Khaz'goroth",
        ["Arygos"]="TheProHordi-Khaz'goroth",
        --
        ["KhazModan"]="TheProHordi-KhazModan",
        --
        ["KirinTor"]="TheProHordi-KirinTor",
        --
        ["LesClairvoyants"]="TheProHordi-LesClairvoyants",
        ["LesSentinelles"]="TheProHordi-LesClairvoyants",
        ["ConfrérieduThorium"]="TheProHordi-LesClairvoyants",
        --
        ["Lightbringer"]="TheProHordi-Lightbringer",
        ["Mazrigos"]="TheProHordi-Lightbringer",
        --
        ["Lordaeron"]="TheProHordi-Lordaeron",
        ["Tichondrius"]="TheProHordi-Lordaeron",
        --
        ["Madmortem"]="TheProHordi-Madmortem",
        ["Proudmoore"]="TheProHordi-Madmortem",
        --
        ["Magtheridon"]="TheProHordi-Magtheridon",
        --
        ["Malfurion"]="TheProHordi-Malfurion",
        ["Malygos"]="TheProHordi-Malfurion",
        --
        ["Mal'Ganis"]="TheProHordi-Mal'Ganis",
        ["Taerar"]="TheProHordi-Mal'Ganis",
        ["Echsenkessel"]="TheProHordi-Mal'Ganis",
        --
        ["Malorne"]="TheProHordi-Malorne",
        ["Ysera"]="TheProHordi-Malorne",
        --
        ["Medivh"]="TheProHordi-Medivh",
        ["Suramar"]="TheProHordi-Medivh",
        --
        ["Moonglade"]="TheProHordi-Moonglade",
        ["TheSha'tar"]="TheProHordi-Moonglade",
        ["SteamwheedleCartel"]="TheProHordi-Moonglade",
        --
        ["Nagrand"]="TheProHordi-Nagrand",
        ["Runetotem"]="TheProHordi-Nagrand",
        ["Kilrogg"]="TheProHordi-Nagrand",
        --
        ["Nathrezim"]="TheProHordi-Nathrezim",
        ["Anetheron"]="TheProHordi-Nathrezim",
        ["FestungderStürme"]="TheProHordi-Nathrezim",
        ["Gul'dan"]="TheProHordi-Nathrezim",
        ["Kil'jaeden"]="TheProHordi-Nathrezim",
        ["Rajaxx"]="TheProHordi-Nathrezim",
        --
        ["Nemesis"]="TheProHordi-Nemesis",
        --
        ["Nordrassil"]="TheProHordi-Nordrassil",
        ["BronzeDragonflight"]="TheProHordi-Nordrassil",
        --
        ["Nozdormu"]="TheProHordi-Nozdormu",
        ["Shattrath"]="TheProHordi-Nozdormu",
        ["Garrosh"]="TheProHordi-Nozdormu",
        --
        ["Onyxia"]="TheProHordi-Onyxia",
        ["Terrordar"]="TheProHordi-Onyxia",
        ["Theradras"]="TheProHordi-Onyxia",
        ["Mug'thol"]="TheProHordi-Onyxia",
        ["Dethecus"]="TheProHordi-Onyxia",
        --
        ["Outland"]="TheProHordi-Outland",
        --
        ["Perenolde"]="TheProHordi-Perenolde",
        ["Teldrassil"]="TheProHordi-Perenolde",
        --
        ["Pozzodell'Eternità"]="TheProHordi-Pozzodell'Eternità",
        --
        ["Quel'Thalas"]="TheProHordi-Quel'Thalas",
        ["AzjolNerub"]="TheProHordi-Quel'Thalas",
        --
        ["Ragnaros"]="TheProHordi-Ragnaros",
        --
        ["Rashgarroth"]="TheProHordi-Rashgarroth",
        ["Arakarahm"]="TheProHordi-Rashgarroth",
        ["Kael'thas"]="TheProHordi-Rashgarroth",
        ["Throk'Feroth"]="TheProHordi-Rashgarroth",
        --
        ["Ravencrest"]="TheProHordi-Ravencrest",
        --
        ["Sanguino"]="TheProHordi-Sanguino",
        ["Zul'jin"]="TheProHordi-Sanguino",
        ["Uldum"]="TheProHordi-Sanguino",
        ["Shen'dralar"]="TheProHordi-Sanguino",
        --
        ["Sargeras"]="TheProHordi-Sargeras",
        ["Ner'zhul"]="TheProHordi-Sargeras",
        ["Garona"]="TheProHordi-Sargeras",
        --
        ["Silvermoon"]="TheProHordi-Silvermoon",
        --
        ["Sinstralis"]="TheProHordi-Sinstralis",
        ["Eldre'Thalas"]="TheProHordi-Sinstralis",
        ["Cho'gall"]="TheProHordi-Sinstralis",
        --
        ["Stormrage"]="TheProHordi-Stormrage",
        ["Azuremyst"]="TheProHordi-Stormrage",
        --
        ["Stormreaver"]="TheProHordi-Stormreaver",
        ["Vashj"]="TheProHordi-Stormreaver",
        ["Spinebreaker"]="TheProHordi-Stormreaver",
        ["Haomarush"]="TheProHordi-Stormreaver",
        ["Dragonmaw"]="TheProHordi-Stormreaver",
        --
        ["Stormscale"]="TheProHordi-Stormscale",
        --
        ["Sylvanas"]="TheProHordi-Sylvanas",
        --
        ["TarrenMill"]="TheProHordi-TarrenMill",
        ["Dentarg"]="TheProHordi-TarrenMill",
        --
        ["Thrall"]="TheProHordi-Thrall",
        --
        ["TwistingNether"]="TheProHordi-TwistingNether",
        --
        ["Tyrande"]="TheProHordi-Tyrande",
        ["LosErrantes"]="TheProHordi-Tyrande",
        ["ColinasPardas"]="TheProHordi-Tyrande",
        --
        ["Vol'jin"]="TheProHordi-Vol'jin",
        ["Chantséternels"]="TheProHordi-Vol'jin",
        --
        ["Wildhammer"]="TheProHordi-Wildhammer",
        ["Thunderhorn"]="TheProHordi-Wildhammer",
        --
        ["Xavius"]="TheProHordi-Xavius",
        ["Al'Akir"]="TheProHordi-Xavius",
        ["Skullcrusher"]="TheProHordi-Xavius",
        --
        ["Ysondre"]="TheProHordi-Ysondre",
        --
        ["Zenedar"]="TheProHordi-Zenedar",
        ["Bladefist"]="TheProHordi-Zenedar",
        ["Frostwhisper"]="TheProHordi-Zenedar",
        --
        ["ZirkeldesCenarius"]="TheProHordi-ZirkeldesCenarius",
        ["Todeswache"]="TheProHordi-ZirkeldesCenarius",
        --
        ["Anasterian"]="CharName-Realm",--ptr
    }
}

IcecrownDepositTransferer.allianceMailTargets = {
    [1] = {
        ["aegwynn"] = "CharName-Realm",
    },
    [3] = {
        ["Arathi"]="Proalibank-Arathi",
        ["Templenoir"]="Proalibank-Arathi",
        ["Naxxramas"]="Proalibank-Arathi",
        ["Illidan"]="Proalibank-Arathi",
        --
        ["Alonsus"]="Proalibank-Alonsus",
        ["KulTiras"]="Proalibank-Alonsus",
        ["Anachronos"]="Proalibank-Alonsus",
        --
        ["Azuremyst"]="Proalibank-Azuremyst",
        ["Stormrage"]="Proalibank-Azuremyst",
        --
        ["Auchindoun"]="Proalibank-Auchindoun",
        ["Jaedenar"]="Proalibank-Auchindoun",
        ["Dunemaul"]="Proalibank-Auchindoun",
        --
        ["Balnazzar"]="Proalibank-Balnazzar",
        ["Trollbane"]="Proalibank-Balnazzar",
        ["Talnivarr"]="Proalibank-Balnazzar",
        ["Sunstrider"]="Proalibank-Balnazzar",
        ["ShatteredHalls"]="Proalibank-Balnazzar",
        ["LaughingSkull"]="Proalibank-Balnazzar",
        ["Daggerspine"]="Proalibank-Balnazzar",
        ["Chromaggus"]="Proalibank-Balnazzar",
        ["Boulderfist"]="Proalibank-Balnazzar",
        ["Ahn'Qiraj"]="Proalibank-Balnazzar",
        --
        ["Bloodfeather"]="Proalibank-Bloodfeather",
        ["ShatteredHand"]="Proalibank-Bloodfeather",
        ["Kor'gall"]="Proalibank-Bloodfeather",
        ["Executus"]="Proalibank-Bloodfeather",
        ["BurningSteppes"]="Proalibank-Bloodfeather",
        --
        ["DarkmoonFaire"]="Proalibank-DarkmoonFaire",
        ["EarthenRing"]="Proalibank-DarkmoonFaire",
        ["Darksorrow"]="Proalibank-Darksorrow",
        ["Neptulon"]="Proalibank-Darksorrow",
        ["Genjuros"]="Proalibank-Darksorrow",
        --
        ["Dragonblight"]="Proalibank-Dragonblight",
        ["Ghostlands"]="Proalibank-Dragonblight",
        ["Darkspear"]="Proalibank-Darkspear",
        ["Terokkar"]="Proalibank-Darkspear",
        ["Saurfang"]="Proalibank-Darkspear",
        ["Deathwing"]="Proalibank-Deathwing",
        ["TheMaelstrom"]="Proalibank-Deathwing",
        ["Lightning'sBlade"]="Proalibank-Deathwing",
        ["Karazhan"]="Proalibank-Deathwing",
        ["DieAldor"]="Proalibank-DieAldor",
        ["DunMorogh"]="Proalibank-DunMorogh",
        ["Norgannon"]="Proalibank-DunMorogh",
        ["Eredar"]="Proalibank-Eredar",
        ["Frostwolf"]="Proalibank-Frostwolf",
        ["Gilneas"]="Proalibank-Gilneas",
        ["Ulduar"]="Proalibank-Gilneas",
        ["KhazModan"]="Proalibank-KhazModan",
        ["Kargath"]="Proalibank-Kargath",
        ["Ambossar"]="Proalibank-Kargath",
        ["KirinTor"]="Proalibank-KirinTor",
        ["Lightbringer"]="Proalibank-Lightbringer",
        ["Mazrigos"]="Proalibank-Lightbringer",
        ["LesSentinelles"]="Proalibank-LesSentinelles",
        ["LesClairvoyants"]="Proalibank-LesSentinelles",
        ["ConfrérieduThorium"]="Proalibank-LesSentinelles",
        ["Madmortem"]="Proalibank-Madmortem",
        ["Proudmoore"]="Proalibank-Madmortem",
        ["Malfurion"]="Proalibank-Malfurion",
        ["Malygos"]="Proalibank-Malfurion",
        ["Mal'Ganis"]="Proalibank-Mal'Ganis",
        ["Taerar"]="Proalibank-Mal'Ganis",
        ["Echsenkessel"]="Proalibank-Mal'Ganis",
        ["Malorne"]="Proalibank-Malorne",
        ["Ysera"]="Proalibank-Malorne",
        ["Moonglade"]="Proalibank-Moonglade",
        ["SteamwheedleCartel"]="Proalibank-Moonglade",
        ["TheSha'tar"]="Proalibank-Moonglade",
        ["Nathrezim"]="Proalibank-Nathrezim",
        ["Rajaxx"]="Proalibank-Nathrezim",
        ["Kil'jaeden"]="Proalibank-Nathrezim",
        ["Gul'dan"]="Proalibank-Nathrezim",
        ["FestungderStürme"]="Proalibank-Nathrezim",
        ["Anetheron"]="Proalibank-Nathrezim",
        ["Nemesis"]="Proalibank-Nemesis",
        ["Onyxia"]="Proalibank-Onyxia",
        ["Theradras"]="Proalibank-Onyxia",
        ["Terrordar"]="Proalibank-Onyxia",
        ["Mug'thol"]="Proalibank-Onyxia",
        ["Dethecus"]="Proalibank-Onyxia",
        ["Perenolde"]="Proalibank-Perenolde",
        ["Teldrassil"]="Proalibank-Perenolde",
        ["Pozzodell'Eternità"]="Proalibank-Pozzodell'Eternità",
        ["Sargeras"]="Proalibank-Sargeras",
        ["Ner'zhul"]="Proalibank-Sargeras",
        ["Garona"]="Proalibank-Sargeras",
        ["Tyrande"]="Proalibank-Tyrande",
        ["LosErrantes"]="Proalibank-Tyrande",
        ["ColinasPardas"]="Proalibank-Tyrande",
        ["Vol'jin"]="Proalibank-Vol'jin",
        ["Chantséternels"]="Proalibank-Vol'jin",
        ["Xavius"]="Proalibank-Xavius",
        ["Skullcrusher"]="Proalibank-Xavius",
        ["Al'Akir"]="Proalibank-Xavius",
        ["Aegwynn"]="Proalibank-Aegwynn",
        ["AeriePeak"]="Proalibank-AeriePeak",
        ["Bronzebeard"]="Proalibank-AeriePeak",
        ["Agamaggan"]="Proalibank-Agamaggan",
        ["Twilight'sHammer"]="Proalibank-Agamaggan",
        ["Hakkar"]="Proalibank-Agamaggan",
        ["Emeriss"]="Proalibank-Agamaggan",
        ["Crushridge"]="Proalibank-Agamaggan",
        ["Bloodscalp"]="Proalibank-Agamaggan",
        ["Aggra(Português)"]="Proalibank-Aggra(Português)",
        ["GrimBatol"]="Proalibank-Aggra(Português)",
        ["Alexstrasza"]="Proalibank-Alexstrasza",
        ["Nethersturm"]="Proalibank-Alexstrasza",
        ["Alleria"]="Proalibank-Alleria",
        ["Rexxar"]="Proalibank-Alleria",
        ["Aman'thul"]="Proalibank-Aman'thul",
        ["Antonidas"]="Proalibank-Antonidas",
        ["Anub'arak"]="Proalibank-Anub'arak",
        ["Zuluhed"]="Proalibank-Anub'arak",
        ["Nazjatar"]="Proalibank-Anub'arak",
        ["Frostmourne"]="Proalibank-Anub'arak",
        ["Dalvengyr"]="Proalibank-Anub'arak",
        ["Archimonde"]="Proalibank-Archimonde",
        ["ArgentDawn"]="Proalibank-ArgentDawn",
        ["Arthas"]="Proalibank-Arthas",
        ["Vek'lor"]="Proalibank-Arthas",
        ["Wrathbringer"]="Proalibank-Arthas",
        ["Kel'Thuzad"]="Proalibank-Arthas",
        ["Blutkessel"]="Proalibank-Arthas",
        ["Aszune"]="Proalibank-Aszune",
        ["Shadowsong"]="Proalibank-Aszune",
        ["Blackhand"]="Proalibank-Blackhand",
        ["Blackmoore"]="Proalibank-Blackmoore",
        ["Blackrock"]="Proalibank-Blackrock",
        ["Blade'sEdge"]="Proalibank-Blade'sEdge",
        ["Vek'nilash"]="Proalibank-Blade'sEdge",
        ["Eonar"]="Proalibank-Blade'sEdge",
        ["BurningLegion"]="Proalibank-BurningLegion",
        ["ChamberofAspects"]="Proalibank-ChamberofAspects",
        ["Dalaran"]="Proalibank-Dalaran",
        ["MarécagedeZangar"]="Proalibank-Dalaran",
        ["DefiasBrotherhood"]="Proalibank-DefiasBrotherhood",
        ["TheVentureCo"]="Proalibank-DefiasBrotherhood",
        ["Sporeggar"]="Proalibank-DefiasBrotherhood",
        ["ScarshieldLegion"]="Proalibank-DefiasBrotherhood",
        ["Ravenholdt"]="Proalibank-DefiasBrotherhood",
        ["Doomhammer"]="Proalibank-Doomhammer",
        ["Turalyon"]="Proalibank-Doomhammer",
        ["Draenor"]="Proalibank-Draenor",
        ["Drak'thul"]="Proalibank-Drak'thul",
        ["BurningBlade"]="Proalibank-Drak'thul",
        ["DunModr"]="Proalibank-DunModr",
        ["Elune"]="Proalibank-Elune",
        ["Varimathras"]="Proalibank-Elune",
        ["EmeraldDream"]="Proalibank-EmeraldDream",
        ["Terenas"]="Proalibank-EmeraldDream",
        ["Frostmane"]="Proalibank-Frostmane",
        ["Frostwhisper"]="Proalibank-Frostwhisper",
        ["Bladefist"]="Proalibank-Frostwhisper",
        ["Zenedar"]="Proalibank-Frostwhisper",
        ["Hellfire"]="Proalibank-Hellfire",
        ["Arathor"]="Proalibank-Hellfire",
        ["Hyjal"]="Proalibank-Hyjal",
        ["Kazzak"]="Proalibank-Kazzak",
        ["Khadgar"]="Proalibank-Khadgar",
        ["Bloodhoof"]="Proalibank-Khadgar",
        ["Magtheridon"]="Proalibank-Magtheridon",
        ["Nagrand"]="Proalibank-Nagrand",
        ["Runetotem"]="Proalibank-Nagrand",
        ["Kilrogg"]="Proalibank-Nagrand",
        ["Outland"]="Proalibank-Outland",
        ["Quel'Thalas"]="Proalibank-Quel'Thalas",
        ["AzjolNerub"]="Proalibank-Quel'Thalas",
        ["Ragnaros"]="Proalibank-Ragnaros",
        ["Ravencrest"]="Proalibank-Ravencrest",
        ["Sanguino"]="Proalibank-Sanguino",
        ["Zul'jin"]="Proalibank-Sanguino",
        ["Uldum"]="Proalibank-Sanguino",
        ["Shen'dralar"]="Proalibank-Sanguino",
        ["Shattrath"]="Proalibank-Shattrath",
        ["Nozdormu"]="Proalibank-Shattrath",
        ["Garrosh"]="Proalibank-Shattrath",
        ["Silvermoon"]="Proalibank-Silvermoon",
        ["Stormreaver"]="Proalibank-Stormreaver",
        ["Vashj"]="Proalibank-Stormreaver",
        ["Spinebreaker"]="Proalibank-Stormreaver",
        ["Haomarush"]="Proalibank-Stormreaver",
        ["Dragonmaw"]="Proalibank-Stormreaver",
        ["Stormscale"]="Proalibank-Stormscale",
        ["Sylvanas"]="Proalibank-Sylvanas",
        ["TarrenMill"]="Proalibank-TarrenMill",
        ["Dentarg"]="Proalibank-TarrenMill",
        ["Thrall"]="Proalibank-Thrall",
        ["TwistingNether"]="Proalibank-TwistingNether",
        ["Aggramar"]="NOBANK",
        ["Arakarahm"]="NOBANK",
        ["Area52"]="NOBANK",
        ["Arygos"]="NOBANK",
        ["Azshara"]="NOBANK",
        ["Baelgun"]="NOBANK",
        ["BronzeDragonflight"]="NOBANK",
        ["C'Thun"]="NOBANK",
        ["Cho'gall"]="NOBANK",
        ["ConseildesOmbres"]="NOBANK",
        ["CultedelaRivenoire"]="NOBANK",
        ["DasKonsortium"]="NOBANK",
        ["DasSyndikat"]="NOBANK",
        ["DerabyssischeRat"]="NOBANK",
        ["DerMithrilorden"]="NOBANK",
        ["DerRatvonDalaran"]="NOBANK",
        ["Destromath"]="NOBANK",
        ["DieArguswacht"]="NOBANK",
        ["DieewigeWacht"]="NOBANK",
        ["DieNachtwache"]="NOBANK",
        ["DieSilberneHand"]="NOBANK",
        ["DieTodeskrallen"]="NOBANK",
        ["Drek'Thar"]="NOBANK",
        ["Durotan"]="NOBANK",
        ["Eitrigg"]="NOBANK",
        ["Eldre'Thalas"]="NOBANK",
        ["Exodar"]="NOBANK",
        ["Forscherliga"]="NOBANK",
        ["Gorgonnash"]="NOBANK",
        ["Hellscream"]="NOBANK",
        ["Kael'thas"]="NOBANK",
        ["Khaz'goroth"]="NOBANK",
        ["Krag'jin"]="NOBANK",
        ["Krasus"]="NOBANK",
        ["KultderVerdammten"]="NOBANK",
        ["LaCroisadeécarlate"]="NOBANK",
        ["Lordaeron"]="NOBANK",
        ["Lothar"]="NOBANK",
        ["Mannoroth"]="NOBANK",
        ["Medivh"]="NOBANK",
        ["Minahonda"]="NOBANK",
        ["Nefarian"]="NOBANK",
        ["Nera'thor"]="NOBANK",
        ["Nordrassil"]="NOBANK",
        ["Rashgarroth"]="NOBANK",
        ["Sen'jin"]="NOBANK",
        ["Sinstralis"]="NOBANK",
        ["Suramar"]="NOBANK",
        ["Throk'Feroth"]="NOBANK",
        ["Thunderhorn"]="NOBANK",
        ["Tichondrius"]="NOBANK",
        ["Tirion"]="NOBANK",
        ["Todeswache"]="NOBANK",
        ["Uldaman"]="NOBANK",
        ["Un'Goro"]="NOBANK",
        ["Wildhammer"]="NOBANK",
        ["Ysondre"]="NOBANK",
        ["ZirkeldesCenarius"]="NOBANK"
    }
}