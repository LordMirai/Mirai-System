MSYS = MSYS or {}
NEXUS = NEXUS or {}
MirUtil = MirUtil or {}

local function insertTerminal(text,noParse)
	if noParse == nil then noParse = false end
	local ply = LocalPlayer()
	if not file.Exists("MSYS","DATA") then
		file.CreateDir("MSYS")
	end
	if not file.Exists("MSYS/client_terminal.txt","DATA") then
		file.Write("MSYS/client_terminal.txt","") -- write nothing :)
	end	

	local prettyTable = util.JSONToTable(file.Read("MSYS/client_terminal.txt","DATA")) or {}

	table.insert(prettyTable,"\n"..text)
	file.Write("MSYS/client_terminal.txt",util.TableToJSON(prettyTable,true))
	if noParse then
		if ply.activeTxtInput then
			ply.activeTxtInput:AppendText("\n"..text)
		end
    else
    	if ply.activeTxtInput then
			ply.activeTxtInput:AppendText("\n> "..text)
		end
		NEXUS.Log("Terminal command run: "..text.." from '"..ply:Nick().."' ("..ply:SteamID()..")")
		MSYS.parseCommand(text)
    end
end

function MSYS.TerminalPrint(text)
	insertTerminal(text,true)
end

function MSYS.clearTerminal()
	if LocalPlayer().activeTxtInput then
		LocalPlayer().activeTxtInput:SetText("Terminal cleared.\n\n")
	end
	file.Write("MSYS/client_terminal.txt","")
end

function NEXUS.StartTerminal(shouldClear,parseReturn)
	local ply = LocalPlayer()
	local mon = NEXUS.NEXUS.Monitor
    if parseReturn == nil then parseReturn = false end -- if we didn't get here from sending a command, don't expect anything.
    if shouldClear then
        MSYS.clearTerminal()
        print("terminal cleared")
    end
    local frame = vgui.Create("DFrame")
    frame:SetTitle("[MSYS - MONITOR] Terminal view")
    MirUtil.ClassicFrame(frame,900,800)

    local terminalView = vgui.Create("DPanel",frame)
	terminalView:SetSize(880,690)
    terminalView:SetPos(10,30)
	terminalView:SetVisible(mon:Allowed(LEVEL_ADMIN))

	local tText = vgui.Create("RichText",terminalView) -- terminalText, the actual text element of the panel
	tText:Dock(FILL)
	function tText:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(250,250,250))
	end
	tText:InsertColorChange(0,0,0,255) -- black on white
	tText:AppendText("This should be sent to the terminal.")

	ply.activeTxtInput = tText

	local terminalInput = vgui.Create("DTextEntry",frame)
	terminalInput:SetSize(terminalView:GetWide(),20)
	terminalInput:SetPlaceholderText("[Mirai System] Send on level: "..MSYS.LevelStrings[mon:GetAccessLevel()])
	local x,y = terminalView:GetPos()
	terminalInput:SetPos(x,y+terminalView:GetTall()+5) -- should put it right underneath it.
	function terminalInput:OnEnter(txt)
		txt = string.Trim(txt)
		if tobool(MSYS.err(txt,TARGET_STRING)) then
			terminalInput:SetValue("ERROR: "..MSYS.errMsg(txt))
			return
		end
		ply.registeredLastMessage = txt
		terminalInput:SetText("")
		terminalInput:RequestFocus()
		insertTerminal(txt)
	end

    local backB = vgui.Create("DButton",frame)
    backB:SetSize(200,30)
    backB:SetPos(frame:GetWide()/2-backB:GetWide()/2,frame:GetTall()-backB:GetTall()-10)
    backB:SetText("Back to monitor")
    backB:SetTextColor(Color(250,250,250))
    backB:SetFont("MSYS_Monitor_Font")
    MirUtil.Button(backB,frame,Color(194,138,35),Color(255,166,0),function()
        MSYS.OpenMonitorView(false)
        frame:Remove()
    end)

    local dummyB = vgui.Create("DButton",frame)
    dummyB:SetSize(200,30)
    dummyB:SetPos(frame:GetWide()/4-backB:GetWide()/2,frame:GetTall()-backB:GetTall()-10)
    dummyB:SetText("Dummy message")
    dummyB:SetTextColor(Color(250,250,250))
    dummyB:SetFont("MSYS_Monitor_Font")
    MirUtil.Button(dummyB,frame,Color(14,68,235),Color(55,16,250),function()
    	tText:AppendText("\n"..NEXUS.DummyMessages()[math.random(1,#MSYS.DummyMessages)])
    end)


    if parseReturn then -- if neither false nor nil
        if istable(parseReturn) then
            print("parseReturn returns a table, to be printed below.")
            PrintTable(parseReturn)
		else
			Error("[MSYS] it seems parseReturn returns a non-table value?")
			print(parseReturn)
        end
    end

    function frame:OnRemove()
    	ply.activeTxtInput = nil
    	ply.registeredLastMessage = ""
    end
    
end

hook.Add("Move","DetectUpArrow",function(ply,moveData)
	if ply:IsValid() then
		if ply.activeTxtInput then
			if input.WasKeyPressed(KEY_UP) then
				print("THIS FOUND")
				ply.activeTxtInput:SetText(ply.registeredLastMessage)
			end
		end
	end
end)