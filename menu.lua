-- AWESOME WINDOW MANAGER
-- MENU

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ 
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal }
	}
})

mylauncher = awful.widget.launcher({ 
	image = image(beautiful.awesome_icon),
    menu = mymainmenu 
})

