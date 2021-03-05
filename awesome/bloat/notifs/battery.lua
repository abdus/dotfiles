local gfs = require("gears.filesystem")
local naughty = require("naughty")

local display = true

awesome.connect_signal("ears::battery", function(value)
    if value < 11 then
        naughty.notification({
            title = "Battery Status",
            text = "Running low at " .. value .. "%",
            image = gfs.get_configuration_dir() .. "icons/ghosts/battery.png"
        })
    end

    if (value > 94 and display) then
        naughty.notification({
            title = "Battery Status",
            text = "Running high at " .. value .. "%",
            image = gfs.get_configuration_dir() .. "icons/ghosts/battery.png"

        })
        display = false
    end
end)

awesome.connect_signal("ears::charger", function(plugged)
    if plugged then
        naughty.notification({
            title = "Battery Status",
            text = "Charging",
            image = gfs.get_configuration_dir() ..
                "icons/ghosts/battery_charging.png"
        })
        display = true
    end

end)
