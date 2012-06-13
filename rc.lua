-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")

-- Themes define colours, icons, and wallpapers
beautiful.init("/home/brandon/.config/awesome/themes/zenburn/theme.lua")


confdir = awful.util.getdir("config")

-- This is used later as the default terminal and editor to run.
local home = os.getenv("HOME")

terminal = "urxvt"
browser  = "chromium-browser"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
wallpaper_dir = home .. "/Images/wallpaper" 

-- From tony's github repo 'awesome-config'
-- TODO: Read it in full, it has great examples. 
local wallpaper_cmd = "find " .. wallpaper_dir 
	.. " -type f -name '*.jpg'  -print0 | shuf -n1 -z | " 
	.. "xargs -0 feh --bg-scale"

-- Default modkey.
modkey = "Mod4"

-- Set wallapaper

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.fair, 
    awful.layout.suit.tile.top,
    awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max.fullscreen, Meta+f does this anyway
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.floating, -- No different from max.fullscreen?
    --awful.layout.suit.max, -- Why bother showing top menu? 
    --awful.layout.suit.tile.bottom, -- Not bad, but redundant vs tile.top.
    --awful.layout.suit.spiral, -- sim to spiral.dwindle, but uglier
    --awful.layout.suit.magnifier -- Useless to put window in center
}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5 }, s, layouts[1])
end
-- }}}

-- REQUIRE EXTERNAL CONFIGS
require("menu")
require("topbar")
require("keybindings")

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
					 size_hints_honor = false, -- XXX: Fix gaps
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

	-- XXX: I don't want the mouse:enter event focusing!
    -- Enable sloppy focus
    --c:add_signal("mouse::enter", function(c)
    --    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
    --        and awful.client.focus.filter(c) then
    --        client.focus = c
    --    end
    --end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- Wallpaper timer
-- Again, from tony's repo
x = 0
mytimer = timer { timeout = x }
mytimer:add_signal("timeout", function()
	-- Wallpaper randomization timers
	-- TODO: Move to config options above.
	local min = 5 * 60
	local max = 15 * 60

	-- Randomly choose wallpaper
	--[[ -- File exists check fails for some unknown reason. 
	if file_exists(wallpaper_dir) and whereis_app('feh') then
		battext.text = "File exists"
		os.execute(wallpaper_cmd)
	end
	--]]
	os.execute(wallpaper_cmd)

	-- Stop timer (so no multiple instances running)
	mytimer:stop()

	-- Interval for new wallpaper
	x = math.random(min, max)

	mytimer.timeout = x
	mytimer:start()
end)

mytimer:start()

