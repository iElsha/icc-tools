IcecrownAdTools = LibStub("AceAddon-3.0"):NewAddon("IcecrownAdTools", "AceConsole-3.0", "AceEvent-3.0")
_G["IcecrownAdTools"] = IcecrownAdTools
local StdUi = LibStub('StdUi')
local ldbi = LibStub("LibDBIcon-1.0")
IcecrownAdTools.colorString = '|cffd4af37ict|r'

IcecrownAdTools.FRAME_LEVEL = 0

function getYearBeginDayOfWeek(tm)
  yearBegin = time{year=date("*t",tm).year,month=1,day=1}
  yearBeginDayOfWeek = tonumber(date("%w",yearBegin))
  -- sunday correct from 0 -> 7
  if(yearBeginDayOfWeek == 0) then yearBeginDayOfWeek = 7 end
  return yearBeginDayOfWeek
end

function getDayAdd(tm)
  yearBeginDayOfWeek = getYearBeginDayOfWeek(tm)
  if(yearBeginDayOfWeek < 5 ) then
    -- first day is week 1
    dayAdd = (yearBeginDayOfWeek - 2)
  else
    -- first day is week 52 or 53
    dayAdd = (yearBeginDayOfWeek - 9)
  end
  return dayAdd
end

function getWeekNumberOfYear(tm)
  dayOfYear = date("%j",tm)
  dayAdd = getDayAdd(tm)
  dayOfYearCorrected = dayOfYear + dayAdd
  if(dayOfYearCorrected < 0) then
    -- week of last year - decide if 52 or 53
    lastYearBegin = time{year=date("*t",tm).year-1,month=1,day=1}
    lastYearEnd = time{year=date("*t",tm).year-1,month=12,day=31}
    dayAdd = getDayAdd(lastYearBegin)
    dayOfYear = dayOfYear + date("%j",lastYearEnd)
    dayOfYearCorrected = dayOfYear + dayAdd
  end
  weekNum = math.floor((dayOfYearCorrected) / 7) + 1
  if( (dayOfYearCorrected > 0) and weekNum == 53) then
    -- check if it is not considered as part of week 1 of next year
    nextYearBegin = time{year=date("*t",tm).year+1,month=1,day=1}
    yearBeginDayOfWeek = getYearBeginDayOfWeek(nextYearBegin)
    if(yearBeginDayOfWeek < 5 ) then
      weekNum = 1
    end
  end
  return weekNum
end

function convert( chars, dist, inv )
    return string.char( ( string.byte( chars ) - 32 + ( inv and -dist or dist ) ) % 95 + 32 )
end

function crypt(str,salt,inv)
    local enc= "";

    for i=1,#str do
        if(#str-salt[5] >= i or not inv) then
            for inc=0,3 do
                if (i%4 == inc) then
                    enc = enc .. convert(string.sub(str,i,i),salt[inc+1],inv);
                    break;
                end
            end
        end
    end
    if (not inv) then
        for i=1,salt[5] do
            enc = enc .. string.char(math.random(32,126));
        end
    end

    return enc;
end

function UserAuthorized(password)
    if (password) then
        local todaysDate = C_Calendar.GetDate()
        local salt = { 4, 8, 15, 16, getWeekNumberOfYear(GetServerTime()) }
        local unescapedInput = string.gsub(password, "//", "/")
        unescapedInput = string.gsub(unescapedInput, "||", "|")
        local decryption = crypt(unescapedInput, salt, true)
        if (decryption == "gallywix") then
            IcecrownAdTools.db.global.password = password
            return true
        else
            return false
        end
    else
        return false
    end
end

SLASH_ICT1 = "/ict"
function SlashCmdList.ICT(msg)
    msg = string.lower(msg)
    if (msg == "maillog") then
        IcecrownAdTools.mailLogViewer:OpenPanel()
    elseif (msg == "send") then
        IcecrownAdTools.mailSender:OpenPanel()
    elseif (msg == "invite") then
        IcecrownAdTools.groupInviter:OpenPanel()
    elseif (msg == "whisper") then
        IcecrownAdTools.buyerWhisperer:OpenPanel()
    elseif (msg == "tradelog") then
        IcecrownAdTools.tradeLogViewer:OpenPanel()
    elseif (msg == "version") then
        print(IcecrownAdTools.colorString .. " The current IcecrownAdTools version is: " .. GetAddOnMetadata("IcecrownAdTools", "Version"))
    elseif (msg == "minimap") then
        IcecrownAdTools.db.global.minimap.hide = not IcecrownAdTools.db.global.minimap.hide
        ldbi:Refresh("IcecrownMinimapButton", IcecrownAdTools.db.global.minimap)
    else
        print(IcecrownAdTools.colorString.." Options:")
        print("   /"..IcecrownAdTools.colorString.." send - opens a panel for sending mail in bulk")
        print("   /"..IcecrownAdTools.colorString.." maillog - opens a log of all mail sent and received")
        print("   /"..IcecrownAdTools.colorString.." invite - invite players and track the progress of those invites")
        print("   /"..IcecrownAdTools.colorString.." whisper - whisper buyers who their funnelers are")
        print("   /"..IcecrownAdTools.colorString.." tradelog - opens a log of all trades")
        print("   /"..IcecrownAdTools.colorString.." minimap - toggle visiblity of minimap")
        print("   /"..IcecrownAdTools.colorString.." version - print the version number of the addon")
    end
end

function IcecrownAdTools:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("IcecrownAdToolsDB", defaults)
    IcecrownAdTools:MigrateOldDatabaseSchema()
    IcecrownAdTools:DrawMinimapButton()
    self.mailLogViewer = IcecrownAdTools:GetModule("IcecrownMailLogViewer")
    self.mailSender = IcecrownAdTools:GetModule("IcecrownMailSender")
    self.groupInviter = IcecrownAdTools:GetModule("IcecrownGroupInviter")
    self.buyerWhisperer = IcecrownAdTools:GetModule("IcecrownBuyerWhisperer")
    self.transferSender = IcecrownAdTools:GetModule("IcecrownDepositTransferer")
    self.tradeLogViewer = IcecrownAdTools:GetModule("IcecrownTradeLogViewer")
    for name, module in self:IterateModules() do
        module:SetEnabledState(true)
    end

    IcecrownAdTools:SetupOptions()

    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("IcecrownAdTools", "IcecrownAdTools")
end

function IcecrownAdTools:DrawMinimapButton()
    local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("IcecrownMinimapButton", {
        type = "launcher",
        icon = [=[Interface\Addons\IcecrownAdTools\media\Icecrown32.tga]=],
        OnClick = function(self)
            if (not self.menuFrame) then
                local menuFrame = CreateFrame("Frame", "ExampleMenuFrame", UIParent, "UIDropDownMenuTemplate")
                self.menuFrame = menuFrame
            end
            local menu = {
                { text = "Icecrown Advertiser Tools", notCheckable = true,  isTitle = true},
                { text = "Toggle Mail Log", notCheckable = true, func = function() IcecrownAdTools.mailLogViewer:Toggle() end },
                { text = "Toggle Trade Log", notCheckable = true, func = function() IcecrownAdTools.tradeLogViewer:Toggle() end },
                { text = "Toggle Buyer Invite Panel", notCheckable = true,  func = function() IcecrownAdTools.groupInviter:Toggle() end },
                { text = "Toggle Buyer Whisper Panel", notCheckable = true,  func = function() IcecrownAdTools.buyerWhisperer:Toggle() end },
                { text = "Hide Minimap Icon", notCheckable = true,  func = function() IcecrownAdTools.db.global.minimap.hide = true; ldbi:Refresh("IcecrownMinimapButton", IcecrownAdTools.db.global.minimap) end },
            }
            EasyMenu(menu, self.menuFrame, "cursor", 0 , 0, "MENU");
        end,
    })

    ldbi:Register("IcecrownMinimapButton", ldb, self.db.global.minimap)
    ldbi:Refresh("IcecrownMinimapButton", self.db.global.minimap)
end

function IcecrownAdTools:OnEnable()
    self:RegisterEvent("MAIL_SHOW", "OnEvent")
    self:RegisterEvent("MAIL_CLOSED", "OnEvent")

end

function IcecrownAdTools:OnEvent(event)
    if (event == "MAIL_SHOW") then
        IcecrownAdTools:DrawMailFrameButtons()
    elseif (event == "MAIL_CLOSED") then
        if (self.senderButton) then self.senderButton:Hide() end
        if (self.logButton) then self.logButton:Hide() end
        if (self.transferButton) then self.transferButton:Hide() end
        if (self.iconFrame) then self.iconFrame:Hide() end
    end
end

function IcecrownAdTools:DrawMailFrameButtons()
    if (not self.iconFrame and not self.senderButton and not self.logButton and not self.transferButton) then
        local iconFrame = StdUi:Frame(MailFrame, 32, 32)
        local iconTex = StdUi:Texture(iconFrame, 32, 32, [=[Interface\Addons\IcecrownAdTools\media\Icecrown32.tga]=])
        StdUi:GlueTop(iconTex, iconFrame, 0, 0)

        local logButton = StdUi:Button(MailFrame, 150, 22, "Mail Log")
        logButton:SetScript("OnClick", function()
            IcecrownAdTools.mailLogViewer:Toggle()
        end)

        StdUi:GlueBottom(logButton, MailFrame, 20, -22, "RIGHT")
        StdUi:GlueLeft(iconFrame, logButton, 0, -11)

        local senderButton = StdUi:Button(MailFrame, 150, 22, "Mail Gold")
        senderButton:SetScript("OnClick", function()
            IcecrownAdTools.mailSender:Toggle()
        end)

        StdUi:GlueBottom(senderButton, logButton, 0, -22)

        local transferButton = StdUi:Button(MailFrame, 150, 22, "Transfer Deposit")
        transferButton:SetScript("OnClick", function()
            IcecrownAdTools.transferSender:Toggle()
        end)

        StdUi:GlueBottom(transferButton, senderButton, 0, -22)

        self.sendButton = senderButton
        self.logButton = logButton
        self.transferButton = transferButton;
        self.iconFrame = iconFrame
    else
        self.iconFrame:Show()
        self.sendButton:Show()
        self.logButton:Show()
        self.transferButton:Show()
    end
end

function IcecrownAdTools:MigrateOldDatabaseSchema()
    for k,v in pairs(self.db.global) do
        if (type(k) == "number") then -- mail was previously stored in the root in generic keys
            if (self.db.global.mail == nil) then
                self.db.global.mail = {}
            end
            self.db.global["mail"][k] = v
            self.db.global[k] = nil
        end
    end

    if (not self.db.global.mail) then
        self.db.global.mail = {}
    end
    
    if (not self.db.global.trade) then
        self.db.global.trade = {}
    end

    if (not self.db.global.minimap) then
       self.db.global.minimap = {["hide"] = false}
    end
end

function IcecrownAdTools:GetNextFrameLevel()
    IcecrownAdTools.FRAME_LEVEL = IcecrownAdTools.FRAME_LEVEL + 10
    return math.min(IcecrownAdTools.FRAME_LEVEL, 10000)
end

function IcecrownAdTools:SetupOptions()
    self.options = {
        name = "Icecrown Comunity",
        descStyle = "inline",
        type = "group",
        childGroups = "tab",
        args = {
            desc = {
                type = "description",
                name = "Simple addon with tools to automate Icecrown-related tasks.",
                fontSize = "medium",
                order = 1
            },
            author = {
                type = "description",
                name = "\n|cffffd100Author: |r Dajn @ Tarren Mill",
                order = 2
            },
            version = {
                type = "description",
                name = "|cffffd100Version: |r" .. GetAddOnMetadata("IcecrownAdTools", "Version") .."\n",
                order = 3
            },
            hideminimap = {
                name = "Show minimap icon",
                desc = "|cffaaaaaaWhether or not to show the minimap icon. |r",
                descStyle = "inline",
                width = "full",
                type = "toggle",
                order = 4,
                set = function(info,val)
                    IcecrownAdTools.db.global.minimap.hide = not val
                    ldbi:Refresh("IcecrownMinimapButton", IcecrownAdTools.db.global.minimap)
                end,
                get = function(info) return not IcecrownAdTools.db.global.minimap.hide end
            },
            whisperaftertrade = {
                name = "Whisper after trade",
                desc = "|cffaaaaaaWhisper the target about gold received/given after a trade. |r",
                descStyle = "inline",
                width = "full",
                type = "toggle",
                order = 5,
                set = function(info,val)
                    IcecrownAdTools.db.global.whisperAfterTrade = val
                end,
                get = function(info) return IcecrownAdTools.db.global.whisperAfterTrade end
            },
        }
    }

    LibStub("AceConfig-3.0"):RegisterOptionsTable("IcecrownAdTools", self.options)
end
