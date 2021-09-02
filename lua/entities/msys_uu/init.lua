AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube075x075x075.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:DrawShadow(false)

	self.IsUserUnit = true

	self.MonitorConnected = false
	self.ACUConnected = false
	self.CMMConnected = false

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	if self:IsValid() then
		self:Activate()
	end

end

function ENT:StartTouch(ent)
	if ent:GetClass() == "msys_monitor" then
		if not ent.UUConnected then
			self:ConnectMonitor(ent)
			ent.UUConnected = true
			ent.UU = self
		end
	end
	if ent:GetClass() == "msys_acu" then
		if not ent.UUConnected and not self.ACUConnected then
			ent.UUConnected = true
			ent.UU = self
			self.ACUConnected = true
			self.ACU = ent
			self.ACURope = constraint.Rope(self,ent, 0, 0, self:WorldToLocal(self:GetPos()), Vector(0,0,0), ROPE_LENGTH, 50, 0, 1, "cable/cable2", false)
			hook.Run("MSYSPeripheralConnected",ent,self)
		end
	end
	if ent:GetClass() == "msys_cmm" then
		if not ent.UUConnected and not self.CMMConnected then
			ent.UUConnected = true
			ent.UU = self
			self.CMMConnected = true
			self.CMM = ent
			self.CMMRope = constraint.Rope(self,ent, 0, 0, self:WorldToLocal(self:GetPos()), Vector(0,0,0), ROPE_LENGTH, 50, 0, 1, "cable/cable2", false)
			hook.Run("MSYSPeripheralConnected",ent,self)
		end
	end
end