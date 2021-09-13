MSYS = MSYS or {}
NEXUS = NEXUS or {}
MirUtil = MirUtil or {}

-- this is for the terminal_functions.lua functino callbacks

MSYS.Callbacks = MSYS.Callbacks or {}

MSYS.Callbacks.Help = function(...)
	-- print("optArg returns here",table.concat({...},", "))
	MSYS.helpCallback(unpack({...}))
end

MSYS.Callbacks.ModuleConnect = function(module) 
	print("should attempt to connect to module '"..module.."'.")
end

MSYS.Callbacks.ModuleDisconnect = function(module)
	tprint("pretend we're disconnecting "..module)
end

MSYS.Callbacks.ModuleAssert = function() -- to see once again what's connected
	local msg = "\nModule assertion:\n\n"
	local dp = NEXUS.NEXUS.DEEPConnected
	tprint(msg)
end

MSYS.Callbacks.Dummy = function(count)
	count = tonumber(count)
	while count > 0 do
		local dum = NEXUS.FetchDummyMessages()
		tprint(table.random(dum))
		count = count - 1
	end
end

MSYS.Callbacks.GodActor = function(protocol)
	local ply = LocalPlayer()
	tprint("\n[NEXUS] God Actor started on protocol: "..(protocol or "none.").."\n")

	if not protocol then
		tprint("No protocol provided. halting.")
		return
	end
	if not NEXUS.GodProtocols[protocol] then
		tprint("No such protocol found.")
		return
	end
	local tb = NEXUS.GodProtocols[protocol]
	tprint("Protocol identified:  || "..table.concat(tb," ;  ").."  ||\n")

	local step = 0
	local nodisp = false
	if string.upper(tb[1]) == "NODISPLAY" then
		nodisp = true
		table.remove(tb,1)
	end
	timer.Create("GodActor"..ply:EntIndex(),GOD_ACTOR_STEP_DELAY,#tb, function()
		step = step + 1
		if nodisp == false then
			tprint("[God Actor] > "..tb[step])
		end
		timer.Simple(GOD_ACTOR_PARSE_DELAY, function()
			MSYS.parseCommand(tb[step])
			if timer.RepsLeft("GodActor"..ply:EntIndex()) == 0 then
				tprint("[GOD ACTOR FINISHED]")
			end
		end)
	end)
end

MSYS.Callbacks.WirelessScan = function()
    if not NEXUS.NEXUS.WUConnected then
        tprint("Error: Wireless unit not connected to system.\n")
        return
    end
	tprint("Scanning in range: "..WIRELESS_RANGE.."\n")
	local foundEnts = {}
	for k,v in pairs(ents.FindInSphere(NEXUS.NEXUS.WU:GetPos(), WIRELESS_RANGE)) do
		if table.HasValue(MSYS.WirelessPeripherals,v:GetClass()) then
			table.insert(foundEnts,v)
		end
	end
	if table.IsEmpty(foundEnts) then
		tprint("No connectable entities found in range.")
		return
	end
	
	local availablePeripherals = {}

	for k,v in pairs(foundEnts) do
		if not v.WUConnected then
			table.insert(availablePeripherals,{v.PeripheralName,v:GetSerialKey()})
		end
	end
	local msg = "Scan identified "..#availablePeripherals.." peripherals, ready to be connected.\n"
	for k,v in pairs(availablePeripherals) do
		msg = msg.."\nName: "..v[1].."     Serial: [ "..v[2].." ]"
	end

	tprint(msg)

end

MSYS.Callbacks.WirelessStatus = function()
	print("status called")
    local wu = NEXUS.NEXUS.WU
    print("Hi. ",NEXUS.NEXUS.WUConnected)
    local msg = [[

Wireless Unit Status
====================

Connection status: ]] .. ((NEXUS.NEXUS.WUConnected or NEXUS.NEXUS.CMM.WUConnected) and "Connected" or "Not Connected") .. "\n\n"
    if not wu then
        tprint(msg)
        return
    end
    msg = msg..[[

Configured scan distance: ]]..WIRELESS_RANGE.." units.\n"
    if not table.IsEmpty(wu.ConnectedPeripherals) then
        --[[
            we're expecting ConnectedPeripherals to look something like
            {
                {
                    name = "Sensor",
                    serial = "SENS_1234",
                    ent = Entity[34][msys_sensor] -- or some bullshit like that. we need to actually hold the entity too.
                },
                {
                    name = "Door",
                    serial = "DR_1235",
                    ent = Entity[48][msys_door]
                }
            }
        ]]
        msg = msg .. "Wireless Unit is connected to " .. #wu.ConnectedPeripherals .. " peripherals:\n\n"

        for k, v in pairs(wu.ConnectedPeripherals) do
            v.serial = (v.serial and v.serial or (v:GetSerialKey() and v:GetSerialKey() or "NO SERIAL"))
            local add = v.name .. "  -  ID:  [ " .. v.serial .. " ]\n" -- Sensor  -   ID:  [ SENS_123432 ]
            msg = msg .. add
        end
    end
    tprint(msg)
end

MSYS.Callbacks.WirelessConnect = function(peripID)
	if SERVER then return end
	if not peripID then tprint("no ID supplied.") return end
	peripID = string.upper(peripID)
	tprint("Attempting to connect to peripheral of ID: "..peripID.."...\n")

	net.Start("MSYS_AttemptPeripheralConnection")
	net.WriteEntity(LocalPlayer())
	net.WriteString(peripID)
	net.SendToServer()
end