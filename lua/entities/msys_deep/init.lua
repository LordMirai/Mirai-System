AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:DrawShadow(false)

	self.IsDEEP = true
	self.NexusConnected = false
	self.MonitorConnected = false
	self.ACUConnected = false


	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	if self:IsValid() then
		self:Activate()
	end

end

function ENT:StartTouch(ent)
	if ent:GetClass() == "msys_acu" then
		if not self.ACUConnected and not ent.DEEPConnected then
			print("DEEP connected with ACU")
			self.ACUConnected = true
			ent.DEEPConnected = true

			self.ACU = ent
			ent.DEEP = self
			self.ACURope = constraint.Rope(self,ent, 0, 0, self:WorldToLocal(self:GetPos()), Vector(0,0,0), ROPE_LENGTH, 50, 0, 1, "cable/cable2", false)
			hook.Run("MSYSPeripheralConnected",ent,self)
		end
	end

	if ent:GetClass() == "msys_monitor" then
		if not ent.DEEPConnected then
			print("DEEP connected with Monitor")
			ent.DEEPConnected = true
			ent.DEEP = self
			self:ConnectMonitor(ent)
		end
	end
end