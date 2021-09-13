include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

net.Receive("MSYS_WUConnect",function()
	local wu = net.ReadEntity()
	local cmm = net.ReadEntity()

	-- print("connect message: ",wu,cmm)
	NEXUS.NEXUS.WUConnected = true
	NEXUS.NEXUS.CMM.WU = wu
	NEXUS.NEXUS.WU = wu
end)

function ENT:Initialize()
	self.ConnectedPeripherals = {}
end

net.Receive("MSYS_WUConnectPeripheral", function()
	local wu = net.ReadEntity()
	local ply = net.ReadEntity()
	local perTable = net.ReadTable()

	if not ply:IsWorld() then
		if ply.activeTxtInput then -- thing is still open
			tprint("Successfully connected "..perTable.name.." ["..perTable.serial.."] to Wireless Unit.")
		end
	end

	perTable.ent.WUConnected = true
	perTable.ent.WU = self
	
	table.insert(wu.ConnectedPeripherals,perTable)
end)

net.Receive("MSYS_RequestWriteTerminal", function()
	local ply = LocalPlayer()
	local msg = net.ReadString()
	if ply.activeTxtInput then
		ply.activeTxtInput:AppendText(msg)
	end
end)
