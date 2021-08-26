MSYS = MSYS or {}



net.Receive("MSYS_RequestBroadcast",function()
	local str = net.ReadString()
	local col = net.ReadColor()
	MSYS.TellAll(str,col)
end)

print("sv_msys.lua reloaded.")