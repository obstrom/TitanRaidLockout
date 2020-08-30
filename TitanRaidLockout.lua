-- **************************************************************************
-- * Titan Raid Lockout
-- *
-- * By: Gamut - Nethergarde Keep EU
-- **************************************************************************

-- Constants
local L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)
local TITAN_RAIDLOCKOUT_ID = "TitanRaidLockout"
local VERSION = GetAddOnMetadata(GetAddOnInfo("name"), "Version")
local COLOR = {
    ["white"] = "|cFFFFFFFF"
    ["grey"] = "|cFFA9A9A9"
    ["red"] = "|cFFDE1010"
    ["green"] = GREEN_FONT_COLOR_CODE
    ["yellow"] = "|cFFFFF244"
}

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
        savedVariables = {
            ShowTooltipHeader = true,
            ShowUnlockedButton = false,
            ShowUnlockedTooltip = false,
            ShowIcon = true,
            ShowColoredText = true,
            ShowLabelText = true,
        }
    };
    self:RegisterEvent("VARIABLES_LOADED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD") 
    self:RegisterEvent("UPDATE_INSTANCE_INFO")
end

function TRaidLockout_OnEvent(self, event, ...)
    if (event == "VARIABLES_LOADED") then
		TRaidLockout_Init();
    elseif (event == "UPDATE_INSTANCE_INFO") then
        initTime = time()+20
        TRaidLockout_GetButtonText()
        TitanPanelPluginHandle_OnUpdate({TITAN_RAIDLOCKOUT_ID, 1})
    elseif (event == "PLAYER_ENTERING_WORLD") then
        initTime = time()+20
        TRaidLockout_GetButtonText()
        TitanPanelPluginHandle_OnUpdate({TITAN_RAIDLOCKOUT_ID, 1})
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

--[[function TRaidLockout_OnClick(self, button)
    -- Find a way to open raid info panel - like /raidinfo
end]]--

function TitanPanelRightClickMenu_PrepareTitanRaidLockoutMenu()
    TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_RAIDLOCKOUT_ID].menuText);
    TitanPanelRightClickMenu_AddToggleVar("Tooltip Legend", TITAN_RAIDLOCKOUT_ID, "ShowTooltipHeader")
    TitanPanelRightClickMenu_AddToggleVar("Panel - Show all instances", TITAN_RAIDLOCKOUT_ID, "ShowUnlockedButton")
    TitanPanelRightClickMenu_AddSpacer();
    TitanPanelRightClickMenu_AddToggleVar("Show Icon", TITAN_RAIDLOCKOUT_ID, "ShowIcon")
    TitanPanelRightClickMenu_AddToggleColoredText(TITAN_RAIDLOCKOUT_ID)
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_RAIDLOCKOUT_ID)
    TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_RAIDLOCKOUT_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

-- **************************************************************************
--  _SetButtonText()
-- **************************************************************************
function TRaidLockout_SetButtonText()
    
    local numSaved = GetNumSavedInstances()
    
    local coloredText = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowColoredText")
    local showUnlocked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowUnlockedButton")
    buttonLabel = "Lockout: "
    
    if coloredText then
        textColor = COLOR.red
    else
        textColor = COLOR.white
    end
    
    buttonText = textColor
    
    if showUnlocked then
        
        local raidsTable = {
            ["ZG"] = L["Zul'Gurub"],
            ["MC"] = L["Molten Core"],
            ["BWL"] = L["Blackwing Lair"],
            ["ONY"] = L["Onyxia's Lair"],
            ["AQ20"] = L["Ruins of Ahn'Qiraj"],
            ["AQ40"] = L["Ahn'Qiraj"],
        }

        if numSaved > 0 then
            -- Add locked instance abbriviations to button text
            for savedIndex = 1, numSaved do

                local name = GetSavedInstanceInfo(savedIndex)

                if name == "Zul'Gurub" then
                    buttonText = buttonText .. " ZG"
                    raidsTable["ZG"] = nil
                elseif name == "Molten Core" then
                    buttonText = buttonText .. " MC"
                    raidsTable["MC"] = nil
                elseif name == "Blackwing Lair" then
                    buttonText = buttonText .. " BWL"
                    raidsTable["BWL"] = nil
                elseif name == "Onyxia's Lair" then
                    buttonText = buttonText .. " ONY"
                    raidsTable["ONY"] = nil
                elseif name == "Ruins of Ahn'Qiraj" then
                    buttonText = buttonText .. " AQ20"
                    raidsTable["AQ20"] = nil
                elseif name == "Ahn'Qiraj" then
                    buttonText = buttonText .. " AQ40"
                    raidsTable["AQ40"] = nil
                end

            end
        end
        

        if coloredText then
            buttonText = buttonText .. COLOR.green
        else
            buttonText = buttonText .. " |"
        end
        
        for abbr, raidName in pairs(raidsTable) do
            buttonText = buttonText .. " " .. abbr
        end
        
        if coloredText then
            buttonText = buttonText .. COLOR.green
        else
            buttonText = buttonText .. " |"
        end
        
        for abbr, raidName in pairs(raidsTable) do
            buttonText = buttonText .. " " .. abbr
        end
    
    else

        if numSaved > 0 then
            -- Add locked instance abbriviations to button text
            for savedIndex = 1, numSaved do

                local name = GetSavedInstanceInfo(savedIndex)

                if name == L["Zul'Gurub"] then
                    buttonText = buttonText .. " ZG"
                elseif name == L["Molten Core"] then
                    buttonText = buttonText .. " MC"
                elseif name == L["Blackwing Lair"] then
                    buttonText = buttonText .. " BWL"
                elseif name == L["Onyxia's Lair"] then
                    buttonText = buttonText .. " ONY"
                elseif name == L["Ruins of Ahn'Qiraj"] then
                    buttonText = buttonText .. " AQ20"
                elseif name == L["Ahn'Qiraj"] then
                    buttonText = buttonText .. " AQ40"
                end

            end
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
        headerText = headerText .. COLOR.grey .. "Instance Name [Bosses] - Reset Time\n"
    end
        
    tooltipText = tooltipText .. headerText
    
    if numSaved < 1 then
        
        tooltipText = tooltipText .. COLOR.white .. "All raid instances are unlocked"
        
    else
        -- Add locked instances to tooltip
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

            tooltipText = tooltipText .. COLOR.red .. name .. COLOR.white " [" .. progress .. COLOR.yellow .. "/" .. numEncounters .. COLOR.white .. "]" .. COLOR.yellow .. " - " .. dateToReset .. "\n"
            
            dateToReset = nil

        end
    end
    
end