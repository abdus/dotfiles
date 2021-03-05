-- rc.lua
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local gfs = require("gears.filesystem")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Helpers Library
local helpers = require("helpers")

-- Autostart and Errors -------------------------------------------------------

local autostart = require("autostart")
awesome.register_xproperty("WM_NAME", "string")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title = "Oops, an error happened" ..
            (startup and " during startup!" or "!"),
        message = message
    }
end)

-- Variables & Inits ----------------------------------------------------------

-- Set Theme
theme = "ghosts"
beautiful.init(gfs.get_configuration_dir() .. "theme/" .. theme .. "/theme.lua")

-- Default Applications
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
browser = "brave"
filemanager = "pcmanfm"
discord = "discord"
launcher = "rofi -show drun"
music = terminal .. " -c music -e ncspot"

-- Dims
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"
shift = "Shift"
ctrl = "Control"

-- Import Bling Module
local bling = require("bling")
-- Playerctl signal
bling.signal.playerctl.enable()

-- Layouts
require("window")

-- Screen Stuff ---------------------------------------------------------------

-- Set Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    --[[ bling.module.tiled_wallpaper("", s, {
        fg = beautiful.xcolor8,
        bg = beautiful.xcolor0,
        offset_y = beautiful.wibar_height + 5,
        offset_x = 0,
        font = "FiraCode Nerd Font Mono",
        font_size = 12,
        padding = 60,
        zickzack = true
    }) --]]

    gears.wallpaper.maximized(beautiful.wallpaper, s, false, nil)
end)

screen.connect_signal("request::desktop_decoration", function(s)
    -- Screen padding
    screen[s].padding = {left = 0, right = 0, top = 0, bottom = 0}

    -- Each screen has its own tag table.
    awful.tag({"1", "2", "3", "4", "5"}, s, awful.layout.layouts[1])
end)

-- Keys -----------------------------------------------------------------------

require("keys")

-- Rules ----------------------------------------------------------------------

ruled.client.connect_signal("request::rules", function()

    -- Global
    ruled.client.append_rule {
        id = "global",
        rule = {},
        properties = {
            focus = awful.client.focus.filter,
            raise = true,
            size_hints_honor = false,
            screen = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_overlap +
                awful.placement.no_offscreen
        }
    }

    -- Tasklist order
    ruled.client.append_rule {
        id = "tasklist_order",
        rule = {},
        properties = {},
        callback = awful.client.setslave
    }

    -- Floate em
    ruled.client.append_rule {
        id = "floating",
        rule_any = {
            class = {"Arandr", "Blueman-manager", "Sxiv", "fzfmenu"},
            role = {
                "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = {floating = true}
    }

    -- Borders
    ruled.client.append_rule {
        id = "borders",
        rule_any = {type = {"normal", "dialog"}},
        except_any = {
            role = {"Popup"},
            type = {"splash"},
            name = {"^discord.com is sharing your screen.$"}
        },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal
        }
    }

    -- Center Placement
    ruled.client.append_rule {
        id = "center_placement",
        rule_any = {
            type = {"dialog"},
            class = {
                "Steam", "discord", "music", "markdown_input", "scratchpad"
            },
            instance = {"music", "markdown_input", "scratchpad"},
            role = {"GtkFileChooserDialog", "conversation"}
        },
        properties = {placement = awful.placement.center}
    }

    -- Titlebar rules
    ruled.client.append_rule {
        id = "titlebars",
        rule_any = {type = {"normal", "dialog"}},
        except_any = {
            class = {"Steam", "zoom", "jetbrains-studio"},
            type = {"splash"},
            name = {"^discord.com is sharing your screen.$"}
        },
        properties = {titlebars_enabled = true}
    }
end)

-- Import Daemons and Widgets
require("ears")
require("bloat")

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- collectgarbage("setpause", 160)
-- collectgarbage("setstepmul", 400)

-- EOF ------------------------------------------------------------------------
