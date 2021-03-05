local exit_manager = require(... .. ".exitscreen")
local dash_manager = require(... .. ".dash")

awesome.connect_signal("widgets::dashboard::show",
                       function() dash_manager.dash_show() end)

awesome.connect_signal("widgets::exit_screen::show",
                       function() exit_manager.exit_screen_show() end)
