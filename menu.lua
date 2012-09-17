-- AWESOME WINDOW MANAGER
-- MENU

-- There's really no need for a menu, but I'll keep it for now
mymainmenu = awful.menu({ 
	items = {
		{ "open terminal", TERMINAL },
   		{ "restart awm", awesome.restart },
   		{ "quit", awesome.quit }
	}
})

mylauncher = awful.widget.launcher({ 
	image = image(beautiful.awesome_icon),
    menu = mymainmenu 
})

