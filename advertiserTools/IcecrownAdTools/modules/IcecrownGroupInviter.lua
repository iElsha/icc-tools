local IcecrownAdTools = LibStub("AceAddon-3.0"):GetAddon("IcecrownAdTools")
local IcecrownGroupInviter = IcecrownAdTools:NewModule("IcecrownGroupInviter", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
local StdUi = LibStub('StdUi')

IcecrownGroupInviter.WAITING_STRING = "Waiting..."
IcecrownGroupInviter.DECLINED_STRING = "Declined"
IcecrownGroupInviter.IN_RAID_STRING = "In Raid"
IcecrownGroupInviter.NOEXIST_STRING = "Offline/Incorrect"
IcecrownGroupInviter.BUSY_STRING = "Busy/In Group"
IcecrownGroupInviter.playersToInvite = {}
IcecrownGroupInviter.expectingEvents = false

function IcecrownGroupInviter:OnEnable()
  self.configDB = IcecrownAdTools.db.char
end

-- Open the invite panel
function IcecrownGroupInviter:OpenPanel()
    if (self.inviteWindow == nil) then
        self:DrawInviteWindow()
    else
        self.inviteWindow:Show()
    end
end

function IcecrownGroupInviter:Toggle()
    if not self.inviteWindow then
        IcecrownGroupInviter:OpenPanel()
    elseif self.inviteWindow:IsVisible() then
        self.inviteWindow:Hide()
    else
        self.inviteWindow:Show()
    end
end

-- Draw the invite panel
function IcecrownGroupInviter:DrawInviteWindow()
    local inviteWindow = StdUi:Window(UIParent, 300, 400, "Invite Players")
    inviteWindow:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    inviteWindow:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
    inviteWindow:SetScript("OnMouseDown", function(self)
        self:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
    end)

    StdUi:MakeResizable(inviteWindow, "BOTTOMRIGHT")
    inviteWindow:SetMinResize(250, 332)
    inviteWindow:IsUserPlaced(true);

    local editBox = StdUi:MultiLineBox(inviteWindow, 280, 300, nil)
    editBox:SetAlpha(0.75)
    StdUi:GlueAcross(editBox, inviteWindow, 10, -50, -10, 50)
    editBox:SetFocus()

    local logoFrame = StdUi:Frame(inviteWindow, 32, 32)
    local logoTexture = StdUi:Texture(logoFrame, 32, 32, [=[Interface\Addons\IcecrownAdTools\media\Icecrown32.tga]=])
    StdUi:GlueTop(logoTexture, logoFrame, 0, 0, "CENTER")
    StdUi:GlueBottom(logoFrame, inviteWindow, -10, 10, "RIGHT")

    local inviteButton = StdUi:Button(inviteWindow, 80, 30, 'Invite')
    StdUi:GlueBottom(inviteButton, inviteWindow, 0, 10, 'CENTER')
    inviteButton:SetScript('OnClick', function()
        IcecrownGroupInviter:ParseInviteInput()
        IcecrownGroupInviter:InvitePlayers()
        self.inviteWindow:Hide()
    end)

    self.inviteWindow = inviteWindow
    self.inviteWindow.editBox = editBox
end

-- Parse the invite panel's editbox; split on newline, ignore whitespace, append realm if missing
function IcecrownGroupInviter:ParseInviteInput()
    wipe(self.playersToInvite)
    local input = self.inviteWindow.editBox:GetText()
    local parsedInput = string.gmatch(input, "[^\r\n]+")
    for entry in parsedInput do
        local subEntries = {}
        for subEntry in (entry):gmatch("[^:]+") do
            table.insert(subEntries, subEntry)
        end
        local player = subEntries[1] or ""
        local balance = subEntries[2] or 0
        if (player and not player:find("-")) then
            player = player .. "-" .. select(2, UnitFullName("player"))
        end
        self.playersToInvite[#self.playersToInvite + 1] = {name=player, balance=balance * 10000, timer=nil, status=IcecrownGroupInviter.WAITING_STRING, hasSentMessage = false} -- timer will be populated later
    end
end

-- Draw the progress window, then invite all players we tracked in ParseInviteInput.
function IcecrownGroupInviter:InvitePlayers()
    if (self.playersToInvite) then
        if (self.progressWindow) then
            self.inviteWindow:Hide()
            self.progressWindow:Show()
        else
            IcecrownGroupInviter:DrawProgressWindow()
        end

        for _, player in pairs(self.playersToInvite) do
            C_PartyInfo.InviteUnit(player.name)
        end
    end
end

function IcecrownGroupInviter:DrawProgressWindow()
    local progressWindow = StdUi:Window(UIParent, 500, 300, "Invite Progress")
    progressWindow:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    progressWindow:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
    progressWindow:SetScript("OnMouseDown", function(self)
        self:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
    end)

    progressWindow:SetScript("OnMouseDown", function(self)
        self:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
    end)

    StdUi:MakeResizable(progressWindow, "BOTTOMRIGHT")
    progressWindow:SetMinResize(500, 150)

    local cols = {
        {
            name         = "",
            width        =  32,
            align        = "LEFT",
            index        = "icon",
            format       = "icon",
            defaultSort  = "asc"
        },
        {
            name         = "Name",
            width        = 150,
            align        = "LEFT",
            index        = "name",
            format       = "string",
        },
        {
            name         = "Status",
            width        = 150,
            align        = "CENTER",
            index        = "status",
            format       = "string"
        },
        {
            name         = "Time Remaining",
            width        = 150,
            align        = "CENTER",
            index        = "timeLeft",
            format       = "string"
        },
        {
            name         = "Balance",
            width        = 100,
            align        = "CENTER",
            index        = "balance",
            format       = "money",
            events       = {
                OnClick = function(rowFrame, cellFrame, data, cols, row, realRow, column, table, button, ...)
                    cols.balance = 0
                    local player = IcecrownGroupInviter:GetTrackedPlayer(cols.name)
                    if (player and player.index) then
                        player = self.playersToInvite[player.index]
                        player.balance = 0
                    end
                end,
            },
        },
        {
            name         = "",
            width        = 32,
            align        = "CENTER",
            index        = "inviteTexture",
            format       = "icon",
            texture      = true,
            events       = {
                OnClick = function(rowFrame, cellFrame, data, cols, row, realRow, column, table, button, ...)
                    C_PartyInfo.InviteUnit(cols.name)
                end,
            },
        },
        {
            name         = "",
            width        = 32,
            align        = "CENTER",
            index        = "balanceTexture",
            format       = "icon",
            texture      = true,
            events       = {
                OnClick = function(rowFrame, cellFrame, data, cols, row, realRow, column, table, button, ...)
                    local faction = UnitFactionGroup("player")
                    local city = faction == "Alliance" and "Stormwind" or "Orgrimmar"
                    local unformattedMessage = self.progressWindow.messageBox:GetText()
                    local formattedMessage = unformattedMessage:gsub("{city}", city):gsub("{balance}", IcecrownGroupInviter:FormatRawCurrency(cols.balance))
                    local player = IcecrownGroupInviter:GetTrackedPlayer(cols.name)
                    if (player and player.index) then
                        player = self.playersToInvite[player.index]
                        player.hasSentMessage = true
                    end
                    cols.balanceTexture = [=[Interface\Buttons\UI-GuildButton-MOTD-Disabled]=]
                    SendChatMessage(formattedMessage, "WHISPER", "COMMON", cols.name)
                end,

            },
        },
    }

    local tbl = StdUi:ScrollTable(progressWindow, cols, 5, 16);
    StdUi:GlueAcross(tbl, progressWindow, 10, -50, -10, 50)

    self.progressWindow = progressWindow
    self.progressWindow.table = tbl

    local logoFrame = StdUi:Frame(progressWindow, 32, 32)
    local logoTexture = StdUi:Texture(logoFrame, 32, 32, [=[Interface\Addons\IcecrownAdTools\media\Icecrown32.tga]=])

    StdUi:GlueTop(logoTexture, logoFrame, 0, 0, "CENTER")
    StdUi:GlueBottom(logoFrame, progressWindow, -10, 10, "RIGHT")

    local balanceMessage
    if (self.configDB.balanceMessage == nil) then
        balanceMessage = "Please head over to {city} near the AH. Your balance is {balance} gold."
    else
        balanceMessage = self.configDB.balanceMessage
    end
    local function customValidator(self)
        local text = self:GetText();
        if text then
            self.value = text;
            IcecrownGroupInviter.configDB.balanceMessage = text
            StdUi:MarkAsValid(self, true);
            return true;
        end
    end
    local messageBox = StdUi:EditBox(progressWindow, 430, 20, balanceMessage, customValidator)
    StdUi:GlueBelow(messageBox, tbl, 0, 0, "LEFT")
        messageBox:SetPoint("TOPRIGHT", tbl, "BOTTOMRIGHT", -50, 0)
        self.progressWindow.messageBox = messageBox
    
    
        IcecrownGroupInviter:UpdateProgressWindow()
    end
    
    function IcecrownGroupInviter:UpdateProgressWindow()
        if (not IcecrownGroupInviter.progressWindow) then
            IcecrownGroupInviter:DrawProgressWindow()
        end
        local data = {}
        local currentMembers = {}
        local playersMissing = false
        local ongoingTimers = false
    
        -- Track all of the players in our group.
        for i = 1, MAX_RAID_MEMBERS do
            local name = GetRaidRosterInfo(i)
            if (name ~= nil) then
                if (not name:find("-")) then
                    name = name .. "-" .. select(2, UnitFullName("player"))
                end
                currentMembers[name:lower()] = true
            end
        end
    
        if (IcecrownGroupInviter.playersToInvite) then
            for _, player in pairs(IcecrownGroupInviter.playersToInvite) do
                local icon
                local timeLeft
                -- For each player we've invited, check to see if they're in the group.
                local inRaid = currentMembers[player.name:lower()] ~= nil
                if (inRaid) then
                    -- If they are, we're happy. Cancel their timer and mark them as in the raid.
                    player.status = IcecrownGroupInviter.IN_RAID_STRING
                    icon = 237554 -- happy
                    IcecrownGroupInviter:CancelTimer(player.timer)
                    timeLeft = "N/A"
                else
                    -- If they're not, but we still have a timer running, we're just waiting.
                    playersMissing = true
                    local remaining = IcecrownGroupInviter:TimeLeft(player.timer)
                    if (remaining > 0) then
                        ongoingTimers = true
                        icon = 237555 -- sad
                        timeLeft = math.ceil(remaining)
                    else
                        -- If there's no timer running, but we don't have a more specific status, it must have expired.
                        icon = 237553 -- mad
                        timeLeft = "N/A"
                        if (player.status == IcecrownGroupInviter.WAITING_STRING) then
                            player.status = "Expired"
                        end
                    end
                end
                balanceTexture = (not player.hasSentMessage and [=[Interface\Buttons\UI-GuildButton-MOTD-Up]=]) or [=[Interface\Buttons\UI-GuildButton-MOTD-Disabled]=]
                table.insert(data, {icon = icon, name = player.name, balance = player.balance, status = player.status, timeLeft = timeLeft, inviteTexture = [=[Interface\Buttons\UI-RefreshButton]=], balanceTexture = balanceTexture})
            end
        end
    
        IcecrownGroupInviter.progressWindow.table:SetData(data, true)
        -- Keep refreshing while we're missing players and we have ongoing timers.
        local continueUpdating = playersMissing and ongoingTimers
        if (continueUpdating) then
            if (not IcecrownGroupInviter.progressTimer) then
                -- Refresh the progress window every second, but make sure we don't spawn a billion timers.
                IcecrownGroupInviter.progressTimer = IcecrownGroupInviter:ScheduleRepeatingTimer(function() IcecrownGroupInviter.UpdateProgressWindow() end, 1)
            end
        else
            -- If we feel we have everyone we invited, shut down everything.
            IcecrownGroupInviter:CancelTimer(IcecrownGroupInviter.progressTimer)
            IcecrownGroupInviter.progressTimer = nil
            IcecrownGroupInviter:UnregisterEvent("GROUP_ROSTER_UPDATE", "OnEvent")
            IcecrownGroupInviter:UnregisterEvent("CHAT_MSG_SYSTEM", "OnEvent")
            if (IcecrownGroupInviter.playersToInvite) then
                local anyBalanceLeft = false
                for _, player in pairs(IcecrownGroupInviter.playersToInvite) do
                    if (player.balance > 0) then
                        anyBalanceLeft = true
                    end
                end
    
                if (not anyBalanceLeft) then
                    IcecrownGroupInviter:UnregisterEvent("TRADE_ACCEPT_UPDATE", "OnEvent")
                end
            end
        end
    end
    
    function IcecrownGroupInviter:OnEvent(event, ...)
        if (event == "GROUP_ROSTER_UPDATE") then
            if (not self.progressWindow) then
                IcecrownGroupInviter:DrawProgressWindow()
                IcecrownGroupInviter:UpdateProgressWindow()
            elseif (self.progressWindow:IsVisible()) then
                IcecrownGroupInviter:UpdateProgressWindow()
            end
        elseif (event == "TRADE_ACCEPT_UPDATE") then
            local fullName = IcecrownGroupInviter:EnsureFullName(GetUnitName("NPC")):lower()
            local trackedPlayer = IcecrownGroupInviter:GetTrackedPlayer(fullName)
            local playerAccept, targetAccept = ...
            if (playerAccept == 1 and targetAccept == 1 and trackedPlayer) then
                trackedPlayer.balance = trackedPlayer.balance - GetTargetTradeMoney()
                IcecrownGroupInviter.playersToInvite[trackedPlayer.index] = trackedPlayer
                IcecrownGroupInviter:UpdateProgressWindow()
            end
        elseif (event == "CHAT_MSG_SYSTEM") then
            -- No good way of handling failed group invites, unfortunately. Parse system messages to try to glean failure reasons.
            if (IcecrownGroupInviter.progressWindow and IcecrownGroupInviter.progressWindow:IsVisible()) then
                local message = select(1,...)
                -- Player declines your group invitation
                if (message:find("declines your group invitation.", 1, true)) then
                    local player = string.sub(message, 1, message:find(" ") - 1)
                    local fullName = IcecrownGroupInviter:EnsureFullName(player):lower()
                    local trackedPlayer = IcecrownGroupInviter:GetTrackedPlayer(fullName)
                    if (trackedPlayer) then
                        IcecrownGroupInviter:CancelTimer(trackedPlayer.timer)
                        trackedPlayer.status = IcecrownGroupInviter.DECLINED_STRING
                    end
                    IcecrownGroupInviter:UpdateProgressWindow()
                -- Cannot find player 'Player'
                elseif (message:find("Cannot find player")) then
                    local player = string.match(message, "%b''")
                    player = string.gsub(player, "'", '')
                    local fullName = IcecrownGroupInviter:EnsureFullName(player):lower()
                    local trackedPlayer = IcecrownGroupInviter:GetTrackedPlayer(fullName)
                    if (trackedPlayer) then
                        IcecrownGroupInviter:CancelTimer(trackedPlayer.timer)
                        trackedPlayer.status = IcecrownGroupInviter.NOEXIST_STRING
                    end
                    IcecrownGroupInviter:UpdateProgressWindow()
                -- Player is already in a group
                elseif message:find("is already in a group", 1, true) then
                    local player = string.sub(message, 1, message:find(" ") - 1)
                    local fullName = IcecrownGroupInviter:EnsureFullName(player):lower()
                    local trackedPlayer = IcecrownGroupInviter:GetTrackedPlayer(fullName)
                    if (trackedPlayer) then
                        local timeRemaining = IcecrownGroupInviter:TimeLeft(trackedPlayer.timer)
                        -- kinda jank, but this should help differentiate busy in other group vs. busy accepting our inv
                        if (trackedPlayer and not IcecrownGroupInviter:IsPlayerInRaid(player) and timeRemaining > 58) then
                            IcecrownGroupInviter:CancelTimer(trackedPlayer.timer)
                            trackedPlayer.status = IcecrownGroupInviter.DECLINED_STRING
                            IcecrownGroupInviter:UpdateProgressWindow()
                        end
                    end
                end
            end
        end
    end
    
    function IcecrownGroupInviter:EnsureFullName(name)
        if (not name:find("-")) then
            name = name .. "-" .. select(2, UnitFullName("player"))
        end
    
        return name
    end
    
    function IcecrownGroupInviter:IsPlayerInRaid(player)
        for i = 1, MAX_RAID_MEMBERS do
            local name = GetRaidRosterInfo(i)
            if (player == name) then
                return true
            end
        end
    
        return false
    end
    
    -- If the player is in our players to invite, get them and their index.
    function IcecrownGroupInviter:GetTrackedPlayer(fullName)
        if (self.playersToInvite) then
            for i, player in pairs(self.playersToInvite) do
                if (player.name:lower() == fullName:lower()) then
                    player.index = i
                    return player
                end
            end
        end
    end
    
    -- Intercept invites; if the progress window is open, track them.
    hooksecurefunc (C_PartyInfo, "InviteUnit", function (player)
        if (IcecrownGroupInviter.progressWindow and IcecrownGroupInviter.progressWindow:IsVisible()) then
            IcecrownGroupInviter:RegisterEvent("GROUP_ROSTER_UPDATE", "OnEvent")
            IcecrownGroupInviter:RegisterEvent("CHAT_MSG_SYSTEM", "OnEvent")
            IcecrownGroupInviter:RegisterEvent("TRADE_ACCEPT_UPDATE", "OnEvent")
            local fullName = IcecrownGroupInviter:EnsureFullName(player):lower()
            local trackedPlayer = IcecrownGroupInviter:GetTrackedPlayer(fullName)
            if (trackedPlayer) then
                if (IcecrownGroupInviter:TimeLeft(trackedPlayer.timer) == 0) then
                    local timer = IcecrownGroupInviter:ScheduleTimer(function() --[[noop]] end, 60)
                    trackedPlayer.timer = timer
                    trackedPlayer.status = IcecrownGroupInviter.WAITING_STRING
                    IcecrownGroupInviter.playersToInvite[trackedPlayer.index] = trackedPlayer
                    IcecrownGroupInviter:UpdateProgressWindow()
                end
            else
                local timer = IcecrownGroupInviter:ScheduleTimer(function() --[[noop]] end, 60)
                IcecrownGroupInviter.playersToInvite[#IcecrownGroupInviter.playersToInvite + 1] = {name=fullName, timer=timer, balance = trackedPlayer.balance, status=IcecrownGroupInviter.WAITING_STRING, hasSentMessage = false}
                IcecrownGroupInviter:UpdateProgressWindow()
            end
        end
    end)
    
    function IcecrownGroupInviter:FormatRawCurrency(currency)
        return math.floor(currency / COPPER_PER_GOLD)
    end