AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- NW strings here

util.AddNetworkString("MSYS_NexusUse")
util.AddNetworkString("MSYS_NexusStatus")
util.AddNetworkString("MSYS_NEXUS_RequestDisconnectMonitor")


-- end of NW strings

function ENT:Connections()
	local conn = {
		monitor = self.MonitorConnected,
		user = self.UUConnected,
		admin = self.ACUConnected, 
		cmm = self.CMMConnected,
		deep = self.DEEPConnected
	}
	return conn
end

function ENT:Reset(dontLog)
	if not self:IsValid() then return end
	if dontLog == nil then dontLog = false end

	self.MonitorConnected = false
	self.UUConnected = false
	self.ACUConnected = false
	self.CMMConnected = false
	self.DEEPConnected = false

	self.Monitor = nil
	self.UU = nil
	self.ACU = nil
	self.CMM = nil
	self.DEEP = nil

	print("Nexus reset")
	if not dontLog then
		NEXUS.Log("NEXUS Reset")
	end
end

function ENT:Ready()
	if not self:IsValid() then return end
	return tobool(self.MonitorConnected == true and self.UUConnected == true and self.ACUConnected == true and self.CMMConnected == true and self.DEEPConnected == true)
end

function ENT:Initialize()
	self:SetModel("models/oldbill/riverserver1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	if self:IsValid() then
		self:Activate()
		NEXUS.Spawned = true
		NEXUS.Log("NEXUS spawned.")
	end

	self.IsNexus = true

	self:Reset(true)

	MSYS.TellAll("A new NEXUS has been created.")

	NEXUS.NEXUS = self -- so we can have a quick way to the entity
end

function ENT:Use(ply)
	if not self:IsValid() or not ply:IsValid() then return end
	if not self:Ready() or (self:GetStatus() != NEXUS_SHUTDOWN) then
		net.Start("MSYS_NexusStatus")
		net.WriteEntity(self)
		net.WriteTable(self:Connections())
		net.Send(ply)
	elseif self:Ready() and self:GetStatus() == NEXUS_SHUTDOWN then
		self:SetStatus(NEXUS_ACTIVE)
		ply:Tell("Nexus started up successfully.")
		NEXUS.Log("Nexus started up by  '"..ply:Nick().."'  ("..ply:SteamID()..")")
	end
end

function ENT:StartTouch(peripheral)
	if peripheral:GetClass() == "msys_monitor" then
		if not self.MonitorConnected then
			self.Monitor = peripheral
			self.MonitorConnected = true
			NEXUS.Log("Monitor connected.")
			self.monRope = constraint.Rope(self,peripheral, 0, 0, self:WorldToLocal(self:GetPos()), Vector(0,0,0), ROPE_LENGTH, 50, 0, 1, "cable/cable2", false)

			peripheral.NEXUS = self
		end

	elseif peripheral:GetClass() == "msys_uu" then
		if not self.UUConnected then
			self.UU = peripheral
			self.UUConnected = true
			NEXUS.Log("User Unit connected.")
		end
	end
end

net.Receive("MSYS_NEXUS_RequestDisconnectMonitor",function()
	local nex = net.ReadEntity()
	nex:DisconnectMonitor()
end)