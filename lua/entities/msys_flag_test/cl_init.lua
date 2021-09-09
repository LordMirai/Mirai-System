include("shared.lua")

function ENT:Draw()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) <= 40000 then
		self:DrawCamText("Vehicle Man","MirUtilNPCFont",Color(60,60,180),80,true)
	end
	self:DrawModel()
end

local function requestSpawn(ply,npc,name,class,model,zOffset,simphys)
	print("requestSpawn has been called.\n",ply,npc,"\n",name,class,zOffset,simphys)
	ply.HasVehicleDeployed = true
	ply.DeployedVehicleName = name
	net.Start("MU_RequestSpawnVehicle")
	net.WriteEntity(ply)
	net.WriteEntity(npc)
	net.WriteString(name)
	net.WriteString(class)
	net.WriteString(model)
	net.WriteFloat(zOffset or 0)
	net.WriteBool(simphys)
	net.SendToServer()
end

function MirUtil.GenerateButtons(tab,parent,ply,xOffset,yMultiplier,yOffset,forceCallback,npc)
	-- if we don't have values for those, start at 0
	if not xOffset then xOffset = 0 end
	if not yMultiplier then yMultiplier = 0 end
	if not yOffset then yOffset = 0 end


	for k,v in pairs(tab) do
		local addedButton = vgui.Create("DButton",parent)
		local textCol = v.textCol
		if textCol == nil or textCol == Color(0,0,0) then textCol = Color(255,255,255) end -- if it has no entry, assume default.
		if isstring(textCol) then textCol = string.ToColor(textCol) end
		
		local font = v.textFont and v.textFont or "MirUtilMenuFontSmall"

		addedButton:SetSize(100,30)
		addedButton:SetPos(xOffset,k*yMultiplier+yOffset)
		addedButton:SetText(v.name)
		addedButton:SetVisible(not ply.HasVehicleDeployed)
		addedButton:SetTextColor(textCol)
		addedButton.fcolor = v.defaultCol and v.defaultCol or Color(180,110,10)
		addedButton.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			draw.RoundedBox(0,1,1,w-2,h-2,s.fcolor)
		end
		addedButton:SetFont(font)
		addedButton.OnDepressed = function()
			addedButton.fcolor = v.pressedCol and v.pressedCol or Color(255,160,10)
		end
		addedButton.OnReleased = function()
			addedButton.fcolor = v.defaultCol and v.defaultCol or Color(180,110,10)
			forceCallback(ply,npc,v.name,v.class,v.model or "",v.offset or 0,v.simphys or false)
			timer.Simple(0.01,function() parent:Remove() end)
		end
	end
end

function ENT:openMenu(ply,ent)
	local frame = vgui.Create("DFrame")
	MirUtil.ClassicFrame(frame,400,400)
	frame:SetTitle("[MiraiUtil] Vehicle Deployment NPC    (main frame)")
	MirUtil.GenerateButtons(MirUtil.VehicleTable,frame,ply,25,40,20,requestSpawn,ent)

	local deton = vgui.Create("DButton",frame)
	deton:SetSize(150,50)
	deton:SetPos(200,150)
	deton:SetText("Detonate Vehicle")
	deton:SetFont("MirUtilMenuFont")
	deton:SetTextColor(Color(250,250,250))
	deton:SetVisible(ply.HasVehicleDeployed)
	MirUtil.Button(deton,frame,Color(190,20,20),Color(255,0,0),function()
		net.Start("MU_RequestDetonateVehicle")
		net.WriteEntity(ply)
		net.SendToServer()

		ply.HasVehicleDeployed = false
		frame:Remove()
	end)

	local depVeh = vgui.Create("DLabel",frame)
	depVeh:SetSize(frame:GetWide(),50)
	depVeh:SetPos(150,100)
	depVeh:SetVisible(ply.HasVehicleDeployed)
	depVeh:SetText("You currently have a \n\""..(ply.DeployedVehicleName or "ERROR - SHOULDN'T SHOW").."\" deployed.")
	depVeh:SetTextColor(Color(250,0,0))
	depVeh:SetFont("MirUtilMenuFont")
end

net.Receive("MU_OpenVehicleNPCMenu", function()
	local ent = net.ReadEntity()
	local ply = LocalPlayer()
	ent:openMenu(ply,ent)
end)