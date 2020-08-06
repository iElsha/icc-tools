local IcecrownAdTools = LibStub("AceAddon-3.0"):GetAddon("IcecrownAdTools")
local IcecrownMailSender = IcecrownAdTools:NewModule("IcecrownMailSender", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0", "AceTimer-3.0")
local StdUi = LibStub('StdUi')


IcecrownMailSender.mail = {}
IcecrownMailSender.expectingMailEvent = false
IcecrownMailSender.pendingMailContents = {}

function IcecrownMailSender:OnEnable()
  self:RegisterEvent("PLAYER_MONEY", "OnEvent")
  self:RegisterEvent("MAIL_FAILED", "OnEvent")
  self:RegisterEvent("MAIL_SUCCESS", "OnEvent")
  self:RegisterEvent("MAIL_CLOSED", "OnEvent")
  self.db = IcecrownAdTools.db.global.mail
  self.configDB = IcecrownAdTools.db.char
end

function IcecrownMailSender:OpenPanel()
    -- If we already make all our frames previously, don't make them again.
    if (self.sendWindow == nil) then
        self:DrawWindow()
        self:DrawInfoIcon()
    else
        self.sendWindow:Show()
    end
end

function IcecrownMailSender:Toggle()
    if not self.sendWindow then
        IcecrownMailSender:OpenPanel()
    elseif self.sendWindow:IsVisible() then
        self.sendWindow:Hide()
    else
        self.sendWindow:Show()
    end
end

function IcecrownMailSender:DrawWindow()
    local sendWindow
    if (self.configDB.sendWindowSize ~= nil) then
        sendWindow = StdUi:Window(UIParent, self.configDB.sendWindowSize.width, self.configDB.sendWindowSize.height, "Icecrown Mail Sender")
    else
        sendWindow = StdUi:Window(UIParent, 300, 400, "Icecrown Mail Sender")
    end

    if (self.configDB.sendWindowPosition ~= nil) then
        sendWindow:SetPoint(self.configDB.sendWindowPosition.point or "CENTER",
                            self.configDB.sendWindowPosition.UIParent,
                            self.configDB.sendWindowPosition.relPoint or "CENTER",
                            self.configDB.sendWindowPosition.relX or 0,
                            self.configDB.sendWindowPosition.relY or 0)
    else
        sendWindow:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    end

    StdUi:MakeResizable(sendWindow, "BOTTOMRIGHT")
    sendWindow:SetMinResize(250, 332)
    sendWindow:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
    sendWindow:SetScript("OnMouseDown", function(self)
        self:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
    end)

    sendWindow:SetScript("OnSizeChanged", function(self)
        IcecrownMailSender.configDB.sendWindowSize = {width=self:GetWidth(), height=self:GetHeight()}
    end)

    sendWindow:SetScript('OnDragStop', function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, xOfs, yOfs = self:GetPoint()
        IcecrownMailSender.configDB.sendWindowPosition = {point=point, relPoint=relPoint, relX=xOfs, relY=yOfs}
    end)

    local editBox = StdUi:MultiLineBox(sendWindow, 280, 300, nil)
    StdUi:GlueAcross(editBox, sendWindow, 10, -50, -10, 50)
    editBox:SetFocus()

    local sendButton = StdUi:Button(sendWindow, 80, 30, 'Send')
    StdUi:GlueBottom(sendButton, sendWindow, 0, 10, 'CENTER')
    sendButton:SetScript('OnClick', function()
        IcecrownMailSender:Start()
    end)

    local logoFrame = StdUi:Frame(sendWindow, 32, 32)
    local logoTexture = StdUi:Texture(logoFrame, 32, 32, [=[Interface\Addons\IcecrownAdTools\media\Icecrown32.tga]=])

    StdUi:GlueTop(logoTexture, logoFrame, 0, 0, "CENTER")
    StdUi:GlueBottom(logoFrame, sendWindow, -10, 10, "RIGHT")

    self.sendWindow = sendWindow
    self.sendWindow.sendButton = sendButton
    self.sendWindow.editBox = editBox
end

function IcecrownMailSender:DrawInfoIcon()
    local sendWindow = self.sendWindow
    local infoFrame = StdUi:Frame(sendWindow, 16, 16, nil);
    StdUi:GlueRight(infoFrame, self.sendWindow.sendButton, 20, 0, 'RIGHT')
    local infoTexture = StdUi:Texture(sendWindow, 16, 16, [=[Interface\FriendsFrame\InformationIcon]=])
    StdUi:GlueTop(infoTexture, infoFrame, 0, 0, "CENTER")
    local tooltip = StdUi:FrameTooltip(infoFrame, "Examples:|nplayer1-server:100:subject1:body1|nplayer2-server:200:subject2:body2|nplayer3-server:199:subject3:body3", "tooltip", "TOP", true)
end

-- Reset players/gold, repopulate by parsing input, and attempt first send.
function IcecrownMailSender:Start()
   wipe(self.mail)
   self.expectingMailEvent = false
   self.mailSent = 1
   if (self.sendWindow.editBox ~= nil and self.sendWindow.editBox:GetText() ~= nil) then
        IcecrownMailSender:ParseInput()
        if (not IcecrownMailSender:HasEnoughGold()) then
            IcecrownMailSender:LogNotEnoughGold()
            IcecrownMailSender:Finish()
            return
        end
        IcecrownMailSender:AttemptSendMail(self.mailSent)
   end
end

function IcecrownMailSender:AttemptSendMail(index)
    local gold = (self.mail[index].gold or 0)
    local player = self.mail[index].player
    local subject = self.mail[index].subject or ""
    local body = self.mail[index].body or ""
    SetSendMailMoney(gold)
    SendMail(player, subject, body)
end

-- We must rate-limit based on events, or else the Blizzard API will simply swallow mail requests.
function IcecrownMailSender:OnEvent(event, ...)
    -- We rate limit on PLAYER_MONEY rather than MAIL_SUCCESS because it allows us to more reliably check if we have enough gold to send the next message.
    if (#self.mail > 0) then
        if (event == "PLAYER_MONEY" or event == "MAIL_FAILED" or event == "MAIL_CLOSED") then
            -- We're in the middle of sending out messages, so assume the event was for us; print out the message for the previous player.
            if (event == "MAIL_CLOSED") then
                IcecrownMailSender:Finish()
                return
            elseif (event == "PLAYER_MONEY") then
                print("|CFF00FF00[IcecrownMailSender]: Sent " .. IcecrownMailSender:FormatRawCurrency(self.mail[self.mailSent].gold) .. " gold to player " .. self.mail[self.mailSent].player)
                self.db[#self.db + 1] = self.pendingMailContents
            elseif (event == "MAIL_FAILED") then
                print("|CFFFF0000[IcecrownMailSender]: Failed to send " .. IcecrownMailSender:FormatRawCurrency(self.mail[self.mailSent].gold) .. " gold to player " .. self.mail[self.mailSent].player .. "; stopping")
                IcecrownMailSender:Finish()
                return
            end
            self.mailSent = self.mailSent + 1
            if (self.mailSent > #self.mail) then
                IcecrownMailSender:Finish()
                return
            elseif (not IcecrownMailSender:HasEnoughGold()) then
                -- Before we continue, check to see whether we have enough gold. If we don't, short-circuit.
                IcecrownMailSender:LogNotEnoughGold()
                IcecrownMailSender:Finish()
                return
            else
                IcecrownMailSender:AttemptSendMail(self.mailSent)
            end
        end
    else
        if (event == "MAIL_SUCCESS" and self.expectingMailEvent) then
            self.db[#self.db + 1] = self.pendingMailContents
            self.expectingMailEvent = false
        elseif (event == "MAIL_FAILED" and self.expectingMailEvent) then
            wipe(self.pendingMailContents)
            self.expectingMailEvent = false
        end
    end
end

-- Hook SendMail so we can save all the mail information and await a MAIL_SUCCESS/MAIL_FAILED event.
hooksecurefunc ("SendMail", function (name, subject, body)
        local money = GetSendMailMoney()
        if (money > 0) then
            IcecrownMailSender.expectingMailEvent = true
            IcecrownMailSender.pendingMailContents = {source=IcecrownMailSender:GetPlayerFullName(), destination=name, gold=money, subject=subject, body=body, sent=true, date=date("%Y-%m-%d %X (%A)")}
        end
end)

hooksecurefunc ("TakeInboxMoney", function (index)

        local sender, subject, money, _, daysLeft = select(3,GetInboxHeaderInfo(index))
        local body = GetInboxText(index)
        if (sender and not sender:find("-")) then
            sender = sender .. "-" .. select(2, UnitFullName("player"))
        end
        if (money > 0) then
            IcecrownMailSender.expectingMailEvent = true
            local sentDate = date("%Y-%m-%d %X (%A)",(time() - (31 - daysLeft) * 24 * 60 * 60))
            IcecrownMailSender.pendingMailContents = {source=sender, destination=IcecrownMailSender:GetPlayerFullName(), gold=money, subject=subject, body=body, sent=false, date=sentDate, openedDate=date("%Y-%m-%d %X (%A)")}
        end
end)

hooksecurefunc ("AutoLootMailItem", function (index)
        local sender, subject, money, _, daysLeft = select(3,GetInboxHeaderInfo(index))
        local body = GetInboxText(index)
        if (sender and not sender:find("-")) then
            sender = sender .. "-" .. select(2, UnitFullName("player"))
        end
        if (money > 0) then
            IcecrownMailSender.expectingMailEvent = true
            local sentDate = date("%Y-%m-%d %X (%A)",(time() - (31 - daysLeft) * 24 * 60 * 60))
            IcecrownMailSender.pendingMailContents = {source=sender, destination=IcecrownMailSender:GetPlayerFullName(), gold=money, subject=subject, body=body, sent=false, date=sentDate, openedDate=date("%Y-%m-%d %X (%A)")}
        end
end)

hooksecurefunc (OpenAllMail, "ProcessNextItem", function (self)
        self.timeUntilNextRetrieval = 0.3
end)

-- Split on newlines, then split on colons to get player:gold:subject:body parts.
function IcecrownMailSender:ParseInput()
    local input = self.sendWindow.editBox:GetText()
    local parsedInput = string.gmatch(input, "[^\r\n]+")
    for entry in parsedInput do
        local subEntries = {}
        for subEntry in (entry):gmatch("[^:]+") do
            table.insert(subEntries, subEntry)
        end
        local player = subEntries[1] or ""
        local gold = subEntries[2] or 0
        local subject = subEntries[3] or "Icecrown Community Payouts"
        local body = subEntries[4] or ""
        self.mail[#self.mail + 1] = {player=player, gold=gold * COPPER_PER_GOLD, subject=subject, body=body}
    end
end

function IcecrownMailSender:HasEnoughGold()
    return (GetMoney() > tonumber(self.mail[self.mailSent].gold or 0))
end

function IcecrownMailSender:LogNotEnoughGold()
    print("|CFFFF0000[IcecrownMailSender]: Not enough gold to continue.")
    print("|CFFFF0000[IcecrownMailSender]: Current player: " .. self.mail[self.mailSent].player .. ", gold: " .. IcecrownMailSender:FormatRawCurrency(self.mail[self.mailSent].gold))
end

function IcecrownMailSender:FormatRawCurrency(currency)
    return math.floor(currency / COPPER_PER_GOLD)
end

function IcecrownMailSender:GetPlayerFullName()
    local name, realm = UnitFullName("player")
    return name .. "-" .. realm
end

function IcecrownMailSender:Finish()
    print("|CFF00FF00[IcecrownMailSender]: Done!")
    wipe(self.mail)
    self.pendingMailContents = {}
    self.expectingMailEvent = false
    self.sendWindow:Hide()
end