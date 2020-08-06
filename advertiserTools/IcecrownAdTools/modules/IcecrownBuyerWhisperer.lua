local IcecrownAdTools = LibStub("AceAddon-3.0"):GetAddon("IcecrownAdTools")
local IcecrownBuyerWhisperer = IcecrownAdTools:NewModule("IcecrownBuyerWhisperer", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0", "AceTimer-3.0")
local StdUi = LibStub('StdUi')

function IcecrownBuyerWhisperer:OnEnable()
  self.configDB = IcecrownAdTools.db.char
end

function IcecrownBuyerWhisperer:OpenPanel()
    -- If we already make all our frames previously, don't make them again.
    if (self.whisperWindow == nil) then
        self:DrawWindow()
        self:DrawInfoIcon()
    else
        self.whisperWindow:Show()
    end
end

function IcecrownBuyerWhisperer:Toggle()
    if not self.whisperWindow then
        IcecrownBuyerWhisperer:OpenPanel()
    elseif self.whisperWindow:IsVisible() then
        self.whisperWindow:Hide()
    else
        self.whisperWindow:Show()
    end
end

function IcecrownBuyerWhisperer:DrawWindow()
    local whisperWindow
    if (self.configDB.whisperWindow ~= nil) then
        whisperWindow = StdUi:Window(UIParent, self.configDB.whisperWindowSize.width, self.configDB.whisperWindowSize.height, "Icecrown Buyer Whisperer")
    else
        whisperWindow = StdUi:Window(UIParent, 300, 400, "Icecrown Buyer Whisperer")
    end

    if (self.configDB.whisperWindowPosition ~= nil) then
        whisperWindow:SetPoint(self.configDB.whisperWindowPosition.point or "CENTER",
                            self.configDB.whisperWindowPosition.UIParent,
                            self.configDB.whisperWindowPosition.relPoint or "CENTER",
                            self.configDB.whisperWindowPosition.relX or 0,
                            self.configDB.whisperWindowPosition.relY or 0)
    else
        whisperWindow:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    end


    StdUi:MakeResizable(whisperWindow, "BOTTOMRIGHT")
    whisperWindow:SetMinResize(290, 332)
    whisperWindow:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())

    whisperWindow:SetScript("OnMouseDown", function(self)
        self:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
    end)

    whisperWindow:SetScript("OnSizeChanged", function(self)
        IcecrownBuyerWhisperer.configDB.whisperWindowSize = {width=self:GetWidth(), height=self:GetHeight()}
    end)

    whisperWindow:SetScript('OnDragStop', function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, xOfs, yOfs = self:GetPoint()
        IcecrownBuyerWhisperer.configDB.whisperWindowPosition = {point=point, relPoint=relPoint, relX=xOfs, relY=yOfs}
    end)

    local editBox = StdUi:MultiLineBox(whisperWindow, 280, 300, nil)
    StdUi:GlueAcross(editBox, whisperWindow, 10, -50, -10, 70)
    editBox:SetFocus()

    local sendButton = StdUi:Button(whisperWindow, 160, 30, 'Send Whispers')
    StdUi:GlueBottom(sendButton, whisperWindow, 0, 10, 'CENTER')
    sendButton:SetScript('OnClick', function()
        IcecrownBuyerWhisperer:Start()
    end)

    local logoFrame = StdUi:Frame(whisperWindow, 32, 32)
    local logoTexture = StdUi:Texture(logoFrame, 32, 32, [=[Interface\Addons\IcecrownAdTools\media\Icecrown32.tga]=])

    StdUi:GlueTop(logoTexture, logoFrame, 0, 0, "CENTER")
    StdUi:GlueBottom(logoFrame, whisperWindow, -10, 10, "RIGHT")


    local balanceMessage
    if (self.configDB.balanceMessage == nil) then
        balanceMessage = "Hey! Your loot traders are: {funnelers}"
    else
        balanceMessage = self.configDB.balanceMessage
    end
    local function customValidator(self)
        local text = self:GetText();
        if text then
            self.value = text;
            IcecrownBuyerWhisperer.configDB.balanceMessage = text
            StdUi:MarkAsValid(self, true);
            return true;
        end
    end

    local messageBox = StdUi:EditBox(whisperWindow, 430, 20, balanceMessage, customValidator)
    StdUi:GlueBelow(messageBox, editBox, 0, -3, "LEFT")
    messageBox:SetPoint("TOPRIGHT", editBox, "BOTTOMRIGHT", 0, -3)

    self.whisperWindow = whisperWindow
    self.whisperWindow.sendButton = sendButton
    self.whisperWindow.messageBox = messageBox
    self.whisperWindow.editBox = editBox
end

function IcecrownBuyerWhisperer:DrawInfoIcon()
    local whisperWindow = self.whisperWindow
    local infoFrame = StdUi:Frame(whisperWindow, 16, 16, nil);
    StdUi:GlueRight(infoFrame, self.whisperWindow.sendButton, 20, 0, 'RIGHT')
    local infoTexture = StdUi:Texture(whisperWindow, 16, 16, [=[Interface\FriendsFrame\InformationIcon]=])
    StdUi:GlueTop(infoTexture, infoFrame, 0, 0, "CENTER")
    local tooltip = StdUi:FrameTooltip(infoFrame, "Examples:|nplayer1-server:funnel1-server,funnel2-server,funnel3-server", "tooltip", "TOP", true)
end

function IcecrownBuyerWhisperer:Start()
    if (self.whisperWindow.editBox ~= nil and self.whisperWindow.editBox:GetText() ~= nil) then
        local input = self.whisperWindow.editBox:GetText()
        local parsedInput = string.gmatch(input, "[^\r\n]+")
        for entry in parsedInput do
            local subEntries = {}
            for subEntry in (entry):gmatch("[^:]+") do
                table.insert(subEntries, subEntry)
            end
            if (subEntries[1] and subEntries[2]) then
                local player = IcecrownBuyerWhisperer:EnsureFullName(subEntries[1])
                local unformattedMessage = self.whisperWindow.messageBox:GetText()
                local formattedMessage = unformattedMessage:gsub("{funnelers}", subEntries[2])
                SendChatMessage(formattedMessage, "WHISPER", "COMMON", player)
            end
        end
   end

   self.whisperWindow:Hide()
end

function IcecrownBuyerWhisperer:EnsureFullName(name)
        if (not name:find("-")) then
        name = name .. "-" .. select(2, UnitFullName("player"))
    end

    return name
end

function IcecrownBuyerWhisperer:Finish()
    self.whisperWindow:Hide()
end