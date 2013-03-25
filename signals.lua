
--[[ ======================================
		  Signal Handler Installation	
	 ====================================== --]]

-- XXX: See signals doc,
-- http://awesome.naquadah.org/wiki/Signals

-- New Client Spawns 
-- When a new client window appears, hint it, etc.
client.add_signal("manage", function (c, startup)
	if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others 
		-- instead of setting it master.
        awful.client.setslave(c)

        -- Put windows in a smart way, only if 
		-- they don't set an initial position.
        if not c.size_hints.user_position and 
			not c.size_hints.program_position then
				awful.placement.no_overlap(c)
				awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) 
	c.border_color = beautiful.border_focus 
end)

client.add_signal("unfocus", function(c) 
	c.border_color = beautiful.border_normal 
end)

-- New client added
--client.add_signal("new", function() end)
--
