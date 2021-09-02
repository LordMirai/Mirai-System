AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

-- NW strings here

util.AddNetworkString("MSYS_NexusUse")
util.AddNetworkString("MSYS_NexusStatus")
util.AddNetworkString("MSYS_NEXUS_RequestDisconnectMonitor")
util.AddNetworkString("MSYS_NexusMonitorConnected")


-- end of NW strings

function ENT:Connections()
	local mon = (self.MonitorConnected == true) or false
	local dp = (self.DEEPConnected == true) or false
	local adm = false
	local usr = false
	local cm = false
	if dp then adm = (NEXUS.NEXUS.DEEP.ACUConnected or false) end
	if adm then usr = (self.DEEP.ACU.UUConnected or false) end
	if usr then cm = (self.DEEP.ACU.UU.CMMConnected or false) end

	local conn = {
		monitor = mon,
		deep = dp,
		admin = adm,
		user = usr,
		cmm = cm
	}
	print("conns:")
	PrintTable(conn)
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
	local rdy = true
	for k,v in pairs(self:Connections()) do
		if v == false then rdy = false end
	end
	return rdy
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
	if ((self:Ready()) == false) or (self:GetStatus() != NEXUS_SHUTDOWN) then
		print("considering this still passes, let's see")
		print(self:Ready() == false,self:GetStatus() != NEXUS_SHUTDOWN)
		net.Start("MSYS_NexusStatus")
		net.WriteEntity(self)
		net.WriteTable(self:Connections())
		net.Send(ply)
	elseif (self:Ready() == true) and self:GetStatus() == NEXUS_SHUTDOWN then

		self:SetStatus(NEXUS_ACTIVE)
		ply:Tell("Nexus started up successfully.")
		NEXUS.Log("Nexus started up by  '"..ply:Nick().."'  ("..ply:SteamID()..")")
	end
end

function ENT:StartTouch(peripheral)
	if peripheral:GetClass() == "msys_monitor" then
		if not peripheral.NexusConnected then
			self:ConnectMonitor(peripheral)
			NEXUS.NEXUS.Monitor = peripheral
			NEXUS.Log("Monitor connected. ("..peripheral:GetSerialKey()..")")
			peripheral.NexusConnected = true
			peripheral.NEXUS = self

			net.Start("MSYS_NexusMonitorConnected")
			net.WriteEntity(peripheral)
			net.Broadcast()

		end

	elseif peripheral:GetClass() == "msys_deep" then
		if not self.DEEPConnected and not peripheral.NexusConnected then
			self.DEEP = peripheral
			self.DEEPConnected = true
			NEXUS.Log("User Unit connected.")
			self.deepRope = constraint.Rope(self,peripheral, 0, 0, self:WorldToLocal(self:GetPos()), Vector(0,0,0), ROPE_LENGTH, 50, 0, 1, "cable/cable2", false)
			peripheral.NexusConnected = true
			peripheral.NEXUS = self
			hook.Run("MSYSPeripheralConnected",peripheral,self)
		end
	end
end

hook.Add("MSYSPeripheralConnected","HandleExteriorConnections",function(ent1,ent2)
	print("Periperal ",ent1," connected to peripheral ",ent2)
end)

net.Receive("MSYS_NEXUS_RequestDisconnectMonitor",function()
	local nex = net.ReadEntity()
	nex:DisconnectMonitor()
end)

MirUtil.Configurator["nexus"] = {
    action = function(ply,ent)
        print("nexus forced to be ready")

        ent.MonitorConnected = true
        ent.UUConnected = true
        ent.ACUConnected = true
        ent.CMMConnected = true
        ent.DEEPConnected = true
    end
}