AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("MSYS_WUConnect")

function ENT:Initialize()
	self:SetModel("models/maxofs2d/motion_sensor.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:DrawShadow(false)

	self.IsWirelessPeripheral = true
	self.WUConnected = false

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	if self:IsValid() then
		self:Activate()
	end
	self:SetSerialKey("SENS_"..math.random(1000,9999))

end

function ENT:WirelessConnect(wu)
	PrintMessage(HUD_PRINTTALK,"Sensor "..self:GetSerialKey().." connected to wireless unit.")

	self.WUConnected = true
	self.WU = wu
end

function ENT:Use(ply)
	if MSYS.DEBUG then
		ply:Tell("Serial: "..self:GetSerialKey())
	end
end