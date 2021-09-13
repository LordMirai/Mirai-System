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
	self:CapabilitiesAdd(CAP_MOVE_GROUND)

	self:SetHealth(12569042)

	if self:IsValid() then self:Activate() end

	self:SetFlag(FLAG_INITIAL)
	self.usedTimes = 0
end

function ENT:sayDialogue(ply)
	if table.IsEmpty(self.MSYSFlags) then
		print("flag table empty.")
		return
	end
	for k,v in pairs(self.MSYSFlags) do
		if v == 1 then
			ply:Tell(" {FLAGTEST}  "..table.random(self.Dialogue[k]))
		end
	end
end

function ENT:Use(ply)
	self:DropToFloor()
	self.usedTimes = self.usedTimes + 1
	MirUtil.RequestMessage(ply,"Flagtest entity used "..self.usedTimes.." times.")
	if self:HasFlag(FLAG_INITIAL) then
		self:sayDialogue(ply)
		self:UnsetFlag(FLAG_INITIAL)
		self:SetFlag(FLAG_USED_ONCE)
	end
	if self:HasFlag(FLAG_USED_ONCE) then
		self:sayDialogue(ply)
		self:UnsetFlag(FLAG_USED_ONCE)
		self:SetFlag(FLAG_MULTIPLE_USE)
	end

	if self:HasFlag(FLAG_MULTIPLE_USE) then
		self:sayDialogue(ply)
	end
end

function ENT:OnTakeDamage(dmginfo)
	local ply = dmginfo:GetAttacker()
	if self:HasFlag(FLAG_INITIAL) then
		self:UnsetFlag(FLAG_INITIAL)
		self:SetFlag(FLAG_DAMAGE_TAKEN)
	end

	if self:HasFlag(FLAG_DAMAGE_TAKEN) then
		self:UnsetFlag(FLAG_DAMAGE_TAKEN)
		self:SetFlag(FLAG_DAMAGED_2)
	end

	if self:HasFlag(FLAG_DAMAGED_2) then
		self:UnsetFlag(FLAG_DAMAGED_2)
		self:SetFlag(FLAG_DAMAGED_3)
	end

	if self:HasFlag(FLAG_DAMAGED_3) then
		self:UnsetFlag(FLAG_DAMAGED_3)
		self:SetFlag(FLAG_DAMAGED_4)
	end

	if self:HasFlag(FLAG_DAMAGED_4) then
		self:UnsetFlag(FLAG_DAMAGED_4)
		self:SetFlag(FLAG_DAMAGED_FINAL)
	end

	if self:HasFlag(FLAG_DAMAGED_FINAL) then
		ply:Ignite(3,5)
		timer.Simple(3, function()
			if not ply:IsValid() or not ply:Alive() then return end
			local efD = EffectData()
			efD:SetScale(10)
			efD:SetOrigin(ply:GetPos())
			util.Effect(efD)
			ply:TakeDamage(99999, self, self)
			if ply:Alive() then
				ply:Kill()
			end
		end)
	end

	self:sayDialogue(ply)

end