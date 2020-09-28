local _, addonTable = ...
L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)

-- MISSING SUPPORT FOR:
-- Italian (itIT), Brazilian Portuguese (ptBR), Korean (koKR), Simp. Chinese (zhCN), Trad. Chinese (zhTW)

-- Addon menu text
L["Tooltip Legend"] = "Tooltip Legend" -- Settings menu option
L["Panel - Show all instances"] = "Panel - Show all instances" -- Settings menu option
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

-- Instance abbreviations
L["ZG"] = "ZG" --Zul'Gurub
L["MC"] = "MC" --Molten Core
L["BWL"] = "BWL" --Blackwing Lair
L["ONY"] = "ONY" --Onyxia's Lair
L["AQ20"] = "AQ20" --Ruins of Ahn'Qiraj
L["AQ40"] = "AQ40" --Ahn'Qiraj

if GetLocale() == "deDE" then
    L["Molten Core"] = "Geschmolzener Kern"
    L["Blackwing Lair"] = "Pechschwingenhort"
    L["Onyxia's Lair"] = "Onyxias Hort"
    L["Ruins of Ahn'Qiraj"] = "Ruinen von Ahn'Qiraj"
    L["Ahn'Qiraj"] = "Tempel von Ahn'Qiraj"
end

if GetLocale() == "esES" or GetLocale() == "esMX" then
    L["Molten Core"] = "Núcleo de Magma"
    L["Blackwing Lair"] = "Guarida Alanegra"
    L["Onyxia's Lair"] = "Guarida de Onyxia"
    L["Ruins of Ahn'Qiraj"] = "Ruinas de Ahn'Qiraj"
end

if GetLocale() == "frFR" then
    L["Molten Core"] = "Cœur du Magma"
    L["Blackwing Lair"] = "Repaire de l'Aile noire"
    L["Onyxia's Lair"] = "Repaire d'Onyxia"
    L["Ruins of Ahn'Qiraj"] = "Ruines d'Ahn'Qiraj"
end

if GetLocale() == "ruRU" then
    L["Zul'Gurub"] = "Зул'Гуруб"
    L["Molten Core"] = "Огненные Недра"
    L["Blackwing Lair"] = "Логово Крыла Тьмы"
    L["Onyxia's Lair"] = "Логово Ониксии"
    L["Ruins of Ahn'Qiraj"] = "Руины Ан'Киража"
    L["Ahn'Qiraj"] = "Ан'Кираж"
end