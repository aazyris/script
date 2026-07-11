-- =============================================
--   Aftermath Example Script
--   Load lib from local file using readfile()
-- =============================================

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/aazyris/script/main/lib.lua"))()

-- Create the menu  (title, config folder)
local menu = library.new("Aftermath", "configs/")

-- =============================================
--   TABS
-- =============================================

local combatTab   = menu.new_tab("Combat")
local visualsTab  = menu.new_tab("Visuals")
local playerTab   = menu.new_tab("Player")
local miscTab     = menu.new_tab("Misc")

-- =============================================
--   COMBAT TAB
-- =============================================

local aimSection = combatTab.new_section("Aimbot")

-- Left side sector
local aimSector = aimSection.new_sector("Aimbot Settings", "Left")

local aimbotToggle = aimSector.element("Toggle", "Enable Aimbot", {
    default = { Toggle = false }
}, function(value)
    print("Aimbot:", value.Toggle)
end)

local silentToggle = aimSector.element("Toggle", "Silent Aim", {
    default = { Toggle = false }
}, function(value)
    print("Silent Aim:", value.Toggle)
end)

-- Add keybind to silent aim toggle
silentToggle:add_keybind({ Key = nil, Type = "Always", Active = true }, function(kb)
    print("Silent Aim keybind changed:", kb.Key, kb.Type)
end)

local fovDropdown = aimSector.element("Dropdown", "FOV Circle", {
    default = { Dropdown = "Off" },
    options = { "Off", "White", "Blue", "Rainbow" }
}, function(value)
    print("FOV Circle:", value.Dropdown)
end)

-- Right side sector
local predSector = aimSection.new_sector("Prediction", "Right")

local predSlider = predSector.element("Slider", "Prediction", {
    default = { Slider = 0.15 },
    min = 0,
    max = 1,
    float = 0.01
}, function(value)
    print("Prediction:", value.Slider)
end)

local smoothSlider = predSector.element("Slider", "Smoothness", {
    default = { Slider = 5 },
    min = 1,
    max = 20,
    float = 1
}, function(value)
    print("Smoothness:", value.Slider)
end)

-- =============================================
--   VISUALS TAB
-- =============================================

local espSection = visualsTab.new_section("ESP")

local espSector = espSection.new_sector("Players", "Left")

local espToggle = espSector.element("Toggle", "Enable ESP", {
    default = { Toggle = false }
}, function(value)
    print("ESP:", value.Toggle)
end)

local boxToggle = espSector.element("Toggle", "Box ESP", {
    default = { Toggle = false }
}, function(value)
    print("Box:", value.Toggle)
end)

-- Color picker attached to box toggle
local boxColor = boxToggle:add_color(
    { Color = Color3.fromRGB(255, 255, 255) },
    false, -- no transparency
    function(value)
        print("Box color:", value.Color)
    end
)

local tracerToggle = espSector.element("Toggle", "Tracers", {
    default = { Toggle = false }
}, function(value)
    print("Tracers:", value.Toggle)
end)

local nameSector = espSection.new_sector("Labels", "Right")

local nameToggle = nameSector.element("Toggle", "Names", {
    default = { Toggle = false }
}, function(value)
    print("Names:", value.Toggle)
end)

local distToggle = nameSector.element("Toggle", "Distance", {
    default = { Toggle = false }
}, function(value)
    print("Distance:", value.Toggle)
end)

-- =============================================
--   PLAYER TAB
-- =============================================

local movSection = playerTab.new_section("Movement")

local movSector = movSection.new_sector("Speed", "Left")

local speedToggle = movSector.element("Toggle", "Speed Hack", {
    default = { Toggle = false }
}, function(value)
    print("Speed:", value.Toggle)
end)

local speedSlider = movSector.element("Slider", "Speed Value", {
    default = { Slider = 16 },
    min = 16,
    max = 100,
    float = 1
}, function(value)
    print("Speed value:", value.Slider)
end)

local flySector = movSection.new_sector("Fly", "Right")

local flyToggle = flySector.element("Toggle", "Fly", {
    default = { Toggle = false }
}, function(value)
    print("Fly:", value.Toggle)
end)

flyToggle:add_keybind({ Key = "F", Type = "Toggle", Active = false }, function(kb)
    print("Fly active:", kb.Active)
end)

-- =============================================
--   MISC TAB
-- =============================================

local cfgSection = miscTab.new_section("Config")

local cfgSector = cfgSection.new_sector("Manage", "Left")

-- Save config button
cfgSector.element("Button", "Save Config", {}, function()
    menu.save_cfg("default")
    print("Config saved!")
end)

-- Load config button
cfgSector.element("Button", "Load Config", {}, function()
    menu.load_cfg("default")
    print("Config loaded!")
end)

local notifSector = cfgSection.new_sector("Info", "Right")

notifSector.element("Toggle", "Notifications", {
    default = { Toggle = true }
}, function(value)
    print("Notifications:", value.Toggle)
end)
