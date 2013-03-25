-- Functions to manipulate clients
-- Copyright 2013 Brandon Thomas


-- Hide a client
function hide_client(c)
	c.minimized = true
end

-- Kill a client
function kill_client(c) 
	c:kill() 
end

-- Kill all clients on tag
function kill_clients_on_tag(t)
	for ck, cv in ipairs(t.clients(t)) do
		cv:kill()
	end
end

-- Minimize all clients on tag
function minimize_clients_on_tag(t)
	for ck, cv in ipairs(t.clients(t)) do
		cv.minimized = true
	end
end

function unminimize_clients_on_tag(t)
	for ck, cv in ipairs(t.clients(t)) do
		if cv.minimized then
			cv:raise()
		end
		cv.minimized = false
	end
end

-- Kill all clients on the current tag
function kill_clients_on_cur_tag()
	kill_clients_on_tag(awful.tag.selected(mouse.screen))
end

function minimize_clients_on_cur_tag()
	minimize_clients_on_tag(awful.tag.selected(mouse.screen))
end

function unminimize_clients_on_cur_tag()
	unminimize_clients_on_tag(awful.tag.selected(mouse.screen))
end

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

-- Move client around current tag
function swap_client_next() 
	awful.client.swap.byidx(1) 
end

function swap_client_prev() 
	awful.client.swap.byidx(-1) 
end

-- Move client to left tag
function move_client_prev_tag(c)
	local curidx = awful.tag.getidx(c:tags()[1])
	if curidx == 1 then
		c:tags({screen[mouse.screen]:tags()[AWESOME_NUM_TAGS]})
	else
		c:tags({screen[mouse.screen]:tags()[curidx - 1]})
	end
	awful.tag.viewprev()
end

-- Move client to right tag
function move_client_next_tag(c)
	local curidx = awful.tag.getidx(c:tags()[1])
	if curidx == AWESOME_NUM_TAGS then
		c:tags({screen[mouse.screen]:tags()[1]})
	else
		c:tags({screen[mouse.screen]:tags()[curidx + 1]})
	end
	awful.tag.viewnext()
end

