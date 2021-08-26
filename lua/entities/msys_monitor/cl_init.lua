include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function MSYS.debugLogs(ply,monitor,akasha)
	akasha = akasha or false
	if not akasha then
		ply:Tell("Displaying debug logs for NEXUS\n(printed in console")
	else
		ply:Tell("Displaying debug logs for AKASHA\n(printed in console)")
	end
	local selLine = ""
	
	local logF = vgui.Create("DFrame")
	logF:SetTitle(not akasha and "[MSYS - NEXUS] Debug logs" or "[MSYS - AKASHA] Debug logs")
	MirUtil.ClassicFrame(logF,500,500)

	local logList = vgui.Create("DListVew",logF)
	logList:SetSize(450,400)
	logList:SetPos(15,10)
	logList:AddColumn("Log")
	logList:SetMultiSelect(false)
	logList.OnRowSelected = function(list,ind,row)
		selLine = row:GetValue(1)
	end
	if not akasha then
		for k,v in pairs(NEXUS.Logs) do
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
	MirUtil.Button(backB,logF,Color(140,80,10),Color(240,150,30))
	backB.DoClick = function()
		if monitor:IsValid() then
			MSYS.OpenMonitorView(ply,monitor)
		end
		logF:Remove()
	end

	local copyB = vgui.Create("DButton",logF)
	copyB:SetText("Copy line")
	copyB:SetSize(60,20)
	MirUtil.Button(copyB,logF,Color(60,12,32),Color(90,50,200))
	copyB.DoClick = function()
		if selLine == "" then
			ply:Tell("Na bro, you must select a line.",Color(250,0,0))
			return
		end
		SetClipboardText(selLine)
		ply:Tell("Line copied to clipboard.")
	end
end

-- MAIN MONITOR FUNCTION!!!
function MSYS.OpenMonitorView(ply,mon,clearTerminal)
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

		local unhide

		local hideB = vgui.Create("DButton",deb)
		hideB:SetSize(10,10)
		hideB:SetText("X")
		hideB:SetTextColor(Color(250,250,250))
		hideB:SetFont("MSYS_Monitor_Font_noshadow")
		function hideB:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
			draw.RoundedBox(0,1,1,w-2,h-2,Color(250,0,0))
		end
		hideB.DoClick = function()
			deb:SetVisible(false)
		end

		local unhide = vgui.Create("DButton",deb)
		unhide:SetSize(40,10)
		unhide:SetPos(200)
		unhide:SetText("Unhide debug")
		unhide:SetTextColor(Color(250,250,250))
		unhide:SetFont("MirUtilMenuFontSmall")
		MirUtil.Button(unhide,deb,Color(30,120,30),Color(20,225,20),function()
			if isvalid(hideB) then
				hideB:SetVisible(true)
			end
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
				MSYS.OpenMonitorView(ply,mon)
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
			MSYS.debugLogs(ply,mon)
			frame:Remove()
		end)

		local showAKLogs = vgui.Create("DButton",deb)
		showAKLogs:SetSize(100,25)
		showAKLogs:SetPos(50,120)
		showAKLogs:SetFont("MirUtilMenuFontSmall")
		showAKLogs:SetTextColor(Color(250,250,250))
		showAKLogs:SetText("Show Akasha logs")
		MirUtil.Button(showAKLogs,deb,Color(30,30,130),Color(25,20,220),function()
			MSYS.debugLogs(ply,mon,true)
			frame:Remove()
		end)


	end -- end of debug menu

	-- start of login sequence

	local loginPanel = vgui.Create("DPanel",frame)
	loginPanel:SetSize(130,70)
	loginPanel:SetPos(10,500)
	loginPanel:SetVisible(mon:GetAccessLevel() != LEVEL_NEXUS) -- no login panel if at top level.

	function loginPanel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(10,10,10))
		draw.RoundedBox(0,2,2,w-4,h-4,Color(220,220,220))
	end

	local user = vgui.Create("DTextEntry",loginPanel)
	user:SetSize(120,15)
	user:SetPos(5,10)
	user:SetPlaceholderText("Username")

	local pass = vgui.Create("DTextEntry",loginPanel)
	pass:SetSize(120,15)
	pass:SetPos(5,30)
	pass:SetPlaceholderText("Password")

	local loginBtt = vgui.Create("DButton",loginPanel)
	loginBtt:SetSize(80,15)
	loginBtt:SetPos(loginPanel:GetWide()/2-loginBtt:GetWide()/2,50)
	loginBtt:SetText("Login to "..mon:nextLevel())
	loginBtt:SetTextColor(Color(250,250,250))
	loginBtt:SetFont("MSYS_Monitor_Font")
	MirUtil.Button(loginBtt,loginPanel,Color(20,150,20),Color(10,250,20))

	function loginBtt:DoClick()
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
	termBtt:SetSize(120,40)
	termBtt:SetFont("MirUtilMenuFont")
	termBtt:SetTextColor(Color(250,250,250))
	termBtt:SetText("Open Terminal")
	MirUtil.Button(termBtt,frame,Color(91,91,165),Color(74,64,212),function()
		NEXUS.StartTerminal(ply,mon,clearTerminal)
		frame:Remove()
	end)



end
-- END OF MAIN MONITOR FUNCTION


net.Receive("MSYS_Monitor_Use", function()
	local ply = LocalPlayer()
	local mon = net.ReadEntity()

	MSYS.OpenMonitorView(ply,mon,true) -- the appended "true" implies erasing the terminal history as well.
end)