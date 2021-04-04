-- **************************************************************************
-- * Titan Raid Lockout
-- *
-- * By: Gamut - Nethergarde Keep EU
-- **************************************************************************

-- TODO for v.1.0.4:
-- Implement SavedVariables
---- Save test variable
------ Save by calling _G["SavedLockoutTable"] = ...
---- Load test variable
------ Load by calling ... = _G["SavedLockoutTable"]
-- Implement saving current characters lockout info upon event trigger
---- Save this in the most proper way for loading
-- Implement loading other characters lockout info upon 
---- Display this in tooltip

local addonName, addonTable = ...
local _G = getfenv()

-- Constants
local TITAN_RAIDLOCKOUT_ID = addonName
local VERSION = GetAddOnMetadata(GetAddOnInfo(TITAN_RAIDLOCKOUT_ID), "Version")
local COLOR = {
    ["white"] = "|cFFFFFFFF",
    ["grey"] = "|cFFA9A9A9",
    ["red"] = "|cFFDE1010",
    ["green"] = GREEN_FONT_COLOR_CODE,
    ["yellow"] = "|cFFFFF244",
}
local PLAYER_NAME = UnitName("player")
local PLAYER_REALM = GetRealmName()
local PLAYER_NAME_AT_REALM = PLAYER_NAME .. "@" .. PLAYER_REALM

local L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)

-- **************************************************************************
--  Addon setup and Titan Panel integration
-- **************************************************************************

function TRaidLockout_Init()
    if (myAddOnsFrame_Register) then
		myAddOnsFrame_Register( {name=TITAN_RAIDLOCKOUT_ID,version=VERSION,category=MYADDONS_CATEGORY_PLUGINS} )
    end
end

function TRaidLockout_OnLoad(self)    
    self.registry = {
        id = TITAN_RAIDLOCKOUT_ID,
        menuText = "Raid Lockout",
        buttonTextFunction = "TRaidLockout_GetButtonText",
        tooltipTitle = "Raid Lockout",
        tooltipTextFunction = "TRaidLockout_GetTooltip",
        icon = "Interface\\Icons\\inv_misc_head_dragon_bronze",
        iconWidth = 16,
        iconButtonWidth = 16,
        category = "Information",
        version = VERSION,
        savedVariables = { -- Global for TitanPanel saves into "WTF/Account/[AccountName]/SavedVariables/TitanClassic.lua"
            ShowTooltipHeader = true,
            ShowUnlockedButton = false,
            ShowUnlockedTooltip = false,
            ShowIcon = true,
            ShowColoredText = true,
            ShowLabelText = true,
        }
    }
    self:RegisterEvent("ADDON_LOADED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD") 
    self:RegisterEvent("UPDATE_INSTANCE_INFO")
end

function TRaidLockout_OnEvent(self, event, ...)
    if (event == "ADDON_LOADED") then
        TRaidLockout_Init()
        TRaidLockout_SetupSavedVariableTemplate()
    elseif (event == "UPDATE_INSTANCE_INFO") then
        TRaidLockout_GetButtonText()
        TitanPanelPluginHandle_OnUpdate({TITAN_RAIDLOCKOUT_ID, 1})
    elseif (event == "PLAYER_ENTERING_WORLD") then
        TRaidLockout_GetButtonText()
        TitanPanelPluginHandle_OnUpdate({TITAN_RAIDLOCKOUT_ID, 1})
    end
end

function TRaidLockout_SetupSavedVariableTemplate()
    if _G["SavedLockoutTable"] == nil or _G["SavedLockoutTable"]["Players"] == nil then
        _G["SavedLockoutTable"] = {
            ["Players"] = {}
        }
    end
    if _G["SavedLockoutTable"]["Players"][PLAYER_NAME_AT_REALM] == nil then
        _G["SavedLockoutTable"]["Players"][PLAYER_NAME_AT_REALM] = {}
    end
end

function TRaidLockout_GetButtonText()
    TRaidLockout_SetButtonText()
    return buttonLabel, buttonText
end

function TRaidLockout_GetTooltip()
    TRaidLockout_SetTooltip()
    return tooltipText
end

function TRaidLockoutButton_OnClick(self, button)
    if button == "LeftButton" then
        ToggleFriendsFrame(4)
        RaidInfoFrame:Show()
    end
end

function TitanPanelRightClickMenu_PrepareTitanRaidLockoutMenu()
    TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_RAIDLOCKOUT_ID].menuText);
    TitanPanelRightClickMenu_AddToggleVar(L["Tooltip Legend"], TITAN_RAIDLOCKOUT_ID, "ShowTooltipHeader")
    TitanPanelRightClickMenu_AddToggleVar(L["Panel - Show all instances"], TITAN_RAIDLOCKOUT_ID, "ShowUnlockedButton")
    TitanPanelRightClickMenu_AddSpacer();
    TitanPanelRightClickMenu_AddToggleIcon(TITAN_RAIDLOCKOUT_ID);
    TitanPanelRightClickMenu_AddToggleColoredText(TITAN_RAIDLOCKOUT_ID)
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_RAIDLOCKOUT_ID)
    TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_RAIDLOCKOUT_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

-- **************************************************************************
--  _SetButtonText()
-- **************************************************************************
function TRaidLockout_SetButtonText()
        
    local localizedRaidName = {
        ["ONY"] = GetRealZoneText(249),
        ["ZG"] = GetRealZoneText(309),
        ["MC"] = GetRealZoneText(409),
        ["BWL"] = GetRealZoneText(469),
        ["AQ20"] = GetRealZoneText(509),
        ["AQ40"] = GetRealZoneText(531),
        ["NAXX"] = GetRealZoneText(533),
    }
    local numSaved = GetNumSavedInstances()
    local coloredText = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowColoredText")
    local showUnlocked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowUnlockedButton")
    buttonLabel = L["Lockout: "]
    buttonText = TitanUtils_Ternary(coloredText, COLOR.red, COLOR.white)
    
    local raidsTable = { 
        -- key, subTable{ localized abbr, is locked }
        ["ZG"] = { L["ZG"], false },
        ["MC"] = { L["MC"], false },
        ["BWL"] = { L["BWL"], false },
        ["ONY"] = { L["ONY"], false },
        ["AQ20"] = { L["AQ20"], false },
        ["AQ40"] = { L["AQ40"], false },
        ["NAXX"] = { L["NAXX"], false },
    }
        
    if showUnlocked then -- Show green abbr
        
        if numSaved > 0 then
            for savedIndex = 1, numSaved do
                local name = GetSavedInstanceInfo(savedIndex)
                
                for key, subTable in pairs(raidsTable) do
                    if name == localizedRaidName[key] then
                        buttonText = buttonText .. " " .. subTable[1]
                        subTable[2] = true
                        _G["SavedLockoutTable"]["Players"][PLAYER_NAME_AT_REALM]["LockedTable"][key] = true
                    else
                        _G["SavedLockoutTable"]["Players"][PLAYER_NAME_AT_REALM]["LockedTable"][key] = nil
                    end
                end
            end
            _G["SavedLockoutTable"]["Players"][PLAYER_NAME_AT_REALM]["IsAnyLocked"] = true
        end
        
        buttonText = buttonText .. TitanUtils_Ternary(coloredText, COLOR.green, " |") 
        
        for index, subTable in pairs(raidsTable) do
            if not subTable[2] then buttonText = buttonText .. " " .. subTable[1] end 
        end
    
    else -- Don't show green abbr
        if numSaved > 0 then
            for savedIndex = 1, numSaved do
                local name = GetSavedInstanceInfo(savedIndex)
                
                for key, subTable in pairs(raidsTable) do 
                    if name == localizedRaidName[key] then 
                        buttonText = buttonText .. " " .. subTable[1]
                        _G["SavedLockoutTable"]["Players"][PLAYER_NAME_AT_REALM]["LockedTable"][key] = true
                    else
                        _G["SavedLockoutTable"]["Players"][PLAYER_NAME_AT_REALM]["LockedTable"][key] = nil
                    end 
                end
            end
            _G["SavedLockoutTable"]["Players"][PLAYER_NAME_AT_REALM]["IsAnyLocked"] = true
        end
    end
        
end

-- **************************************************************************
--  _SetTooltip()
-- **************************************************************************
function TRaidLockout_SetTooltip()
             
	tooltipText = ""
    local numSaved = GetNumSavedInstances()
    local showHeader = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowTooltipHeader")
    local headerText = ""
    
    if showHeader then
        headerText = headerText .. COLOR.grey .. L["Instance Name [Bosses]"] .. "\t" .. COLOR.grey .. L["Reset Time"] .. "\n"
    end
        
    tooltipText = tooltipText .. headerText
    
    if numSaved < 1 then
        
        tooltipText = tooltipText .. COLOR.green .. L["All raid instances are unlocked"]
        
    else
        for savedIndex = 1, numSaved do

            local name, _, reset, _, _, _, _, _, _, _, numEncounters, encounterProgress, _ = GetSavedInstanceInfo(savedIndex)
            
            local timeToReset = reset + time()
            local dateTable = date("*t", timeToReset)
            dateTable["min"] = 0
            local dateToReset = date("%a %d/%m %H:%M", time(dateTable))

            local progress = ""

            if ( encounterProgress < numEncounters ) then
                progress = progress .. COLOR.green .. encounterProgress
            else
                progress = progress .. COLOR.yellow .. encounterProgress
            end

            tooltipText = tooltipText .. COLOR.red .. name .. COLOR.white .. " [" .. progress .. COLOR.yellow .. "/" .. numEncounters .. COLOR.white .. "]" .. COLOR.yellow .. " \t " .. dateToReset .. "\n"
            
            dateToReset = nil

        end
    end
    
end