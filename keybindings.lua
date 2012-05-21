-- AWESOME WINDOW MANAGER
-- KEY AND MOUSE BINDINGS 

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(

	-- Lock screen
	awful.key({ modkey , "Control", "Shift" }, "l", 
		function(c) awful.util.spawn("xlock") end),

	awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
	awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
	awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

	awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
	
    --awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

	-- XXX: I need to get very familiar with these. 
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

	-- Not sure what this one does...
    --awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end)

	-- No need to evalulate Lua code 
    --awful.key({ modkey }, "x",
    --          function ()
    --              awful.prompt.run({ prompt = "Run Lua code: " },
    --              mypromptbox[mouse.screen].widget,
    --              awful.util.eval, nil,
    --              awful.util.getdir("cache") .. "/history_eval")
    --          end)
)

-- Move windows to left workspace (tags)
-- XXX: Assumes 9 tags. 
function move_window_prev_tag(c)
	local curidx = awful.tag.getidx(c:tags()[1])
	if curidx == 1 then
		c:tags({screen[mouse.screen]:tags()[9]})
	else
		c:tags({screen[mouse.screen]:tags()[curidx - 1]})
	end
	awful.tag.viewprev()
end

-- Move windows to right workspace (tags)
-- XXX: Assumes 9 tags. 
function move_window_next_tag(c)
	local curidx = awful.tag.getidx(c:tags()[1])
	if curidx == 9 then
		c:tags({screen[mouse.screen]:tags()[1]})
	else
		c:tags({screen[mouse.screen]:tags()[curidx + 1]})
	end
	awful.tag.viewnext()
end

-- Kill a window 
function kill_window(c) c:kill() end

clientkeys = awful.util.table.join(
	-- Toggle fullscreen 
    awful.key({ modkey,          }, "f",     function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"  }, "c",     kill_window),
    awful.key({ modkey, "Control"}, "c",     kill_window),
    awful.key({ modkey, "Control"}, "space", awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control"}, "Return",function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,          }, "o",     awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"  }, "r",     function (c) c:redraw()                       end),
    awful.key({ modkey,          }, "t",     function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,          }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
	-- No need to 'maximize' when I can fullscreen. 
    --awful.key({ modkey,           }, "m",
    --    function (c)
    --        c.maximized_horizontal = not c.maximized_horizontal
    --        c.maximized_vertical   = not c.maximized_vertical
    --    end),

	-- Move windows to left/right workspaces (tags)
	-- XXX: Assumes 9 tags. 
	awful.key({ modkey, "Control"	}, "Left",  move_window_prev_tag),
	awful.key({ modkey, "Control"	}, "Right", move_window_next_tag)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,


        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- Custom keymaps


