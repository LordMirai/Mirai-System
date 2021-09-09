MSYS = MSYS or {}
NEXUS = NEXUS or {}

function MSYS.spawnNexusSystem(ply)
	MirUtil.TellAll(ply:Nick().." spawned the entire nexus system.")
	local point = ply:GetEyeTrace().HitPos
	point = point + Vector(0,0,120)

	entTab = {
		"msys_wireless_sensor","msys_monitor","msys_wu","msys_cmm","msys_uu","msys_acu","msys_deep","nexus"
	}
	undo.Create("[MSYS] Nexus system")
	timer.Create("MSYS_SpawnNexus_timer",1,#entTab,function()
		print(timer.RepsLeft("MSYS_SpawnNexus_timer")+1)
		local ent = ents.Create(entTab[timer.RepsLeft("MSYS_SpawnNexus_timer")+1])
		ent:SetPos(point+Vector(40*timer.RepsLeft("MSYS_SpawnNexus_timer"),0,20))
		ent:Spawn()
		undo.AddEntity(ent)
		undo.SetPlayer(ply)
		undo.Finish("Deleted nexus system")
	end)

end

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