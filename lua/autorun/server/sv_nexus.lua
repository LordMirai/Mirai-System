MSYS = MSYS or {}
NEXUS = NEXUS or {}

hook.Add("Initialize","InitNEXUSNum",function()
	NEXUS.Spawned = false
end)

hook.Add("PlayerSpawnSENT","PreventSpawnOfNEXUS",function(ply,cls)
	if cls == "nexus" then
		if not ply:IsSuperAdmin() then
			ply:Tell("No, you can't spawn this.",Color(250,0,0))
			return false
		end

		if NEXUS.Spawned then
			MSYS.TellAll(ply:Nick().." tried spawning another NEXUS, when one exists already.")
			return false
		end
	end

end)

net.Receive("MSYS_AKASHA_RequestLog", function()
	local msg = net.ReadString()
	NEXUS.Akasha.Log(msg)
end)

net.Receive("MSYS_NEXUS_RequestLog", function()
	local msg = net.ReadString()
	NEXUS.Log(msg)
end)

print("SV nexus.lua reloaded.")