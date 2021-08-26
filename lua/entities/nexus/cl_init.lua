include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

local function check(conn,noEOL)
	if conn then
		return Color(23,196,23),"Connected",Color(250,250,250),(noEOL and "" or "\n")
	else
		return Color(170,19,19),"Not Connected",Color(250,250,250),(noEOL and "" or "\n")
	end
end

function ENT:PrintStatus(connections)
	chat.AddText(
		Color(100,20,255),"\n[MSYS - NEXUS] Nexus connection (module) status: \n\n",
		Color(250,250,250),
		"Monitor: ",check(connections.monitor),
		"User Unit: ",check(connections.user),
		"Admin Control Unit: ",check(connections.admin),
		"Cross-Medium Module: ",check(connections.cmm),
		"Database Enhanced Execution Point: ",check(connections.deep),
		if (connections.monitor and connections.user and connections.admin and connections.cmm and connections.cmm) then
			"Overall status:  ",Color(15,250,15),"READY!\n",
		else
			"Overall status:  ",Color(250,15,15),"NOT READY!\n",
		end
		"==================================================",
		"\n\n"
	)
end

net.Receive("MSYS_NexusStatus", function()
    local ply = LocalPlayer()
    local nexus = net.ReadEntity()
	local conns = net.ReadTable()
    nexus:PrintStatus(conns)
end)
