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

	self.IsCMM = true
	self.WUConnected = false

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	if self:IsValid() then
		self:Activate()
	end

end


function ENT:StartTouch(ent)
	if ent.IsWU then
		if not self.WUConnected and not ent.CMMConnected then

		end
	end
end