local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local titlebar

local get_titlebar = function(c, height, color)

    local buttons = gears.table.join(awful.button({}, 1, function()
        client.focus = c
        c:raise()
        awful.mouse.client.move(c)
    end), awful.button({}, 3, function()
        client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
    end))

    --[[ local wid = wibox.widget {
        {
            {
                bg = color,
                shape = helpers.prrect(beautiful.border_radius, true, true,
                                       false, false),
                widget = wibox.container.background
            },
            top = beautiful.oof_border_width,
            left = beautiful.oof_border_width,
            right = beautiful.oof_border_width,
            widget = wibox.container.margin
        },
        shape = helpers.prrect(beautiful.border_radius + 2, true, true, false,
                               false),
        widget = wibox.container.background
    }

    wid.bg = beautiful.xcolor0
    --]]

    --[[
    local function update()
        if client.focus == c then
            wid.bg = beautiful.xcolor8
        else
            wid.bg = beautiful.xcolor0
        end
    end
    update()
    c:connect_signal("focus", update)
    c:connect_signal("unfocus", update)
    --]]

    awful.titlebar(c, {size = height, bg = color}):setup{
        nil,
        -- {
        -- {
        -- wid,
        { -- Middle
            { -- Title
                align = 'center',
                valign = 'center',
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        --[[     top = 14,
                left = 14,
                right = 14,
                widget = wibox.container.margin
            },
            bg = beautiful.xbackground,
            shape = helpers.prrect(beautiful.border_radius + 2, true, true,
                                   false, false),
            widget = wibox.container.background --]]
        -- },
        nil,
        layout = wibox.layout.align.horizontal
    }
end

local top = function(c)
    local color = beautiful.xbackground

    if c.class == "firefox" then
        color = beautiful.xcolor0
    else
        color = beautiful.xcolor0
    end

    local titlebar_height = beautiful.titlebar_size
    get_titlebar(c, titlebar_height, color)
end

return top
