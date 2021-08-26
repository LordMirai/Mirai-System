MSYS = MSYS or {}
NEXUS = NEXUS or {}
MirUtil = MirUtil or {}

local function insertTerminal(text)

	if not file.Exists("MSYS","DATA") then
		file.CreateDir("MSYS")
	end
	if not file.Exists("MSYS/client_terminal.txt","DATA") then
		file.Write("MSYS/client_terminal.txt","") -- write nothing :)
	end

	local prettyTable = util.JSONToTable(file.Read("MSYS/client_terminal.txt","DATA")) or {}

	table.insert(prettyTable,text)

	file.Write("MSYS/client_terminal.txt",util.TableToJSON(prettyTable,true))

	print("Pretend we inserted '"..text.."' into the terminal, for now.")

	print("prettyTable printed below")
	PrintTable(prettyTable)
	print("end of table print.\n")

    MSYS.parseCommand(text)
end

local function clearTerminal()
	local prettyTable = util.JSONToTable(file.Read("MSYS/client_terminal.txt","DATA")) or {}
	print("terminal table before clear:")
	PrintTable(prettyTable)
	print("end")
	table.empty(prettyTable)
	file.Write("MSYS/client_terminal.txt","")

	print("terminal table after clear:")
	PrintTable(prettyTable)
end

function NEXUS.StartTerminal(ply,mon,shouldClear,parseReturn)
    if parseReturn == nil then parseReturn = false end -- if we didn't get here from sending a command, don't expect anything.
    if shouldClear then
        clearTerminal()
        print("terminal cleared")
    end
    local frame = vgui.Create("DFrame")
    frame:SetTitle("[MSYS - MONITOR] Terminal view")
    MirUtil.ClassicFrame(frame,900,500)

    local terminalView = vgui.Create("DPanel",frame)
	terminalView:SetSize(880,400)
    terminalView:SetPos(10,20)
	terminalView:SetVisible(mon:GetAccessLevel() == LEVEL_ADMIN)

	local tText = vgui.Create("RichText",terminalView) -- terminalText, the actual text element of the panel
	tText:Dock(FILL)
	tText:InsertColorChange(250,250,250) -- white text
	tText:AppendText("This should be sent to the terminal.")

	local terminalInput = vgui.Create("DTextEntry",terminalView)
	terminalInput:SetSize(terminalView:GetWide(),20)
	terminalInput:SetPos(terminalView:GetPos()+Vector(0,terminalView:GetTall()+5)) -- should put it right underneath it.
	function terminalInput:OnEnter(txt)
		txt = string.Trim(txt)
		if txt == "" then return end
		if tobool(MSYS.err(txt,TARGET_STRING)) then
			terminalInput:SetValue("ERROR: "..MSYS.errMsg(txt))
			return
		end
		insertTerminal(txt) -- this is mostly for a text file thingy for when it reloads the frame
		print("should've printed '"..txt.."' to terminal.")
	end

    local backB = vgui.Create("DButton",frame)
    backB:SetSize(200,30)
    backB:SetPos(frame:GetWide()/2-backB:GetWide()/2,300)
    backB:SetText("Back to monitor")
    backB:SetTextColor(Color(250,250,250))
    backB:SetFont("MSYS_Monitor_Font")
    MirUtil.Button(backB,frame,Color(194,138,35),Color(255,166,0),function()
        MSYS.OpenMonitorView(ply,mon,false)
        frame:Remove()
    end)


    if parseReturn != false then
        if istable(parseReturn) then
            print("parseReturn returns a table, to be printed below.")
            PrintTable(parseReturn)
        end
    end
    
end