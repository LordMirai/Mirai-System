AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/gman.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()

	self:SetNPCState(NPC_STATE_IDLE)
	self:SetSolid(SOLID_BBOX)
	self:DropToFloor()
	self:SetUseType(SIMPLE_USE)

	if self:IsValid() then self:Activate() end

end

function ENT:Use(ply)
	self:DropToFloor()
	
end
