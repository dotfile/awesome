-- AWESOME WINDOW MANAGER
-- KEY AND MOUSE BINDINGS 

require('func')

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- Switch to the next client
function switch_client_next()
	awful.client.focus.byidx( 1)
	if client.focus then client.focus:raise() end
end

-- Switch to the previous client
function switch_client_prev()
	awful.client.focus.byidx(-1)
	if client.focus then client.focus:raise() end
end

-- Move client (window) around
function move_client_next() awful.client.swap.byidx(1) end
function move_client_prev() awful.client.swap.byidx(-1) end

-- {{{ Key bindings
globalkeys = awful.util.table.join(

	---
	--- Lock screen: Mod+Ctrl+Shift+l
	---
	awful.key({ modkey , "Control"}, "l", 
		function(c) 
			awful.util.spawn(CMD_LOCK) 
		end),

	---
	--- Switch Between Tags (Virtual Desktops): Mod+Left, Mod+Right
	---
	awful.key({ modkey, }, "Left",   awful.tag.viewprev       ),
	awful.key({ modkey, }, "Right",  awful.tag.viewnext       ),

	---
	--- Switch Between Windows: Mod+j, Mod+k
	---
	awful.key({ modkey, }, "j", switch_client_next),
    awful.key({ modkey, }, "k", switch_client_prev),

	---
	--- Move Window Around Layout: Mod+Shift+j, Mod+Shift+k
	---
    awful.key({ modkey, "Shift"   }, "j", move_client_next),
    awful.key({ modkey, "Control" }, "j", move_client_next),
	awful.key({ modkey, "Shift"   }, "k", move_client_prev),
    awful.key({ modkey, "Control" }, "k", move_client_prev),

	awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey, }, "Tab", function ()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end),

    -- Launch Programs
    awful.key({ modkey, }, "Return", function () 
		open_terminal_same_cwd(c) end),
		--awful.util.spawn(terminal) end),

    awful.key({ modkey, "Control" }, "Return", function () 
		awful.util.spawn(browser) end),

	-- Standard Program
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

	---
	--- Change Pane Size: Mod+h, Mod+l
	---
    awful.key({ modkey, }, "l", function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey, }, "h", function () awful.tag.incmwfact(-0.05) end),

	-- Directly choose layout
	-- TODO: Clean up this code with a table + loop
    awful.key({ modkey, }, "1", function () 
		awful.layout.set(awful.layout.suit.tile, nil)
	end),

    awful.key({ modkey, }, "2", function () 
		awful.layout.set(awful.layout.suit.fair, nil)
	end),

    awful.key({ modkey, }, "3", function () 
		awful.layout.set(awful.layout.suit.tile.top, nil)
	end),

    awful.key({ modkey, }, "4", function () 
		awful.layout.set(awful.layout.suit.spiral.dwindle, nil)
	end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end)
)

-- Move windows to left workspace (tags)
function move_window_prev_tag(c)
	local curidx = awful.tag.getidx(c:tags()[1])
	if curidx == 1 then
		c:tags({screen[mouse.screen]:tags()[AWESOME_NUM_TAGS]})
	else
		c:tags({screen[mouse.screen]:tags()[curidx - 1]})
	end
	awful.tag.viewprev()
end

-- Move windows to right workspace (tags)
function move_window_next_tag(c)
	local curidx = awful.tag.getidx(c:tags()[1])
	if curidx == AWESOME_NUM_TAGS then
		c:tags({screen[mouse.screen]:tags()[1]})
	else
		c:tags({screen[mouse.screen]:tags()[curidx + 1]})
	end
	awful.tag.viewnext()
end

-- Kill a window 
function kill_window(c) c:kill() end

clientkeys = awful.util.table.join(

	-- Spawn terminal at location
	-- NOTE: Not necessary anymore w/ global binding
    --awful.key({ modkey, }, "o", function(c)
	--	open_terminal_same_cwd(c) end),

    --awful.key({ modkey, }, "Return", function () 
	--	awful.util.spawn(terminal) end),

	-- Toggle fullscreen 
    awful.key({ modkey, }, "f", function (c) 
		c.fullscreen = not c.fullscreen  end),

	-- Kill window
    awful.key({ modkey, "Shift"  }, "c", kill_window),
    awful.key({ modkey, "Control"}, "c", kill_window),

	-- Misc
	awful.key({ modkey, "Shift"  }, "r", function (c) c:redraw() end),
    awful.key({ modkey, }, "t", function (c) 
		c.ontop = not c.ontop end),

	-- Move windows to left/right workspaces (tags)
	awful.key({ modkey, "Control"	}, "Left",  move_window_prev_tag),
	awful.key({ modkey, "Control"	}, "Right", move_window_next_tag)
)

-- Compute the maximum number of digit we need
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(AWESOME_NUM_TAGS, math.max(#tags[s], keynumber));
end

---
--- Allow mouse to raise (select) window
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

