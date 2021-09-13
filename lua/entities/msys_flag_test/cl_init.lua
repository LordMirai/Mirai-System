include("shared.lua")

function ENT:Draw()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) <= 40000 then
		self:DrawCamText("Flag Test","MirUtilNPCFont",Color(60,60,180),80,true)
	end
	self:DrawModel()
end
