--[[
Inspired by TradeLog, but most of the code is just copied from the mail log.
https://github.com/chrises5/TradeLog/blob/master/TradeLog.lua
--]]

local IcecrownAdTools = LibStub("AceAddon-3.0"):GetAddon("IcecrownAdTools")
local IcecrownTradeLogViewer = IcecrownAdTools:NewModule("IcecrownTradeLogViewer", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local StdUi = LibStub("StdUi")

IcecrownTradeLogViewer.pendingTradeContents = {}
IcecrownTradeLogViewer.targetName = ""

function IcecrownTradeLogViewer:OnEnable()
    self.configDB = IcecrownAdTools.db.char
    self.db = IcecrownAdTools.db.global.trade
    self:RegisterEvent("TRADE_ACCEPT_UPDATE", "OnEvent")
    self:RegisterEvent("UI_INFO_MESSAGE", "OnEvent")
    self:RegisterEvent("UI_ERROR_MESSAGE", "OnEvent")
    self:RegisterEvent("TRADE_SHOW", "OnEvent")
end

function IcecrownTradeLogViewer:OnEvent(event, arg1, arg2, ...)
    if (event=="UI_ERROR_MESSAGE") then
        -- Special error cases
        if(arg2==ERR_TRADE_BAG_FULL or arg2==ERR_TRADE_MAX_COUNT_EXCEEDED or arg2==ERR_TRADE_TARGET_BAG_FULL or arg2==ERR_TRADE_TARGET_MAX_COUNT_EXCEEDED) then
            print("|CFFFF0000[IcecrownTradeLogViewer]: Trade with " .. IcecrownTradeLogViewer.targetName .. " was cancelled: " .. arg2)
            IcecrownTradeLogViewer:Finish()
        end
    elseif (event=="UI_INFO_MESSAGE" and (arg2 == ERR_TRADE_CANCELLED or arg2 == ERR_TRADE_COMPLETE)) then
        -- Cancelled or success
        if (arg2 == ERR_TRADE_CANCELLED and self.targetName) then
            print("|CFFFF0000[IcecrownTradeLogViewer]: Trade with " .. IcecrownTradeLogViewer.targetName .. " was cancelled.")
            IcecrownTradeLogViewer:Finish()
        else
            print("|CFF00FF00[IcecrownTradeLogViewer]: Trade with " .. IcecrownTradeLogViewer.targetName .. " was successful.")
            self.db[#self.db + 1] = self.pendingTradeContents
            if IcecrownAdTools.db.global.whisperAfterTrade then
                if (self.pendingTradeContents.playerGold > 0) then
                    SendChatMessage("Gave " .. self.pendingTradeContents.playerGold / COPPER_PER_GOLD .. "g to " .. self.pendingTradeContents.target .. " in a trade.", "WHISPER", "COMMON", self.pendingTradeContents.target)
                elseif (self.pendingTradeContents.targetGold > 0) then
                    SendChatMessage("Received " .. self.pendingTradeContents.targetGold / COPPER_PER_GOLD .. "g from " .. self.pendingTradeContents.target .. " in a trade.", "WHISPER", "COMMON", self.pendingTradeContents.target)
                end
            end
            IcecrownTradeLogViewer:PrintTradeContents()
            if (self.logWindow) then
                C_Timer.After(1, function() IcecrownTradeLogViewer:SearchTrades(self.logWindow.searchBox:GetText()) end)
            end
            IcecrownTradeLogViewer:Finish()
        end
    elseif (event == "TRADE_SHOW") then
        self.targetName = UnitName("NPC") -- Blizzard is weird
    elseif (event == "TRADE_ACCEPT_UPDATE") then
        local playerGoldOffer = GetPlayerTradeMoney()
        local targetGoldOffer = GetTargetTradeMoney()
        local playerItemOffers = ""
        local targetItemOffers = ""

        for i = 1, 6 do
            local name, _, numItems, quality = GetTradePlayerItemInfo(i)
            if (name) then
                playerItemOffers = playerItemOffers .. ITEM_QUALITY_COLORS[quality].hex .. name .. "|r x " .. numItems .. "|n"
            end
        end

        for i = 1, 6 do
            local name, _, numItems, quality = GetTradeTargetItemInfo(i)
            if (name) then
                targetItemOffers = targetItemOffers .. ITEM_QUALITY_COLORS[quality].hex .. name .. "|r x " .. numItems .. "|n"
            end
        end

        self.pendingTradeContents = {date=date("%Y-%m-%d %X (%A)"), player = IcecrownTradeLogViewer:EnsureFullName(UnitName("player")), target = IcecrownTradeLogViewer:EnsureFullName(self.targetName), playerGold = playerGoldOffer, targetGold = targetGoldOffer, playerItems = playerItemOffers, targetItems = targetItemOffers}
    end
end

function IcecrownTradeLogViewer:PrintTradeContents()
    if (self.pendingTradeContents) then
        if (self.pendingTradeContents.playerGold or self.pendingTradeContents.playerItems) then
            print("|CFFFFFF00 Gave:")
            if (self.pendingTradeContents.playerGold and self.pendingTradeContents.playerGold > 0) then
                -- Am I retarded or does \t / |t not work in print? And does |n add a tab? 4 spaces to work around it.
                print("    |CFFFFFF00" .. self.pendingTradeContents.playerGold / COPPER_PER_GOLD .. "g")
            end

            if (self.pendingTradeContents.playerItems and self.pendingTradeContents.playerItems ~= "") then
                print("    " .. self.pendingTradeContents.playerItems)
            end
        end

        if (self.pendingTradeContents.targetGold or self.pendingTradeContents.targetItems) then
            print("|CFFFFFF00 Received:")
            if (self.pendingTradeContents.targetGold and self.pendingTradeContents.targetGold > 0) then
                print("    |CFFFFFF00" .. self.pendingTradeContents.targetGold / COPPER_PER_GOLD .. "g")
            end

            if (self.pendingTradeContents.targetItems and self.pendingTradeContents.targetItems ~= "") then
                print("    " .. self.pendingTradeContents.targetItems)
            end
        end
    end
end

function IcecrownTradeLogViewer:OpenPanel()
    if (self.logWindow == nil) then
        self:DrawWindow()
        self:DrawSearchPane()
        self:DrawSearchResultsTable()
        self:SearchTrades("")
    else
        self.logWindow:Show()
        self:SearchTrades("")
    end
end

function IcecrownTradeLogViewer:Toggle()
    if not self.logWindow then
        IcecrownTradeLogViewer:OpenPanel()
    elseif self.logWindow:IsVisible() then
        self.logWindow:Hide()
    else
        self.logWindow:Show()
    end
end

-- Expensive and brute-force, but does the job. If literally any field contains the filter, return it in the result set.
function IcecrownTradeLogViewer:SearchTrades(filter)
   local logWindow = self.logWindow
   local searchFilter = filter:lower()
   local allResults = self.db
   local filteredResults = {}
   local name, realm = UnitFullName("player")
   local player =  name .. "-" .. realm
   local allCharactersToggled = logWindow.allCharactersToggle:GetChecked()
   local todayToggled = logWindow.todayToggle:GetChecked()
   local date = date("%Y-%m-%d")
   for _,trade in pairs(allResults) do
        if (allCharactersToggled or ((trade.player and trade.player:lower():find(player:lower(), 1, true))) ~= nil)
           and (trade.date and (not todayToggled or (string.sub(trade.date, 1, 10) == date)))
           and ((trade.playerGold and tostring(floor(trade.playerGold / COPPER_PER_GOLD)):find(searchFilter, 1, true))
           or (trade.targetGold and tostring(floor(trade.targetGold / COPPER_PER_GOLD)):find(searchFilter, 1, true))
           or (trade.target and trade.target:lower():find(searchFilter, 1, true))
           or (trade.playerItems and trade.playerItems:lower():find(searchFilter, 1, true))
           or (trade.targetItems and trade.targetItems:lower():find(searchFilter, 1, true))) then
               table.insert(filteredResults, trade)
        end
    end

    --TODO: This really should not be necessary, but I cant figure out how to get StdUi to sort our primary column by desc by default...
    IcecrownTradeLogViewer:ApplyDefaultSort(filteredResults)

    self.currentView = filteredResults
    self.logWindow.searchResults:SetData(self.currentView, true)
    IcecrownTradeLogViewer:UpdateStateText()
    IcecrownTradeLogViewer:UpdateResultsText()
end

function IcecrownTradeLogViewer:DrawWindow()
    local logWindow
    if (self.configDB.logWindowSize ~= nil) then
        logWindow = StdUi:Window(UIParent, self.configDB.logWindowSize.width, self.configDB.logWindowSize.height, "Icecrown Trade Log Viewer")
    else
        logWindow = StdUi:Window(UIParent, 1100, 700, "Icecrown Trade Log Viewer")
    end

    if (self.configDB.logWindowPosition ~= nil) then
        logWindow:SetPoint(self.configDB.logWindowPosition.point or "CENTER",
                            self.configDB.logWindowPosition.UIParent,
                            self.configDB.logWindowPosition.relPoint or "CENTER",
                            self.configDB.logWindowPosition.relX or 0,
                            self.configDB.logWindowPosition.relY or 0)
    else
        logWindow:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    end

    logWindow:SetScript("OnSizeChanged", function(self)
        IcecrownTradeLogViewer.configDB.logWindowSize = {width=self:GetWidth(), height=self:GetHeight()}
    end)

    logWindow:SetScript('OnDragStop', function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, xOfs, yOfs = self:GetPoint()
        IcecrownTradeLogViewer.configDB.logWindowPosition = {point=point, relPoint=relPoint, relX=xOfs, relY=yOfs}
    end)

    StdUi:MakeResizable(logWindow, "BOTTOMRIGHT")
    StdUi:MakeResizable(logWindow, "TOPLEFT")
    logWindow:SetMinResize(850, 250)
    logWindow:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
    logWindow:SetScript("OnMouseDown", function(self)
        self:SetFrameLevel(IcecrownAdTools:GetNextFrameLevel())
    end)

    local logoFrame = StdUi:Frame(logWindow, 32, 32)
    local logoTexture = StdUi:Texture(logoFrame, 32, 32, [=[Interface\Addons\IcecrownAdTools\media\Icecrown32.tga]=])

    StdUi:GlueTop(logoTexture, logoFrame, 0, 0, "CENTER")
    StdUi:GlueBottom(logoFrame, logWindow, -10, 10, "RIGHT")

    logWindow.resultsLabel = StdUi:Label(logWindow, nil, 16)
    StdUi:GlueBottom(logWindow.resultsLabel, logWindow, 10, 5, "LEFT")

    local clearButton = StdUi:Button(logWindow, 128, 16, "Clear Log")
    StdUi:GlueBottom(clearButton, logWindow, 0, 10, "CENTER")

    clearButton:SetScript("OnClick", function() IcecrownTradeLogViewer:DrawClearWarningWindow() end)


    self.logWindow = logWindow
end

function IcecrownTradeLogViewer:DrawClearWarningWindow()
    local buttons = {
                        character = {
                                text = "This Character",
                                onClick = function(b)
                                            IcecrownTradeLogViewer:ClearTradesForCharacter()
                                            b.window:Hide()
                                                                       end
                                                                    },
                                                                    all       = {
                                                                            text = "All Trades",
                                                                            onClick = function(b)
                                                                                        IcecrownTradeLogViewer:ClearAllTrades()
                                                                                        b.window:Hide()
                                                                                      end
                                                                    },
                                                                }
                                            
                                                StdUi:Confirm("Clear Log", "Select log to clear. ThIS CANNOT BE REVERSED. All trade information will be cleared.", buttons, 1)
                                            end
                                            
                                            function IcecrownTradeLogViewer:ClearTradesForCharacter()
                                                local name, realm = UnitFullName("player")
                                                local player =  name .. "-" .. realm
                                                for index, trade in pairs(IcecrownAdTools.db.global.trade) do
                                                    if trade.source == player or trade.destination == player then
                                                        IcecrownAdTools.db.global.trade[index] = nil
                                                    end
                                                end
                                            
                                                if (self.logWindow) then
                                                    IcecrownTradeLogViewer:SearchTrades(self.logWindow.searchBox:GetText())
                                                end
                                            end
                                            
                                            function IcecrownTradeLogViewer:ClearAllTrades()
                                                for index, trade in pairs(IcecrownAdTools.db.global.trade) do
                                                    IcecrownAdTools.db.global.trade[index] = nil
                                                end
                                                if (self.logWindow) then
                                                    IcecrownTradeLogViewer:SearchTrades(self.logWindow.searchBox:GetText())
                                                end
                                            end
                                            
                                            function IcecrownTradeLogViewer:DrawSearchPane()
                                                local logWindow = self.logWindow
                                                local searchBox = StdUi:Autocomplete(logWindow, 400, 30, "", nil, nil, nil)
                                                StdUi:ApplyPlaceholder(searchBox, "Search", [=[Interface\Common\UI-Searchbox-Icon]=])
                                                searchBox:SetFontSize(16)
                                            
                                                local searchButton = StdUi:Button(logWindow, 80, 30, "Search")
                                            
                                                StdUi:GlueTop(searchBox, logWindow, 10, -40, "LEFT")
                                                StdUi:GlueTop(searchButton, logWindow, 420, -40, "LEFT")
                                            
                                            
                                                searchBox:SetScript("OnEnterPressed", function() IcecrownTradeLogViewer:SearchTrades(searchBox:GetText()) end)
                                                searchButton:SetScript("OnClick", function() IcecrownTradeLogViewer:SearchTrades(searchBox:GetText()) end)
                                            
                                                local allCharactersToggle = StdUi:Checkbox(logWindow, "All characters")
                                                StdUi:GlueRight(allCharactersToggle, searchButton, 10, 0)
                                                allCharactersToggle.OnValueChanged = function(self, state) IcecrownTradeLogViewer:SearchTrades(searchBox:GetText()) end
                                                local allCharactersTooltip = StdUi:FrameTooltip(allCharactersToggle, "Show all trades by any character on this account.", "tooltip", "RIGHT", true)
                                            
                                                local todayToggle = StdUi:Checkbox(logWindow, "Only show today")
                                                StdUi:GlueRight(todayToggle, allCharactersToggle, 10, 0)
                                                todayToggle.OnValueChanged = function(self, state) IcecrownTradeLogViewer:SearchTrades(searchBox:GetText()) end
                                                local todayToggleTooltip = StdUi:FrameTooltip(todayToggle, "Only show trades made today.", "tooltip", "RIGHT", true)
                                            
                                                logWindow.allCharactersToggle = allCharactersToggle
                                                logWindow.todayToggle = todayToggle
                                                logWindow.searchBox = searchBox
                                                logWindow.searchButton = searchButton
                                            end
                                            
                                            function IcecrownTradeLogViewer:DrawSearchResultsTable()
                                                local logWindow = self.logWindow
                                            
                                                local function showTooltip(frame, show, text)
                                                    if show and text ~= nil then
                                                        GameTooltip:SetOwner(frame);
                                                        GameTooltip:SetText(text)
                                                    else
                                                        GameTooltip:Hide();
                                                    end
                                                end
                                            
                                                local cols = {
                                                    {
                                                        name         = "Date",
                                                        width        =  215,
                                                        align        = "MIDDLE",
                                                        index        = "date",
                                                        format       = "string",
                                                        defaultSort  = "asc"
                                                    },
                                                    {
                                                        name         = "Player",
                                                        width        = 100,
                                                        align        = "MIDDLE",
                                                        index        = "player",
                                                        format       = "string",
                                                    },
                                                    {
                                                        name         = "Your Offer (Gold)",
                                                        width        = 100,
                                                        align        = "MIDDLE",
                                                        index        = "playerGold",
                                                        format       = "money",
                                                    },
                                                    {
                                                        name         = "Your Offer (Items)",
                                                        width        = 150,
                                                        align        = "LEFT",
                                                        index        = "playerItems",
                                                        format       = "string",
                                                        events      = {
                                                                         OnEnter = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                                                                            local cellData = rowData[columnData.index];
                                                                            if (rowData.playerItems) then
                                                                                showTooltip(cellFrame, true, rowData.playerItems);
                                                                            end
                                                                            return true;
                                                                        end,
                                                                        OnLeave = function(rowFrame, cellFrame)
                                                                            showTooltip(cellFrame, false);
                                                                            return true;
                                                                        end
                                                                       },
                                                    },
                                                    {
                                                        name         = "Target",
                                                        width        = 100,
                                                        align        = "LEFT",
                                                        index        = "target",
                                                        format       = "string",
                                                    },
                                                    {
                                                        name         = "Target Offer (Gold)",
                                                        width        = 100,
                                                        align        = "MIDDLE",
                                                        index        = "targetGold",
                                                        format       = "money",
                                                    },
                                                    {
                                                        name         = "Target Offer (Items)",
                                                        width        = 150,
                                                        align        = "LEFT",
                                                        index        = "targetItems",
                                                        format       = "string",
                                                        events      = {
                                                                         OnEnter = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                                                                            local cellData = rowData[columnData.index];
                                                                            if (rowData.targetItems) then
                                                                                showTooltip(cellFrame, true, rowData.targetItems);
                                                                            end
                                                                            return true;
                                                                        end,
                                                                        OnLeave = function(rowFrame, cellFrame)
                                                                            showTooltip(cellFrame, false);
                                                                            return true;
                                                                        end
                                                                       },
                                                    },
                                            
                                                }
                                            
                                                logWindow.searchResults = StdUi:ScrollTable(logWindow, cols, 18, 29)
                                                logWindow.searchResults:SetDisplayRows(math.floor(logWindow.searchResults:GetWidth()/logWindow.searchResults:GetHeight()), logWindow.searchResults.rowHeight)
                                                logWindow.searchResults:EnableSelection(true)
                                            
                                                logWindow.searchResults:SetScript("OnSizeChanged", function(self)
                                                    local tableWidth = self:GetWidth();
                                                    local tableHeight = self:GetHeight();
                                            
                                                    -- Determine total width of columns
                                                    local total = 0;
                                                    for i=1, #self.columns do
                                                        total = total + self.columns[i].width;
                                                    end
                                            
                                                    -- Adjust all column widths proportionally
                                                    for i=1, #self.columns do
                                                        self.columns[i]:SetWidth((self.columns[i].width/total)*(tableWidth - 30));
                                                    end
                                            
                                                    -- Set the number of displayed rows according to the new height
                                                    self:SetDisplayRows(math.floor(tableHeight/self.rowHeight), self.rowHeight);
                                                end)
                                            
                                            
                                                StdUi:GlueAcross(logWindow.searchResults, logWindow, 10, -110, -10, 50)
                                            
                                                logWindow.stateLabel = StdUi:Label(logWindow.searchResults, "No results found.")
                                                StdUi:GlueTop(logWindow.stateLabel, logWindow.searchResults, 0, -40, "CENTER")
                                            end
                                            
                                            function IcecrownTradeLogViewer:ApplyDefaultSort(tableToSort)
                                                if (self.logWindow.searchResults.head.columns) then
                                                    local isSorted = false
                                            
                                                    for k,v in pairs(self.logWindow.searchResults.head.columns) do
                                                        if (v.arrow:IsVisible()) then
                                                            isSorted = true
                                                        end
                                                    end
                                            
                                                    if (not isSorted) then
                                                        return table.sort(tableToSort, function(a,b) return a["date"] > b["date"] end)
                                                    end
                                                end
                                            
                                                return tableToSort
                                            end
                                            
                                            function IcecrownTradeLogViewer:UpdateStateText()
                                                if (#self.currentView > 0) then
                                                    self.logWindow.stateLabel:Hide()
                                                else
                                                    self.logWindow.stateLabel:SetText("No results found.")
                                                end
                                            end
                                            
                                            function IcecrownTradeLogViewer:UpdateResultsText()
                                                if (#self.currentView > 0) then
                                                    self.logWindow.resultsLabel:SetText("Current results: " .. tostring(#self.currentView))
                                                    self.logWindow.resultsLabel:Show()
                                                else
                                                    self.logWindow.resultsLabel:Hide()
                                                end
                                            end
                                            
                                            function IcecrownTradeLogViewer:EnsureFullName(name)
                                                    if (not name:find("-")) then
                                                    name = name .. "-" .. select(2, UnitFullName("player"))
                                                end
                                            
                                                return name
                                            end
                                            
                                            function IcecrownTradeLogViewer:Finish()
                                                self.pendingTradeContents = {}
                                                self.targetName = ""
                                            end