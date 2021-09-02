include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

local function requestLogs(mon,useAkasha)
	net.Start("MSYS_Request_FetchLogs")
	net.WriteEntity(LocalPlayer())
	net.WriteEntity(mon)
	net.WriteBool(useAkasha)
	net.SendToServer()
end

function MSYS.debugLogs(ply,monitor,akasha,logs)
	akasha = akasha or false
	if not akasha then
		ply:Tell("Displaying debug logs for NEXUS\n(printed in console")
	else
		ply:Tell("Displaying debug logs for AKASHA\n(printed in console)")
	end
	local selLine = ""
	
	local logF = vgui.Create("DFrame")
	logF:SetTitle(not akasha and "[MSYS - NEXUS] Debug logs" or "[MSYS - AKASHA] Debug logs")
	MirUtil.ClassicFrame(logF,640,700)

	local logList = vgui.Create("DListView",logF)
	logList:SetSize(550,600)
	logList:SetPos(15,40)
	logList:AddColumn("Log")
	logList:SetMultiSelect(false)
	logList.OnRowSelected = function(list,ind,row)
		selLine = row:GetValue(1)
	end
	if not akasha then
		print("logs received are:")
		PrintTable(logs)
		for k,v in pairs(logs) do
			logList:AddLine(v)
		end
	else

		for k,v in pairs(NEXUS.Akasha.Logs) do
			logList:AddLine(v)
		end
	end

	local backB = vgui.Create("DButton",logF)
	backB:SetText("Back")
	backB:SetSize(120,30)
	backB:SetPos(logF:GetWide()/2-backB:GetWide()/2,logF:GetTall()-backB:GetTall()-10)
	backB:SetTextColor(Color(250,250,250))
	backB:SetFont("MSYS_Monitor_Font")
	MirUtil.Button(backB,logF,Color(140,80,10),Color(240,150,30),function()
		if monitor:IsValid() then
			MSYS.OpenMonitorView()
		end
		logF:Remove()
	end)

	local copyB = vgui.Create("DButton",logF)
	copyB:SetText("Copy line")
	copyB:SetSize(60,20)
	copyB:SetPos(logF:GetWide()-copyB:GetWide()-10,30)
	MirUtil.Button(copyB,logF,Color(60,12,32),Color(90,50,200),function()
		if selLine == "" then
			ply:Tell("Na bro, you must select a line.",Color(250,0,0))
			return
		end
		SetClipboardText(selLine)
		ply:Tell("Line copied to clipboard.")
	end)
end

-- MAIN MONITOR FUNCTION!!!
function MSYS.OpenMonitorView(clearTerminal)
	local ply = LocalPlayer()
	local mon = NEXUS.NEXUS.Monitor
	if clearTerminal == nil then clearTerminal = false end
	local frame = vgui.Create("DFrame")
	MirUtil.ClassicFrame(frame,700,700)
	frame:SetTitle("[Mirai System] Monitor main view")

	local level = vgui.Create("DLabel",frame)
	level:SetSize(600,30)
	level:SetPos(10,30)
	level:SetFont("MSYS_Monitor_Font")
	level:SetTextColor(mon:AccessLevelColor())
	level:SetText("ACCESS LEVEL: "..mon:GetAccessLevelString())

	local status = vgui.Create("DPanel",frame)
	status:SetSize(400,400)
	status:SetPos(20,90)
	function status:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
		draw.RoundedBox(0,3,3,w-6,h-6,Color(120,120,120))

		draw.DrawText("MODULE STATUS","MSYS_Monitor_Font",self:GetWide()/2,5,Color(250,5,5,255),TEXT_ALIGN_CENTER)
	end

	if MSYS.DEBUG == true then
		local deb = vgui.Create("DPanel",frame)
		deb:SetSize(200,300)
		deb:SetPos(frame:GetWide()-deb:GetWide()-10,30)
		deb.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(10,10,10))
			draw.RoundedBox(0,2,2,w-4,h-4,Color(220,220,220))
			draw.DrawText("DEBUG MENU", "MSYS_Monitor_Font_noshadow", s:GetWide()/2,5,Color(155,155,155),TEXT_ALIGN_CENTER)
		end

		local unhide = vgui.Create("DButton",frame)
		unhide:SetSize(100,20)
		unhide:SetPos(550,80)
		unhide:SetText("Unhide debug")
		unhide:SetTextColor(Color(250,250,250))
		unhide:SetFont("MirUtilMenuFontSmall")
		unhide:SetVisible(false)

		local hideB = vgui.Create("DButton",deb)
		hideB:SetSize(15,15)
		hideB:SetPos(0,deb:GetTall()-hideB:GetTall())
		hideB:SetText("X")
		hideB:SetTextColor(Color(250,250,250))
		hideB:SetFont("MSYS_Monitor_Font_Small")
		function hideB:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			draw.RoundedBox(0,1,1,w-2,h-2,Color(250,0,0))
		end
		hideB.DoClick = function()
			deb:SetVisible(false)
			unhide:SetVisible(true)
		end

		MirUtil.Button(unhide,frame,Color(30,120,30),Color(20,225,20),function()
			deb:SetVisible(true)
			unhide:SetVisible(false)
		end)

		local accDrop = vgui.Create("DComboBox",deb)
		accDrop:SetSize(120,20)
		accDrop:SetPos(50,35)
		accDrop:SetSortItems(false)
		accDrop:SetValue("Set Access Level")
		accDrop:AddChoice("Surface",LEVEL_SURFACE)
		accDrop:AddChoice("Admin",LEVEL_ADMIN)
		accDrop:AddChoice("DEEP",LEVEL_DEEP)
		accDrop:AddChoice("Nexus",LEVEL_NEXUS)

		function accDrop:OnSelect(ind,name,level)
			if mon:IsValid() then
				mon:SetLevel(level)
				MSYS.OpenMonitorView()
			end
			frame:Remove()
		end

		local discNex = vgui.Create("DButton",deb)
		discNex:SetSize(100,25)
		discNex:SetPos(50,60)
		discNex:SetFont("MirUtilMenuFontSmall")
		discNex:SetTextColor(Color(250,250,250))
		discNex:SetText("Disconnect nexus")
		MirUtil.Button(discNex,deb,Color(130,30,30),Color(250,0,0),function()
			mon:DisconnectNexus()
			frame:Remove()
		end)

		local showLogs = vgui.Create("DButton",deb)
		showLogs:SetSize(100,25)
		showLogs:SetPos(50,90)
		showLogs:SetFont("MirUtilMenuFontSmall")
		showLogs:SetTextColor(Color(250,250,250))
		showLogs:SetText("Show logs")
		MirUtil.Button(showLogs,deb,Color(30,30,130),Color(25,20,220),function()
			requestLogs(mon,false)
			frame:Remove()
		end)

		local showAKLogs = vgui.Create("DButton",deb)
		showAKLogs:SetSize(100,25)
		showAKLogs:SetPos(50,120)
		showAKLogs:SetFont("MirUtilMenuFontSmall")
		showAKLogs:SetTextColor(Color(250,250,250))
		showAKLogs:SetText("Show Akasha logs")
		MirUtil.Button(showAKLogs,deb,Color(30,30,130),Color(25,20,220),function()
			requestLogs(mon,true)
			frame:Remove()
		end)


	end -- end of debug menu

	-- start of login sequence

	local loginPanel = vgui.Create("DPanel",frame)
	loginPanel:SetSize(210,80)
	loginPanel:SetPos(20,500)
	loginPanel:SetVisible(mon:GetAccessLevel() != LEVEL_NEXUS) -- no login panel if at top level.

	function loginPanel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(10,10,10))
		draw.RoundedBox(0,2,2,w-4,h-4,Color(220,220,220))
	end

	local user = vgui.Create("DTextEntry",loginPanel)
	user:SetSize(190,15)
	user:SetPos(10,10)
	user:SetPlaceholderText("            	           Username")

	local pass = vgui.Create("DTextEntry",loginPanel)
	pass:SetSize(190,15)
	pass:SetPos(10,30)
	pass:SetPlaceholderText("            	           Password")

	local loginBtt = vgui.Create("DButton",loginPanel)
	loginBtt:SetSize(190,18)
	loginBtt:SetPos(loginPanel:GetWide()/2-loginBtt:GetWide()/2,50)
	loginBtt:SetText("Login to "..(MSYS.LevelStrings[mon:nextLevel()] or ""))
	loginBtt:SetTextColor(Color(250,250,250))
	loginBtt:SetFont("MSYS_Monitor_Font_Small")
	MirUtil.Button(loginBtt,loginPanel,Color(20,150,20),Color(10,250,20), function()
		local us = user:GetValue()
		local ps = pass:GetValue()

		if MSYS.err(us) then
			ply:Tell("Improper input of Username.",Color(220,10,10))
			return
		end
		if MSYS.err(ps) then
			ply:Tell("Improper input of Password.",Color(220,10,10))
			return
		end

		MSYS.attemptLogin(ply,us,ps,mon)
		frame:Remove()
	end)

	pass.OnEnter = function() -- copy paste seemed necessary. sorry.
		local us = user:GetValue()
		local ps = pass:GetValue()

		if MSYS.err(us) then
			ply:Tell("Improper input of Username.",Color(220,10,10))
			return
		end
		if MSYS.err(ps) then
			ply:Tell("Improper input of Password.",Color(220,10,10))
			return
		end

		MSYS.attemptLogin(ply,us,ps,mon)
		frame:Remove()
	end

	-- end login sequence

	local termBtt = vgui.Create("DButton",frame)
	termBtt:SetSize(220,40)
	termBtt:SetPos(450,500)
	termBtt:SetFont("MirUtilMenuFont")
	termBtt:SetTextColor(Color(250,250,250))
	termBtt:SetText("Open Terminal")
	termBtt:SetVisible(mon:Allowed(LEVEL_ADMIN))
	MirUtil.Button(termBtt,frame,Color(91,91,165),Color(74,64,212),function()
		NEXUS.StartTerminal(clearTerminal)
		frame:Remove()
	end)



end
-- END OF MAIN MONITOR FUNCTION


net.Receive("MSYS_Monitor_Use", function()
	local ply = LocalPlayer()
	local mon = net.ReadEntity()

	MSYS.OpenMonitorView(true) -- the appended "true" implies erasing the terminal history as well.
end)

net.Receive("MSYS_Request_SendLogs", function()
	local ply = LocalPlayer()
	local monitor = net.ReadEntity()
	local akasha = net.ReadBool()
	local logs = net.ReadTable()

	MSYS.debugLogs(ply,monitor,akasha,logs)
end)