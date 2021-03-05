-- wibar.lua
-- Wibar (top bar)
local awful = require("awful")
local gears = require("gears")
local gfs = require("gears.filesystem")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local systray_margin = (beautiful.wibar_height - beautiful.systray_icon_size) /
                           2

-- Helper function that changes the appearance of progress bars and their icons
-- Create horizontal rounded bars
local function format_progress_bar(bar)
    bar.forced_width = dpi(100)
    bar.shape = helpers.rrect(beautiful.border_radius - 3)
    bar.bar_shape = helpers.rrect(beautiful.border_radius - 3)
    bar.background_color = beautiful.xcolor0
    return bar
end

-- Awesome Panel -----------------------------------------------------------

local awesome_icon = wibox.widget {
    {
        {
            widget = wibox.widget.imagebox,
            image = gears.surface.load_uncached(
                gfs.get_configuration_dir() .. "icons/ghosts/awesome.png"),
            resize = true
        },
        margins = dpi(7),
        widget = wibox.container.margin
    },
    bg = beautiful.xbackground,
    widget = wibox.container.background
}

awesome_icon:buttons(gears.table.join(awful.button({}, 1, function()
    awesome_icon.bg = beautiful.xcolor0
end)))

-- Notifs Panel ---------------------------------------------------------------

local notifPop = require("bloat.pop.notif")
local notif_icon = wibox.widget {
    {
        {
            widget = wibox.widget.textbox,
            font = beautiful.icon_font,
            markup = "<span foreground='" .. beautiful.xcolor4 .. "'>" .. "" ..
                "</span>",
            resize = true
        },
        margins = dpi(4),
        widget = wibox.container.margin
    },
    bg = beautiful.xbackground,
    widget = wibox.container.background
}

-- notif_icon:connect_signal("mouse::enter", function() notifPop.visible = true end)
-- notifPop:connect_signal("mouse::leave", function() notifPop.visible = false end)

notif_icon:buttons(gears.table.join(awful.button({}, 1, function()
    notifPop.visible = true
    notif_icon.bg = beautiful.xcolor0
end)))

notifPop:connect_signal("mouse::leave", function()
    notifPop.visible = false
    notif_icon.bg = beautiful.xbackground
end)

-- Battery Bar Widget ---------------------------------------------------------

local battery_bar = wibox.widget {
    max_value = 100,
    value = 50,
    forced_width = dpi(200),
    shape = helpers.rrect(beautiful.border_radius - 3),
    bar_shape = helpers.rrect(beautiful.border_radius - 3),
    color = {
        type = 'linear',
        from = {0, 0},
        to = {75, 20},
        stops = {
            {0, beautiful.xcolor9}, {0.5, beautiful.xcolor11},
            {1, beautiful.xcolor10}
        }
    },
    background_color = beautiful.xcolor0,
    border_width = dpi(0),
    border_color = beautiful.border_color,
    widget = wibox.widget.progressbar
}

local battery_tooltip = awful.tooltip {}
battery_tooltip.shape = helpers.prrect(beautiful.border_radius - 3, true, true,
                                       false, false)
battery_tooltip.preferred_alignments = {"middle", "front", "back"}
battery_tooltip.mode = "outside"
battery_tooltip:add_to_object(battery_bar)
battery_tooltip.text = 'Not Updated'

awesome.connect_signal("ears::battery", function(value)
    battery_bar.value = value
    battery_bar.color = {
        type = 'linear',
        from = {0, 0},
        to = {75 - (100 - value), 20},
        stops = {
            {1 + (value) / 100, beautiful.xcolor10},
            {0.75 - (value / 100), beautiful.xcolor9},
            {1 - (value) / 100, beautiful.xcolor10}
        }
    }

    local bat_icon = ' '

    if value >= 90 and value <= 100 then
        bat_icon = ' '
    elseif value >= 70 and value < 90 then
        bat_icon = ' '
    elseif value >= 60 and value < 70 then
        bat_icon = ' '
    elseif value >= 50 and value < 60 then
        bat_icon = ' '
    elseif value >= 30 and value < 50 then
        bat_icon = ' '
    elseif value >= 15 and value < 30 then
        bat_icon = ' '
    else
        bat_icon = ' '
    end

    battery_tooltip.markup =
        " " .. "<span foreground='" .. beautiful.xcolor12 .. "'>" .. bat_icon ..
            "</span>" .. value .. '% '
end)

-- Timer for charging animation
local q = 0
local g = gears.timer {
    timeout = 0.03,
    call_now = false,
    autostart = false,
    callback = function()
        if q >= 100 then q = 0 end
        q = q + 1
        battery_bar.value = q
        battery_bar.color = {
            type = 'linear',
            from = {0, 0},
            to = {75 - (100 - q), 20},
            stops = {
                {1 + (q) / 100, beautiful.xcolor10},
                {0.75 - (q / 100), beautiful.xcolor1},
                {1 - (q) / 100, beautiful.xcolor10}
            }
        }
    end
}

-- The charging animation
local running = false
awesome.connect_signal("ears::charger", function(plugged)
    if plugged then
        g:start()
        running = true
    else
        if running then
            g:stop()
            running = false
        end
    end
end)

local battery = format_progress_bar(battery_bar)

-- Systray Widget -------------------------------------------------------------

local mysystray = wibox.widget.systray()
mysystray:set_base_size(beautiful.systray_icon_size)

local mysystray_container = {
    mysystray,
    left = dpi(8),
    right = dpi(8),
    widget = wibox.container.margin
}

-- Tasklist Buttons -----------------------------------------------------------

local tasklist_buttons = gears.table.join(
                             awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end), awful.button({}, 3, function()
        awful.menu.client_list({theme = {width = 250}})
    end), awful.button({}, 4, function() awful.client.focus.byidx(1) end),
                             awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

-- Playerctl Bar Widget -------------------------------------------------------

-- Title Widget
local song_title = wibox.widget {
    markup = 'Nothing Playing',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local song_artist = wibox.widget {
    markup = 'nothing playing',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local song_logo = wibox.widget {
    markup = '<span foreground="' .. beautiful.xcolor6 .. '"></span>',
    font = beautiful.icon_font,
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local playerctl_bar = wibox.widget {
    {
        {
            {
                song_logo,
                left = dpi(3),
                right = dpi(10),
                widget = wibox.container.margin
            },
            {
                {
                    song_title,
                    expand = "outside",
                    layout = wibox.layout.align.vertical
                },
                left = dpi(10),
                right = dpi(10),
                widget = wibox.container.margin
            },
            {
                {
                    song_artist,
                    expand = "outside",
                    layout = wibox.layout.align.vertical
                },
                left = dpi(10),
                widget = wibox.container.margin
            },
            spacing = 1,
            spacing_widget = {
                bg = beautiful.xcolor8,
                widget = wibox.container.background
            },
            layout = wibox.layout.fixed.horizontal
        },
        left = dpi(10),
        right = dpi(10),
        widget = wibox.container.margin
    },

    bg = beautiful.xcolor0,
    shape = helpers.rrect(beautiful.border_radius - 3),
    widget = wibox.container.background
}

playerctl_bar.visible = false

awesome.connect_signal("bling::playerctl::player_stopped",
                       function() playerctl_bar.visible = false end)

-- Get Title 
awesome.connect_signal("bling::playerctl::title_artist_album",
                       function(title, artist, _)

    playerctl_bar.visible = true
    song_title.markup = '<span foreground="' .. beautiful.xcolor5 .. '">' ..
                            title .. '</span>'

    song_artist.markup = '<span foreground="' .. beautiful.xcolor4 .. '">' ..
                             artist .. '</span>'
end)

-- Create the Wibar -----------------------------------------------------------

screen.connect_signal("request::desktop_decoration", function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create layoutbox widget
    s.mylayoutbox = awful.widget.layoutbox(s)

    if s.index == 1 then
        mysystray_container.visible = true
    else
        mysystray_container.visible = false
    end

    -- Create the wibox
    s.mywibox = awful.wibar({position = "bottom", screen = s})
    s.mywibox:set_xproperty("WM_NAME", "panel")

    -- Remove wibar on full screen
    local function remove_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibox.visible = false
        else
            c.screen.mywibox.visible = true
        end
    end

    -- Remove wibar on full screen
    local function add_wibar(c)
        if c.fullscreen or c.maximized then
            c.screen.mywibox.visible = true
        end
    end

    -- Hide bar when a splash widget is visible
    awesome.connect_signal("widgets::splash::visibility",
                           function(vis) s.mywibox.visible = not vis end)

    client.connect_signal("property::fullscreen", remove_wibar)

    client.connect_signal("request::unmanage", add_wibar)

    -- Create the taglist widget
    s.mytaglist = require("bloat.widgets.pacman_taglist")(s)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        bg = beautiful.xcolor0,
        style = {bg = beautiful.xcolor0},
        layout = {spacing = dpi(0), layout = wibox.layout.fixed.horizontal},
        widget_template = {
            {
                {
                    nil,
                    awful.widget.clienticon,
                    nil,
                    layout = wibox.layout.fixed.horizontal
                },
                top = dpi(5),
                bottom = dpi(5),
                left = dpi(10),
                right = dpi(10),
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background
        }
    }

    local final_systray = wibox.widget {
        {mysystray_container, top = dpi(5), layout = wibox.container.margin},
        bg = beautiful.xcolor0,
        shape = helpers.rrect(beautiful.border_radius - 3),
        widget = wibox.container.background
    }

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.fixed.vertical,
        {
            widget = wibox.container.background,
            bg = beautiful.xcolor0,
            forced_height = dpi(1)
        },
        {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    awesome_icon,
                    top = dpi(0),
                    right = dpi(5),
                    left = dpi(10),
                    widget = wibox.container.margin
                },
                {
                    {
                        s.mytaglist,
                        bg = beautiful.xcolor0,
                        shape = helpers.rrect(beautiful.border_radius - 3),
                        widget = wibox.container.background
                    },
                    margins = dpi(5),
                    widget = wibox.container.margin
                },
                s.mypromptbox,
                {
                    playerctl_bar,
                    margins = dpi(5),
                    widget = wibox.container.margin
                }
            },
            {
                {
                    {
                        s.mytasklist,
                        bg = beautiful.xcolor0 .. "00",
                        shape = helpers.rrect(beautiful.border_radius - 3),
                        widget = wibox.container.background
                    },
                    margins = dpi(5),
                    widget = wibox.container.margin
                },
                widget = wibox.container.constraint
            },
            {
                {
                    {
                        {
                            battery,
                            margins = dpi(5),
                            widget = wibox.container.margin
                        },
                        bg = beautiful.xcolor0,
                        shape = helpers.rrect(beautiful.border_radius - 3),
                        widget = wibox.container.background
                    },
                    margins = dpi(5),
                    widget = wibox.container.margin
                },
                nil,
                nil,
                {
                    awful.widget.only_on_screen(final_systray, screen[1]),
                    margins = dpi(5),
                    widget = wibox.container.margin
                },
                {
                    {
                        {
                            s.mylayoutbox,
                            top = dpi(4),
                            bottom = dpi(4),
                            right = dpi(7),
                            left = dpi(7),
                            widget = wibox.container.margin
                        },
                        bg = beautiful.xcolor0,
                        shape = helpers.rrect(beautiful.border_radius - 3),
                        widget = wibox.container.background
                    },
                    margins = dpi(5),
                    widget = wibox.container.margin
                },

                {
                    notif_icon,
                    top = dpi(0),
                    right = dpi(10),
                    left = dpi(5),
                    widget = wibox.container.margin
                },

                layout = wibox.layout.fixed.horizontal
            }
        }
    }
end)

-- EOF ------------------------------------------------------------------------
