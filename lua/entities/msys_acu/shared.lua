ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Admin Control Unit"
ENT.Category = "Mirai System"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = ""
ENT.Instructions = "E then we see."
ENT.Contact = "cocomemelol@yahoo.com | Lord Mirai(未来)#0039"

MSYS = MSYS or {}

function ENT:OnRemove() -- we will use this to formally disconnect everything
	if self.MonitorConnected then
		if not self.Monitor:IsValid() then return end
		self.Monitor.ACUConnected = false
		self.Monitor.ACU = nil
	end

	if self.DEEPConnected then
		if not self.DEEP:IsValid() then return end
		self.DEEP.ACUConnected = false
		self.DEEP.ACU = nil
	end

	if self.UUConnected then
		if not self.UU:IsValid() then return end
		self.UU.ACUConnected = false
		self.UU.ACU = nil
	end

end