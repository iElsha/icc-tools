local IcecrownAdTools = LibStub("AceAddon-3.0"):GetAddon("IcecrownAdTools")
local IcecrownBuyerEncryptor = IcecrownAdTools:NewModule("IcecrownBuyerEncryptor", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0", "AceTimer-3.0")

local ns = ...

-- session
local uiHooks = {}

-- defined constants
local FACTION
do
 FACTION = {
  ["Alliance"] = 1,
  ["Horde"] = 2,
 }
end

-- create the addon core frame
local addon = CreateFrame("Frame")

local function encode(name)
 local encodedName = ""
 local collectedNums
 for count = 1, #name do
  local num = string.byte(name,count)+3
  if num > 125 then
   encodedName = encodedName .. string.utf8sub(name, count, count)
  else
   encodedName = encodedName .. string.char(num)  
  end
  encodedName = encodedName .. string.char(math.random(65, 122))  
 end
 return encodedName
end

-- addon events
do
 -- apply hooks to interface elements
 local function ApplyHooks()
  -- iterate backwards, removing hooks as they complete
  for i = #uiHooks, 1, -1 do
   local func = uiHooks[i]
   -- if the function returns true our hook succeeded, we then remove it from the table
   if func() then
    table.remove(uiHooks, i)
   end
  end
 end

 -- an addon has loaded
 function addon:ADDON_LOADED(event, name)
  -- apply hooks to interface elements
  ApplyHooks()
 end
end

-- ui hooks
do
 -- extract character name and realm from BNet friend
 local function GetNameAndRealmForBNetFriend(bnetIDAccount)
  local index = BNGetFriendIndex(bnetIDAccount)
  if index then
   local numGameAccounts = BNGetNumFriendGameAccounts(index)
   for i = 1, numGameAccounts do
    local _, characterName, client, realmName, _, faction, _, _, _, _, level = BNGetFriendGameAccountInfo(index, i)
    if client == BNET_CLIENT_WOW then
     if realmName then
      characterName = characterName .. "-" .. realmName:gsub("%s+", "")
     end
     return characterName, FACTION[faction], tonumber(level)
    end
   end
  end
 end
 
  -- returns the name, realm and possibly unit
 function GetNameAndRealm(arg1, arg2)
  local name, realm, unit
  if UnitExists(arg1) then
   unit = arg1
   if UnitIsPlayer(arg1) then
    name, realm = UnitName(arg1)
    realm = realm and realm ~= "" and realm or GetNormalizedRealmName()
   end
  elseif type(arg1) == "string" and arg1 ~= "" then
   if arg1:find("-", nil, true) then
    name, realm = ("-"):split(arg1)
   else
    name = arg1 -- assume this is the name
   end
   if not realm or realm == "" then
    if type(arg2) == "string" and arg2 ~= "" then
     realm = arg2
    else
     realm = GetNormalizedRealmName() -- assume they are on our realm
    end
   end
  end
  return name, realm, unit
 end
 

 -- copy profile link from dropdown menu
 local function CopyURLForNameAndRealm(...)
  local name, realm = GetNameAndRealm(...)
  local encodedName = encode(format("%s-%s", name, realm))
  if IsModifiedClick("CHATLINK") then
   local editBox = ChatFrame_OpenChat("Test 2", DEFAULT_CHAT_FRAME)
   editBox:HighlightText()
  else
   StaticPopup_Show("ENCRYPTED_BUYER_COPY", format("%s-%s", name, realm), encodedName)
  end
 end

 _G.StaticPopupDialogs["ENCRYPTED_BUYER_COPY"] = {
  text = "%s",
  button2 = CLOSE,
  hasEditBox = true,
  hasWideEditBox = true,
  editBoxWidth = 350,
  preferredIndex = 3,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  OnShow = function(self)
   self:SetWidth(420)
   local editBox = _G[self:GetName() .. "WideEditBox"] or _G[self:GetName() .. "EditBox"]
   editBox:SetText(self.text.text_arg2)
   editBox:SetFocus()
   editBox:HighlightText(false)
   local button = _G[self:GetName() .. "Button2"]
   button:ClearAllPoints()
   button:SetWidth(200)
   button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
  end,
  EditBoxOnEscapePressed = function(self)
   self:GetParent():Hide()
  end,
  OnHide = nil,
  OnAccept = nil,
  OnCancel = nil
 }

 -- DropDownMenu (Units and LFD)
 uiHooks[#uiHooks + 1] = function()
  local function IsUnitMaxLevel(unit, fallback)
   if UnitExists(unit) and UnitIsPlayer(unit) then
    local level = UnitLevel(unit)
    if level then
     return level >= 120
    end
   end
   return fallback
  end
  local function CanCopyURL(which, unit, name, bnetIDAccount)
   if UnitExists(unit) then
    return UnitIsPlayer(unit),
     GetUnitName(unit, true) or name,
     "UNIT"
   elseif which and which:find("^BN_") then
    local charName, charFaction, charLevel
    if bnetIDAccount then
     charName, charFaction, charLevel = GetNameAndRealmForBNetFriend(bnetIDAccount)
    end
    return charName and charLevel,
     bnetIDAccount,
     "BN",
     charName,
     charFaction
   elseif name then
    return true,
     name,
     "NAME"
   end
   return false
  end
  local function ShowCopyURLPopup(kind, query, bnetChar, bnetFaction)
   CopyURLForNameAndRealm(bnetChar or query)
  end
  -- TODO: figure out the type of menus we don't really need to show our copy link button
  local supportedTypes = {
   -- SELF = 1, -- do we really need this? can always target self anywhere else and copy our own url
   PARTY = 1,
   PLAYER = 1,
   RAID_PLAYER = 1,
   RAID = 1,
   FRIEND = 1,
   BN_FRIEND = 1,
   GUILD = 1,
   GUILD_OFFLINE = 1,
   CHAT_ROSTER = 1,
   TARGET = 1,
   ARENAENEMY = 1,
   FOCUS = 1,
   WORLD_STATE_SCORE = 1,
   COMMUNITIES_WOW_MEMBER = 1,
   COMMUNITIES_GUILD_MEMBER = 1,
   SELF = 1
  }
  local OFFSET_BETWEEN = -5 -- default UI makes this offset look nice
  local reskinDropDownList
  do
   local addons = {
    { -- Aurora
     name = "Aurora",
     func = function(list)
      local F = _G.Aurora[1]
      local menu = _G[list:GetName() .. "MenuBackdrop"]
      local backdrop = _G[list:GetName() .. "Backdrop"]
      if not backdrop.reskinned then
       F.CreateBD(menu)
       F.CreateBD(backdrop)
       backdrop.reskinned = true
      end
      OFFSET_BETWEEN = -1 -- need no gaps so the frames align with this addon
      return 1
     end
    },
   }
   local skinned = {}
   function reskinDropDownList(list)
    if skinned[list] then
     return skinned[list]
    end
    for i = 1, #addons do
     local addon = addons[i]
     if IsAddOnLoaded(addon.name) then
      skinned[list] = addon.func(list)
      break
     end
    end
   end
  end
  local custom
  local function CustomOnShow(self) -- UIDropDownMenuTemplates.xml#257
   local p = self:GetParent() or self
   local w = p:GetWidth()
   local h = 32
   for i = 1, #self.buttons do
    local b = self.buttons[i]
    if b:IsShown() then
     b:SetWidth(w - 32) -- anchor offsets for left/right
     h = h + 16
    end
   end
   self:SetHeight(h)
   return h
  end
  do
   local function CopyOnClick()
    ShowCopyURLPopup(custom.kind, custom.query, custom.bnetChar, custom.bnetFaction)
    CloseDropDownMenus()
   end
   local function UpdateCopyButton()
    local copy = custom.copy
    local copyName = copy:GetName()
    local text = _G[copyName .. "NormalText"]
    text:SetText("Copy Encrypted Name")
    text:Show()
    copy:SetScript("OnClick", CopyOnClick)
    copy:Show()
   end
   local function CustomOnShow(self) -- UIDropDownMenuTemplates.xml#257
    local p = self:GetParent() or self
    local w = p:GetWidth()
    local h = 32
    for i = 1, #self.buttons do
     local b = self.buttons[i]
     if b:IsShown() then
      b:SetWidth(w - 32) -- anchor offsets for left/right
      h = h + 16
     end
    end
    self:SetHeight(h)
   end
   local function CustomButtonOnEnter(self) -- UIDropDownMenuTemplates.xml#155
    _G[self:GetName() .. "Highlight"]:Show()
   end
   local function CustomButtonOnLeave(self) -- UIDropDownMenuTemplates.xml#178
    _G[self:GetName() .. "Highlight"]:Hide()
   end
   custom = CreateFrame("Button", "gwixTools _CustomDropDownList", UIParent, "UIDropDownListTemplate")
   custom:Hide()
   -- attempt to reskin using popular frameworks
   -- skinType = nil : not skinned
   -- skinType = 1 : skinned, apply further visual modifications (the addon does a good job, but we need to iron out some issues)
   -- skinType = 2 : skinned, no need to apply further visual modifications (the addon handles it flawlessly)
   local skinType = reskinDropDownList(custom)
   -- cleanup and modify the default template
   do
    custom:SetScript("OnClick", nil)
    custom:SetScript("OnUpdate", nil)
    custom:SetScript("OnShow", CustomOnShow)
    custom:SetScript("OnHide", nil)
    _G[custom:GetName() .. "Backdrop"]:Hide()
    custom.buttons = {}
    for i = 1, UIDROPDOWNMENU_MAXBUTTONS do
     local b = _G[custom:GetName() .. "Button" .. i]
     if not b then
      break
     end
     custom.buttons[i] = b
     b:Hide()
     b:SetScript("OnClick", nil)
     b:SetScript("OnEnter", CustomButtonOnEnter)
     b:SetScript("OnLeave", CustomButtonOnLeave)
     b:SetScript("OnEnable", nil)
     b:SetScript("OnDisable", nil)
     b:SetPoint("TOPLEFT", custom, "TOPLEFT", 16, -16 * i)
     local t = _G[b:GetName() .. "NormalText"]
     t:ClearAllPoints()
     t:SetPoint("TOPLEFT", b, "TOPLEFT", 0, 0)
     t:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 0, 0)
     _G[b:GetName() .. "Check"]:SetAlpha(0)
     _G[b:GetName() .. "UnCheck"]:SetAlpha(0)
     _G[b:GetName() .. "Icon"]:SetAlpha(0)
     _G[b:GetName() .. "ColorSwatch"]:SetAlpha(0)
     _G[b:GetName() .. "ExpandArrow"]:SetAlpha(0)
     _G[b:GetName() .. "InvisibleButton"]:SetAlpha(0)
    end
    custom.copy = custom.buttons[1]
    UpdateCopyButton()
   end
  end
  local function ShowCustomDropDown(list, dropdown, name, unit, which, bnetIDAccount)
   local show, query, kind, bnetChar, bnetFaction = CanCopyURL(which, unit, name, bnetIDAccount)
   if not show then
    return custom:Hide()
   end
   -- assign data for use with the copy function
   custom.query = query
   custom.kind = kind
   custom.bnetChar = bnetChar
   custom.bnetFaction = bnetFaction
   -- set positioning under the active dropdown
   custom:SetParent(list)
   custom:SetFrameStrata(list:GetFrameStrata())
   custom:SetFrameLevel(list:GetFrameLevel() + 2)
   custom:ClearAllPoints()
   local dw, dh = list:GetSize()
   local cw, ch = custom:GetSize()
   cw = dw
   if ch < 1 then
    ch = CustomOnShow(custom)
   end
   
   if IsAddOnLoaded('RaiderIO') and IsUnitMaxLevel(unit, true) then
    custom:SetPoint("BOTTOMLEFT", list, "BOTTOMLEFT", 0, 50)
    custom:SetPoint("BOTTOMRIGHT", list, "BOTTOMRIGHT", 0, 50)
   else
    custom:SetPoint("BOTTOMLEFT", list, "BOTTOMLEFT", 0, 0)
    custom:SetPoint("BOTTOMRIGHT", list, "BOTTOMRIGHT", 0, 0)
   end
   
   list:SetHeight(dh + ch + OFFSET_BETWEEN)
   custom:Show()
  end
  local function HideCustomDropDown()
   custom:Hide()
  end
  local function OnShow(self)
   local dropdown = self.dropdown
   if not dropdown then
    return
   end
   if dropdown.Button == _G.LFGListFrameDropDownButton then -- LFD
    
     ShowCustomDropDown(self, dropdown, dropdown.menuList[2].arg1)
   elseif dropdown.which and supportedTypes[dropdown.which] then -- UnitPopup
   
     local dropdownFullName
     if dropdown.name then
      if dropdown.server and not dropdown.name:find("-") then
       dropdownFullName = dropdown.name .. "-" .. dropdown.server
      else
       dropdownFullName = dropdown.name
      end
     end
     ShowCustomDropDown(self, dropdown, dropdown.chatTarget or dropdownFullName, dropdown.unit, dropdown.which, dropdown.bnetIDAccount)
   
   end
  end
  local function OnHide()
   HideCustomDropDown()
  end
  DropDownList1:HookScript("OnShow", OnShow)
  DropDownList1:HookScript("OnHide", OnHide)
  return 1
 end
end

-- register events and wait for the addon load event to fire
addon:SetScript("OnEvent", function(_, event, ...) addon[event](addon, event, ...) end)
addon:RegisterEvent("ADDON_LOADED")