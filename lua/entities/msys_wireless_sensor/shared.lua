ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Sensor (Wireless peripheral)"
ENT.PeripheralName = "Sensor"
ENT.Category = "Mirai System"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = ""
ENT.Instructions = "E then we see."
ENT.Contact = "cocomemelol@yahoo.com | Lord Mirai(未来)#0039"

MSYS = MSYS or {}

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"SerialKey")
end