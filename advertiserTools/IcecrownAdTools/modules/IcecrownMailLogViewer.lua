local IcecrownAdTools = LibStub("AceAddon-3.0"):GetAddon("IcecrownAdTools")
local IcecrownMailLogViewer = IcecrownAdTools:NewModule("IcecrownMailLogViewer", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")
local StdUi = LibStub("StdUi")

function IcecrownMailLogViewer:OnEnable()
  self.configDB = IcecrownAdTools.db.char
  self:RegisterEvent("MAIL_SUCCESS", "OnEvent")
  self:RegisterEvent("MAIL_INBOX_UPDATE", "OnEvent")
end

function IcecrownMailLogViewer:OpenPanel()
    if (self.logWindow == nil) then
        self:DrawWindow()
        self:DrawSearchPane()
        self:DrawSearchResultsTable()
        self:SearchMail("")
    else
        self.logWindow:Show()
        self:SearchMail("")
    end
end

function IcecrownMailLogViewer:Toggle()
    if not self.logWindow then
        IcecrownMailLogViewer:OpenPanel()
    elseif self.logWindow:IsVisible() then
        self.logWindow:Hide()
    else
        self.logWindow:Show()
    end
end

-- Expensive and brute-force, but does the job. If literally any field contains the filter, return it in the result set.
function IcecrownMailLogViewer:SearchMail(filter)
   local logWindow = self.logWindow
   local searchFilter = filter:lower()
   local allResults = IcecrownAdTools.db.global.mail
   local filteredResults = {}
   local name, realm = UnitFullName("player")
   local player =  name .. "-" .. realm
   local allCharactersToggled = logWindow.allCharactersToggle:GetChecked()
   local todayToggled = logWindow.todayToggle:GetChecked()
   local date = date("%Y-%m-%d")
   for _,mail in pairs(allResults) do
        if ((allCharactersToggled or ((mail.source and mail.source:lower():find(player:lower(), 1, true)) or (mail.destination and mail.destination:lower():find(player:lower(), 1, true))) ~= nil)
           and (mail.date and (not todayToggled or (string.sub(mail.date, 1, 10) == date)))
           and (mail.subject and (mail.subject:lower():find(searchFilter, 1, true))
           or (mail.body and mail.body:lower():find(searchFilter, 1, true))
           or (mail.gold and tostring(floor(mail.gold / COPPER_PER_GOLD)):find(searchFilter, 1, true))
           or (mail.source and mail.source:lower():find(searchFilter, 1, true))
           or (mail.destination and mail.destination:lower():find(searchFilter, 1, true))
           or (mail.date and mail.date:lower():find(searchFilter, 1, true))
           or searchFilter == "sent" and mail.sent
           or searchFilter == "received" and not mail.sent)) then
               table.insert(filteredResults, mail)
        end
    end

    -- TODO: This really should not be necessary, but I can't figure out how to get StdUi to sort our primary column by desc by default...
    IcecrownMailLogViewer:ApplyDefaultSort(filteredResults)

    self.currentView = filteredResults
    self.logWindow.searchResults:SetData(self.currentView, true)
    IcecrownMailLogViewer:UpdateStateText()
    IcecrownMailLogViewer:UpdateResultsText()
end

function IcecrownMailLogViewer:DrawWindow()
    local logWindow
    if (self.configDB.logWindowSize ~= nil) then
        logWindow = StdUi:Window(UIParent, self.configDB.logWindowSize.width, self.configDB.logWindowSize.height, "Icecrown Mail Log Viewer")
    else
        logWindow = StdUi:Window(UIParent, 1100, 700, "Icecrown Mail Log Viewer")
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
        IcecrownMailLogViewer.configDB.logWindowSize = {width=self:GetWidth(), height=self:GetHeight()}
    end)

    logWindow:SetScript('OnDragStop', function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, xOfs, yOfs = self:GetPoint()
        IcecrownMailLogViewer.configDB.logWindowPosition = {point=point, relPoint=relPoint, relX=xOfs, relY=yOfs}
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

    clearButton:SetScript("OnClick", function() IcecrownMailLogViewer:DrawClearWarningWindow() end)


    self.logWindow = logWindow
end

function IcecrownMailLogViewer:DrawClearWarningWindow()
    local buttons = {
                        character = {
                                text = "This Character",
                                onClick = function(b)
                                            IcecrownMailLogViewer:ClearMailForCharacter()
                                            b.window:Hide()
                                          end
                        },
                        all       = {
                                text = "All Mail",
                                onClick = function(b)
                                            IcecrownMailLogViewer:ClearAllMail()
                                            b.window:Hide()
                                          end
                        },
                    }

    StdUi:Confirm("Clear Log", "Select log to clear. These actions CANNOT BE REVERSED. Both sent and received mail will be deleted.", buttons, 1)
end

function IcecrownMailLogViewer:ClearMailForCharacter()
    local name, realm = UnitFullName("player")
    local player =  name .. "-" .. realm
    for index, mail in pairs(IcecrownAdTools.db.global.mail) do
        if mail.source == player or mail.destination == player then
            IcecrownAdTools.db.global.mail[index] = nil
        end
    end

    if (self.logWindow) then
        IcecrownMailLogViewer:SearchMail(self.logWindow.searchBox:GetText())
    end
end

function IcecrownMailLogViewer:ClearAllMail()
    for index, mail in pairs(IcecrownAdTools.db.global.mail) do
        IcecrownAdTools.db.global.mail[index] = nil
    end
    if (self.logWindow) then
        IcecrownMailLogViewer:SearchMail(self.logWindow.searchBox:GetText())
    end
end

function IcecrownMailLogViewer:DrawSearchPane()
    local logWindow = self.logWindow
    local searchBox = StdUi:Autocomplete(logWindow, 400, 30, "", nil, nil, nil)
    StdUi:ApplyPlaceholder(searchBox, "Search", [=[Interface\Common\UI-Searchbox-Icon]=])
    searchBox:SetFontSize(16)

    local searchButton = StdUi:Button(logWindow, 80, 30, "Search")

    StdUi:GlueTop(searchBox, logWindow, 10, -40, "LEFT")
    StdUi:GlueTop(searchButton, logWindow, 420, -40, "LEFT")


    searchBox:SetScript("OnEnterPressed", function() IcecrownMailLogViewer:SearchMail(searchBox:GetText()) end)
    searchButton:SetScript("OnClick", function() IcecrownMailLogViewer:SearchMail(searchBox:GetText()) end)

    local allCharactersToggle = StdUi:Checkbox(logWindow, "All characters")
    StdUi:GlueRight(allCharactersToggle, searchButton, 10, 0)
    allCharactersToggle.OnValueChanged = function(self, state) IcecrownMailLogViewer:SearchMail(searchBox:GetText()) end
    local allCharactersTooltip = StdUi:FrameTooltip(allCharactersToggle, "Show all mail received by any character on this account.", "tooltip", "RIGHT", true)

    local todayToggle = StdUi:Checkbox(logWindow, "Only show today")
    StdUi:GlueRight(todayToggle, allCharactersToggle, 10, 0)
    todayToggle.OnValueChanged = function(self, state) IcecrownMailLogViewer:SearchMail(searchBox:GetText()) end
    local todayToggleTooltip = StdUi:FrameTooltip(todayToggle, "Only show mail that was received or sent today.", "tooltip", "RIGHT", true)

    logWindow.allCharactersToggle = allCharactersToggle
    logWindow.todayToggle = todayToggle
    logWindow.searchBox = searchBox
    logWindow.searchButton = searchButton
end

function IcecrownMailLogViewer:DrawSearchResultsTable()
    local logWindow = self.logWindow

    local function showTooltip(frame, show, text)
        if show then
            GameTooltip:SetOwner(frame);
            GameTooltip:SetText(text)
        else
            GameTooltip:Hide();
        end
    end

    local cols = {
        {
            name         = "Date Sent",
            width        =  225,
            align        = "MIDDLE",
            index        = "date",
            format       = "string",
            defaultSort  = "asc"
                    },
                    {
                        name         = "Sender",
                        width        = 150,
                        align        = "MIDDLE",
                        index        = "source",
                        format       = "string",
                    },
                    {
                        name         = "Recipient",
                        width        = 150,
                        align        = "MIDDLE",
                        index        = "destination",
                        format       = "string",
                    },
                    {
                        name         = "Gold",
                        width        = 100,
                        align        = "LEFT",
                        index        = "gold",
                        format       = "money",
                    },
                    {
                        name         = "Subject",
                        width        = 150,
                        align        = "LEFT",
                        index        = "subject",
                        format       = "string",
                    },
                   --[[ {
                        name         = "Sent/Received",
                        width        = 75,
                        align        = "CENTER",
                        index        = "sent",
                        sortable     = false,
                        format       = function (value, rowData, columnData)
                                            if (value) then
                                               return "Sent"
                                            else
                                               return "Received"
                                            end
                                        end
                    },
                    
                    {
                        name         = "Date Looted",
                        width        = 150,
                        align        = "MIDDLE",
                        index        = "openedDate",
                        format       = "string",
                        compareSort  = function(self, rowA, rowB, sortBy)
                                            local a = self:GetRow(rowA);
                                            local b = self:GetRow(rowB);
                                            local column = self.columns[sortBy];
                                            local idx = column.index;
            
                                            local direction = column.sort or column.defaultSort or 'asc';
                                            if direction:lower() == 'asc' then
                                                return (a[idx] or "") > (b[idx] or "");
                                            else
                                                return (a[idx] or "") < (b[idx] or "");
                                            end
                                       end
                    },
                    
                    {
                        name         = "Code",
                        width        = 100,
                        align        = "LEFT",
                        index        = "code",
                        format       = "string",
                        compareSort  = function(self, rowA, rowB, sortBy)
                                            local a = self:GetRow(rowA);
                                            local b = self:GetRow(rowB);
                                            local column = self.columns[sortBy];
                                            local idx = column.index;
            
                                            local direction = column.sort or column.defaultSort or 'asc';
                                            if direction:lower() == 'asc' then
                                                return (a[idx] or "") > (b[idx] or "");
                                            else
                                                return (a[idx] or "") < (b[idx] or "");
                                            end
                                       end
                    },]]
                    {
                        name         = "Body",
                        width        = 150,
                        align        = "LEFT",
                        index        = "body",
                        format       = "string",
                        events       = {
                                         OnEnter = function(table, cellFrame, rowFrame, rowData, columnData, rowIndex)
                                            local cellData = rowData[columnData.index];
                                            if (rowData.body) then
                                                showTooltip(cellFrame, true, rowData.body);
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
                logWindow.searchResults:EnableSelection(true)
                logWindow.searchResults:SetDisplayRows(math.floor(logWindow.searchResults:GetWidth()/logWindow.searchResults:GetHeight()), logWindow.searchResults.rowHeight)
            
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
            
            function IcecrownMailLogViewer:ApplyDefaultSort(tableToSort)
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
            
            function IcecrownMailLogViewer:UpdateStateText()
                if (#self.currentView > 0) then
                    self.logWindow.stateLabel:Hide()
                else
                    self.logWindow.stateLabel:SetText("No results found.")
                end
            end
            
            function IcecrownMailLogViewer:UpdateResultsText()
                if (#self.currentView > 0) then
                    self.logWindow.resultsLabel:SetText("Current results: " .. tostring(#self.currentView))
                    self.logWindow.resultsLabel:Show()
                else
                    self.logWindow.resultsLabel:Hide()
                end
            end
            
            -- Bit lazy, but it allows the mail log to update in "real time"
            function IcecrownMailLogViewer:OnEvent(event)
                if (self.logWindow) then
                    C_Timer.After(1, function() IcecrownMailLogViewer:SearchMail(self.logWindow.searchBox:GetText()) end)
                end
            end