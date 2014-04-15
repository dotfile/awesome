--
--	Brandon Thomas' Awesome Window Manager Configs
--	----------------------------------------------	
--	Comments, suggestions, and patches are welcome 
--		* echelon@gmail/github
--		* http://posbl.org
--

--[[ ======================================
			Load Awesome WM Libraries
	 ====================================== --]]

require("awful")			-- Standard awesome library
require("awful.autofocus")
require("awful.rules")
require("beautiful")		-- Theme library
require("naughty")			-- Notification library
require("error") 			-- Error notify (local)
socket = require("socket")	-- XXX: Need socket lib!


--[[ ======================================
	   		  AWESOME CONFIGURATION
	 ====================================== --]]

AWESOME_NUM_TAGS = 1
AWESOME_FONT = 'bitstream vera sans 10'
AWESOME_THEME = '/themes/molokai/theme.lua'
AWESOME_CONFDIR  = awful.util.getdir('config')

HOSTNAME = socket.dns.gethostname()
HOMEDIR  = os.getenv('HOME')
CONFDIR  = awful.util.getdir('config') -- TODO: Deprecate
CMD_LOCK = 'xlock -mode rain'
modkey   = 'Mod4'

TERMINAL = 'urxvt'
TERMINAL_CWD = 'urxvt -cd'
BROWSER = 'chrome'
BROWSER2 = 'firefox'
EDITOR = os.getenv('EDITOR') or 'vim'
EDITOR_CMD = TERMINAL .. ' -e ' .. EDITOR
WALLPAPER_DIR = HOMEDIR .. '/Images/wallpaper'

BATTERY_NAME = nil

MOUSE_HIDE_TIMEOUT = 10
MOUSE_HIDE_NOMOVE_COUNT = 2

--[[ ======================================
	   Per-machine configuration switch
	 ====================================== --]]

if HOSTNAME == 'darwin' then
	BROWSER = 'firefox'
	AWESOME_FONT = 'droid sans mono 10.5'
	AWESOME_NUM_TAGS = 12

elseif HOSTNAME == 'x120e' then
	AWESOME_FONT = 'bitstream vera sans 12.5'
	AWESOME_NUM_TAGS = 12
	BATTERY_NAME = 'BAT1'

elseif HOSTNAME == 'vaiop' then
	AWESOME_FONT = 'ubuntu 13'
	AWESOME_NUM_TAGS = 4
	BROWSER = 'chromium-browser'
	BATTERY_NAME = 'BAT0'

end


-- Init theme
beautiful.init(AWESOME_CONFDIR .. AWESOME_THEME)

-- From tony's github repo 'awesome-config'
-- TODO: Read it in full, it has great examples. 
local WALLPAPER_CMD = "find " .. WALLPAPER_DIR 
	.. " -type f -regextype posix-extended -iregex '.*(png|jpg)$' -print0"
	.. " | shuf -n1 -z | xargs -0 feh --bg-scale"

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
-- Order matters for awful.layout.inc
-- removed frivolous/redundant ones
layouts =
{
    awful.layout.suit.fair, 
    awful.layout.suit.tile,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair.horizontal, 
    awful.layout.suit.spiral.dwindle,
}

-- Build a tag table which hold all screen tags.
-- Each screen has its own tag table.
tags = {}
for s = 1, screen.count() do
	local table = {}
	for t = 1, AWESOME_NUM_TAGS do
		table[t] = t
	end
    tags[s] = awful.tag(table, s, layouts[1])
end

-- REQUIRE EXTERNAL CONFIGS
require("topbar")
require("keybindings")
require("rules")
require("signals")

-- Last known coordinates of the mouse
mouseLastCoords = {x=0, y=0}

-- Setup mouse hiding timer
mouseTimerCount = 0 -- Number of times mouse hasn't moved
mouseTimer = timer { timeout = MOUSE_HIDE_TIMEOUT }
mouseTimer:add_signal("timeout", function()

	-- Only move if hasn't been moved much. 
	local cur = mouse.coords()

	if math.abs(cur.x - mouseLastCoords.x) < 2 
		and math.abs(cur.y - mouseLastCoords.y) < 2 then
			mouseTimerCount = mouseTimerCount + 1
	else
		mouseTimerCount = 0
	end

	mouseLastCoords.x  = cur.x
	mouseLastCoords.y  = cur.y

	if mouseTimerCount >= MOUSE_HIDE_NOMOVE_COUNT then
		mouse.coords({x=9000, y=9000})
		mouseTimerCount = 0
	end

	-- Stop timer (so no multiple instances running)
	mouseTimer:stop()

	mouseTimer.timeout = MOUSE_HIDE_TIMEOUT
	mouseTimer:start()
end)

mouseTimer:start()


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
	os.execute(WALLPAPER_CMD)

	-- Stop timer (so no multiple instances running)
	mytimer:stop()

	-- Interval for new wallpaper
	x = math.random(min, max)

	mytimer.timeout = x
	mytimer:start()
end)

mytimer:start()

