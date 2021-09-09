AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("MSYS_WUConnect")
util.AddNetworkString("MSYS_WUConnectPeripheral")
util.AddNetworkString("MSYS_AttemptPeripheralConnection")
util.AddNetworkString("MSYS_RequestWriteTerminal")

local function reply(ply,msgCode)
	local msg = MSYS.Errors[msgCode]

	net.Start("MSYS_RequestWriteTerminal")
	net.WriteString(msg)
	net.Send(ply)
end

function ENT:Initialize()
	self:SetModel("models/unconid/atari/atari_2600_4switch.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:DrawShadow(false)

	self.IsWU = true
	self.CMMConnected = false

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	if self:IsValid() then
		self:Activate()
	end
	self.ConnectedPeripherals = {}

end

function ENT:StartTouch(ent)
	if ent.IsCMM then
		if not self.CMMConnected and not ent.WUConnected then
			if NEXUS.NEXUS.CMM == ent then -- that CMM is the one connected to the nexus
				MSYS.TellAll("WE CONNECTING THIS YET???")
				NEXUS.NEXUS.CMM.WU = wu
				NEXUS.NEXUS.WU = wu
				NEXUS.NEXUS.WUConnected = true
				
				net.Start("MSYS_WUConnect")
				net.WriteEntity(self)
				net.WriteEntity(ent)
				net.Broadcast()
			end	-- otherwise, we'll re-attempt the connection with 'module connect'
			self.cmmRope = constraint.Rope(self,ent, 0, 0, self:WorldToLocal(self:GetPos()), Vector(0,0,0), ROPE_LENGTH, 50, 0, 1, "cable/cable2", false)
			self.CMMConnected = true
			ent.WUConnected = true
			ent.WU = self
		end
	end
end

function ENT:ConnectPeripheral(perip,ply)
-- the player entity being called here is so we can insert the msg into the terminal, regardless of outcome.
	if not perip then
		reply(ply,PERIP_CONN_NOT_FOUND)
		return
	end
	local perTable = {
		name = perip.PeripheralName,
		serial = perip:GetSerialKey(),
		ent = perip
	}

	for k,v in pairs(self.ConnectedPeripherals) do
		if v.serial == perTable.serial then
			ply:Tell("Cannot connect to "..perTable.name.." (already connected.)")
			reply(ply,PERIP_CONN_FAIL)
			return
		end
	end
	if perTable.ent.WUConnected then
		ply:Tell("Cannot connect to "..perTable.name.." (peripheral connected to another WU.)")
		reply(ply,PERIP_CONN_FAIL)
		return
	end

	table.insert(self.ConnectedPeripherals,perTable)

	perTable.ent.WUConnected = true
	perTable.ent.WU = self

	net.Start("MSYS_WUConnectPeripheral")
	net.WriteEntity(self)
	net.WriteEntity(ply and ply or Entity(0))
	net.WriteTable(perTable)
	net.Broadcast()
end

net.Receive("MSYS_AttemptPeripheralConnection", function()
	local ply = net.ReadEntity()
	local id = net.ReadString()
	local wu = NEXUS.NEXUS.CMM.WU

	wu:ConnectPeripheral(ents.GetBySerial(id),ply)
end)