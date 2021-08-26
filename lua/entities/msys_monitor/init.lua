AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("MSYS_Monitor_Use")
util.AddNetworkString("MSYS_Monitor_RequestDisconnectNexus")

function ENT:Initialize()
	self:SetModel("models/alec/alsys/alec_alec_monitor_bigger_02e.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:DrawShadow(false)

	self.IsMonitor = true

	self:SetAccessLevel(LEVEL_SURFACE)
end

function ENT:Use(ply)
	if not ply:IsPlayer() then return end
	if not self.NEXUS then
		ply:Tell("Monitor is not connected to a NEXUS")
		return
	end

	if not self.NEXUS:IsActive() then
		ply:Tell("Connected NEXUS is not active")
		return
	end

	NEXUS.Log("'"..ply:Nick().."' used a monitor.")
	net.Start("MSYS_Monitor_Use")
	net.WriteEntity(self)
	net.Send(ply)
end

net.Receive("MSYS_Monitor_RequestDisconnectNexus", function()
	local mon = net.ReadEntity()
	mon:DisconnectNexus()
end)