local _, addonTable = ...
L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)

-- Addon menu text
L["PanelOptions"] = "Panel options" -- Settings menu option heading
L["ShowAllInstances"] = "Show all instances" -- Settings menu option
L["PanelShowClassicRaids"] = "Show Classic instances" -- Settings menu option
L["PanelShowTBCRaids"] = "Show TBC instances" -- Settings menu option
L["TooltipOptions"] = "Tooltip options" -- Settings menu option heading
L["ShowLayoutHint"] = "Show layout hint" -- Settings menu option
L["ShowNonLockedCharacters"] = "Show non-locked characters" -- Settings menu option
L["TooltipShowClassicRaids"] = "Show Classic instances" -- Settings menu option
L["TooltipShowTBCRaids"] = "Show TBC instances" -- Settings menu option
L["TITAN_PANEL_MENU_HIDE"] = "Hide" -- Settings menu option
L["Lockout: "] = "Lockout: " -- Panel label text
L["Instance Name [Bosses]"] = "Instance Name [Bosses]" -- Tooltip legend hint
L["Reset Time"] = "Reset Time" -- Tooltip legend hint
L["All raid instances are unlocked"] = "All raid instances are unlocked" -- Tooltip

-- Instance names
L["Zul'Gurub"] = "Zul'Gurub"
L["Molten Core"] = "Molten Core"
L["Blackwing Lair"] = "Blackwing Lair"
L["Onyxia's Lair"] = "Onyxia's Lair"
L["Ruins of Ahn'Qiraj"] = "Ruins of Ahn'Qiraj"
L["Ahn'Qiraj"] = "Ahn'Qiraj Temple"
L["Naxxramas"] = "Naxxramas"

-- Instance abbreviations
L["ZG"] = "ZG" --Zul'Gurub
L["MC"] = "MC" --Molten Core
L["BWL"] = "BWL" --Blackwing Lair
L["ONY"] = "ONY" --Onyxia's Lair
L["AQ20"] = "AQ20" --Ruins of Ahn'Qiraj
L["AQ40"] = "AQ40" --Ahn'Qiraj
L["NAXX"] = "NAXX" --Naxxramas
L["KARA"] = "KARA" --Karazhan
L["HY"] = "HY" --Hyjal Summit
L["MAG"] = "MAG" --Magtheridon's Lair
L["SSC"] = "SSC" --Serpentshrine Cavern
L["TK"] = "TK" --Tempest Keep
L["BT"] = "BT" --Black Temple
L["GRU"] = "GRU" --Gruul's Lair
L["ZA"] = "ZA" --Zul'Aman
L["SUN"] = "SUN" --Sunwell Plateau

if GetLocale() == "deDE" then
    -- German localization here
end

if GetLocale() == "esES" or GetLocale() == "esMX" then
    -- Spanish localization here
end

if GetLocale() == "frFR" then
    -- French localization here
end

if GetLocale() == "ruRU" then
    -- Russian localization here
end

if GetLocale() == "itIT" then
    -- Italian localization here
end

if GetLocale() == "koKR" then
    -- Korean localization here
end

if GetLocale() == "ptBR" then
    -- Portuguese (Brazil) localization here
end

if GetLocale() == "zhCN" then
    -- Simplified Chinese (PRC) localization here
end

if GetLocale() == "zhTW" then
    -- Traditional Chinese (Taiwan) localization here
end