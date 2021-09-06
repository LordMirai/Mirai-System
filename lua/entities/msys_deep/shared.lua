ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "DEEP Unit"
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
		self.Monitor.DEEPConnected = false
		self.Monitor.DEEP = nil
	end

	if self.NexusConnected then
		if not NEXUS.NEXUS:IsValid() then return end
		NEXUS.NEXUS.DEEPConnected = false
		NEXUS.NEXUS.DEEP = nil
	end

end