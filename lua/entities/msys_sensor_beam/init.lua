AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("MSYS_SensorPair")

function ENT:Initialize()
	self:SetModel("models/maxofs2d/motion_sensor.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
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
	end
	self:SetActive(false)
	self.parent = Entity(0)
end

function ENT:Pair(parent)
	print("Sensor beam parented to ",parent,parent:GetSerialKey())
	self.parent = parent

	parent:DeleteOnRemove(self)
end

net.Receive("MSYS_SensorPair", function()
	local beam = net.ReadEntity()
	local sensor = net.ReadEntity()
	beam:Pair(sensor)
end)

function ENT:Use(ply)
	if not MSYS.DEBUG then return end

	
end