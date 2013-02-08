-- AWESOME WINDOW MANAGER
-- KEY AND MOUSE BINDINGS 

require('func')
require('clients')

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

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

    awful.key({ modkey, "Control" }, "Return", function () 
		awful.util.spawn(BROWSER) end),

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
		awful.layout.set(layouts[1], nil)
	end),

    awful.key({ modkey, }, "2", function () 
		awful.layout.set(layouts[2], nil)
	end),

    awful.key({ modkey, }, "3", function () 
		awful.layout.set(layouts[3], nil)
	end),

    awful.key({ modkey, }, "4", function () 
		awful.layout.set(layouts[4], nil)
	end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end)
)

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

	-- Kill clients
    awful.key({ modkey, "Shift"  }, "c", kill_client),
    awful.key({ modkey, "Control"}, "c", kill_client),
    awful.key({ modkey, "Control"}, "x", kill_clients_on_cur_tag),

	-- Misc
	awful.key({ modkey, "Shift"  }, "r", function (c) c:redraw() end),
    awful.key({ modkey, }, "t", function (c) 
		c.ontop = not c.ontop end),

	-- Move clients to left/right tags
	awful.key({ modkey, "Control"	}, "Left",  move_client_prev_tag),
	awful.key({ modkey, "Control"	}, "Right", move_client_next_tag)
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

