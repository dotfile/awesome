--[[
Extra Awesome Window Manager Functions
by Brandon Thomas 
* echelon@gmail/github
* http://posbl.org
]]--



-- Determine if battery is charging
-- FIXME: I don't know AWK very well
function batt_is_charging()
	local device = '/org/freedesktop/UPower/devices/battery_' .. BATTERY_NAME
	local cmd = 'upower -i '..device..' | grep state'

	local fp = io.popen(cmd)

	for r in string.gmatch(fp:read(), 'discharging') do
		return false 
	end	
	return true 
end


-- Notification alert with text.
function alert(text)
	awful.util.spawn_with_shell('notify-send "'..text..'"')
end


-- Get the cwd of the process pid
function process_get_cwd(pid) 
	local fp = io.popen("readlink /proc/" .. pid .. "/cwd")
	return fp:read()
end


-- Get subprocess pid
-- (This is useful for getting the bash underlying urxvt)
function process_get_subproc_pid(pid)
	local fp = io.popen("ps -ef | awk '$3=="..pid.." { print $2 }'")
	return fp:read()
end


-- Open a terminal with at the same CWD as the current 
-- terminal client
-- Optional arg: current client
-- (Install this function into client keybindings)
function open_terminal_same_cwd(client)
	if not client then
		client = awful.client.next(0)
	end

	if not client then
		awful.util.spawn_with_shell(TERMINAL)
		return
	end

	local pid = client.pid
	local subpid = process_get_subproc_pid(pid)

	if subpid then
		pid = subpid
	end

	local cwd = process_get_cwd(pid)
	awful.util.spawn_with_shell(TERMINAL_CWD .. " " .. cwd)	
end
