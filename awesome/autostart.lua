-- autostart.lua
-- Autostart Stuff Here
local awful = require("awful")
local gears = require("gears")

local function run_once(cmd)
    local findme = cmd
    local firstspace = cmd:find(' ')
    if firstspace then findme = cmd:sub(0, firstspace - 1) end
    awful.spawn.easy_async_with_shell(string.format(
                                          'pgrep -u $USER -x %s > /dev/null || (%s)',
                                          findme, cmd))
end

-- LuaFormatter off
-- Add apps to autostart here
autostart_apps = {
    -- Network Manager Applet
    "nm-applet", 

    -- Disable Bell
    "xset -b", 

    -- Layout
    "~/.screenlayout/layout.sh", 

    -- Bluetooth
    "blueman-applet", 

    -- Compositor
    "picom --experimental-backends --config " ..
        gears.filesystem.get_configuration_dir() .. "configs/picom.conf",

    -- Media controller daemon
    "playerctld daemon"
}
-- LuaFormatter on

for app = 1, #autostart_apps do run_once(autostart_apps[app]) end

-- EOF ------------------------------------------------------------------------
