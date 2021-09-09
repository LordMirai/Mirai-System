include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	-- attempt to draw a beam
	render.DrawBeam(self:GetPos(),self:GetPos()+self:GetForward()*40,3,self:GetPos(),self:GetPos()+self:GetForward()*40,Color( 25, 195, 195 ))
end