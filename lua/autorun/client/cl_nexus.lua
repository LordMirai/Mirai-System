MSYS = MSYS or {}

net.Receive("NEXUS_ClearLogs", function()
	NEXUS.Logs = {}
end)

print("CL nexus.lua reloaded.")