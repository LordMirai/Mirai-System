MSYS = MSYS or {}

net.Receive("NEXUS_ClearLogs", function()
	NEXUS.Logs = {}
end)

net.Receive("MSYS_UpdateNexusClientside", function()
    local nex = net.ReadEntity()
    NEXUS.NEXUS = nex
end)

net.Receive("MSYS_UpdateNexusClientsideFinal", function()
	local nex = net.ReadEntity()
	local dp = net.ReadEntity()
	local acu = net.ReadEntity()
	local uu = net.ReadEntity()
	local cmm = net.ReadEntity()

	nex.DEEP = dp
	nex.ACU = acu
	nex.UU = uu
	nex.CMM = cmm

	NEXUS.NEXUS = nex
end)

print("CL nexus.lua reloaded.")