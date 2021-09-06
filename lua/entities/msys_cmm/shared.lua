ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Cross Medium Module"
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
		self.Monitor.CMMConnected = false
		self.Monitor.CMM = nil
	end

	if self.WUConnected then
		if not self.WU:IsValid() then return end
		self.WU.CMMConnected = false
		self.WU.CMM = nil
	end

end