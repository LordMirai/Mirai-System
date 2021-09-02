include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
	if self:IsValid() then
		NEXUS.NEXUS = self
	end
end

function ENT:PrintStatus(connections) -- this is very ugly, I know, but this is the only way it works. You can't transmit this info any other way.
	print("clientside connections:")
	PrintTable(connections)
	chat.AddText(
		Color(100,20,255),"\n\n[MSYS - NEXUS] Nexus connection (module) status: \n\n",
		Color(250,250,250),
		"Monitor: ",connections.monitor and Color(23,196,23) or Color(170,19,19),connections.monitor and "Connected" or "Not Connected",Color(250,250,250),"\n",
		"User Unit: ",connections.user and Color(23,196,23) or Color(170,19,19),connections.user and "Connected" or "Not Connected",Color(250,250,250),"\n",
		"Admin Control Unit: ",connections.admin and Color(23,196,23) or Color(170,19,19),connections.admin and "Connected" or "Not Connected",Color(250,250,250),"\n",
		"Cross-Medium Module: ",connections.cmm and Color(23,196,23) or Color(170,19,19),connections.cmm and "Connected" or "Not Connected",Color(250,250,250),"\n",
		"Database Enhanced Execution Point: ",connections.deep and Color(23,196,23) or Color(170,19,19),connections.deep and "Connected" or "Not Connected",Color(250,250,250),"\n",		
		"Overall status:  ",(connections.monitor and connections.user and connections.admin and connections.cmm and connections.deep) and Color(15,250,15) or Color(250,15,15),(connections.monitor and connections.user and connections.admin and connections.cmm and connections.deep) and "READY!" or "NOT READY",Color(250,250,250),
		"\n==================================================\n"
	)
end

net.Receive("MSYS_NexusStatus", function()
    local ply = LocalPlayer()
    local nexus = net.ReadEntity()
	local conns = net.ReadTable()
    nexus:PrintStatus(conns)
end)


net.Receive("MSYS_NexusMonitorConnected", function()
	local mon = net.ReadEntity()
	NEXUS.NEXUS.Monitor = mon
end)