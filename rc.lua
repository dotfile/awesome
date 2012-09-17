require("awful") -- Standard awesome library
require("awful.autofocus")
require("awful.rules")
require("beautiful") -- Theme handling library
require("naughty") -- Notification library
require("debian.menu") -- Load Debian menu entries

-- Error handling
require("error")

-- XXX: Requires socket library installed
socket = require("socket")

-- Globals
HOSTNAME = socket.dns.gethostname()
HOMEDIR  = os.getenv("HOME")
CONFDIR  = awful.util.getdir("config")
CMD_LOCK = "xlock -mode rain"
modkey   = "Mod4"

-- Themes define colours, icons, and wallpapers
beautiful.init(CONFDIR .. "/themes/zenburn/theme.lua") -- XXX

terminal = "urxvt"
TERMINAL = "urxvt"
TERMINAL_CWD = "urxvt -cd"
browser  = "chromium-browser"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
wallpaper_dir = HOMEDIR .. "/Images/wallpaper" 


-- From tony's github repo 'awesome-config'
-- TODO: Read it in full, it has great examples. 
local wallpaper_cmd = "find " .. wallpaper_dir 
	.. " -type f -name '*.jpg'  -print0 | shuf -n1 -z | " 
	.. "xargs -0 feh --bg-scale"

-- Spawn one and only one of these processes
do
	local cmds = { 
		"gnome-sound-applet",
		"if [ $(pidof nm-applet | wc -w) -eq 0 ]; then nm-applet; fi",
	}
	for _,i in pairs(cmds) do
		awful.util.spawn_with_shell(i)
	end
end


-- Table of layouts. 
-- Order matters for awful.layout.inc; removed frivolous ones.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.fair, 
    awful.layout.suit.tile.top,
    awful.layout.suit.spiral.dwindle,
}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4 }, s, layouts[1])
end
-- }}}

-- REQUIRE EXTERNAL CONFIGS
require("menu")
require("topbar")
require("keybindings")
require("rules")

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

