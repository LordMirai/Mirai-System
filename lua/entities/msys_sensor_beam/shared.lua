MSYS = MSYS or {}

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Sensor Beam"..(MSYS.DEBUG and "(DEBUG FOR VIEW)" or "")
ENT.Category = "Mirai System"
ENT.Spawnable = MSYS.DEBUG
ENT.AdminSpawnable = MSYS.DEBUG

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = ""
ENT.Instructions = "E then we see."
ENT.Contact = "cocomemelol@yahoo.com | Lord Mirai(未来)#0039"


function ENT:SetupDataTables()
	self:NetworkVar("Bool",0,"Active")
end