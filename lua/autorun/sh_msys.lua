MSYS = MSYS or {}

local plymeta = FindMetaTable("Player")

function plymeta:Tell(str,col)
	if not col then col = Color(250,250,250) end
	if CLIENT then
		chat.AddText(Color(250,0,0),"[MSYS]  ",col,str)
	elseif SERVER then
		net.Start("MSYS_RequestTell")
		net.WriteString(str)
		net.WriteColor(col)
		net.Send(self)
	end
end

function MSYS.Tell(ply,msg,col)
	ply:Tell(msg,col)
end

function MSYS.TellAll(msg,col)
	if not col then col = Color(250,250,250) end
	if SERVER then
		net.Start("MSYS_RequestTell")
		net.WriteString(msg)
		net.WriteColor(col)
		net.Broadcast()
	elseif CLIENT then
		net.Start("MSYS_RequestBroadcast",msg,col)
		net.SendToServer()
	end
end

function MSYS.err(text,target,...) -- preferred calling: MSYS.err("text etc here",TARGET_STRING,ERR_ERRORHERE,ERR_ERROR2) | MSYS.err(-123,TARGET_NUMBER,ERR_NUMBER_NEGATIVE) <- will allow it to be negative.
	if target == nil then target = TARGET_STRING end -- default to string comp
	local ignoredErrors = {...}

	local function ign(err)
		return table.HasValue(ignoredErrors,err)
	end
	
	if #ignoredErrors > 0 then
		for k,v in pairs(ignoredErrors) do
			if not MSYS.Errors[v] then
				error("[MSYS] given ignore-error is not registered.")
			end
		end
	end

	if target == TARGET_STRING then -- run all possible errors
		local text = string.Trim(text) -- taking the first argument as the given text
		if not isstring(text) then
			if not ign(ERR_STRING_NOT_STRING) then
				return ERR_STRING_NOT_STRING
			end
		end
		if text == "" then
			if not ign(ERR_STRING_EMPTY) then
				return ERR_STRING_EMPTY
			end
		end
		if #text < 0 then
			if not err(ERR_STRING_INVALID) then
				return ERR_STRING_INVALID
			end
		end

		if #text > TERMINAL_CHAR_LIMIT then
			if not ign(ERR_STRING_LARGE) then
				return ERR_STRING_LARGE
			end
		end



		return false -- if none of the above are found, return false (no error)
	elseif target == TARGET_NUMBER then
		local n = tonumber(text)
		
		if text == nil then
			if not ign(ERR_NUMBER_NULL) then
				return ERR_NUMBER_NULL
			end
		end

		if not isnumber(n) then
			if not ign(ERR_NUMBER_NAN) then
				return ERR_NUMBER_NAN
			end
		end

		if n > TERMINAL_NUMBER_MAX then
			if not ign(ERR_NUMBER_LARGE) then
				return ERR_NUMBER_LARGE
			end
		end

		if n < TERMINAL_NUMBER_MIN then
			if not ign(ERR_NUMBER_SMALL) then
				return ERR_NUMBER_SMALL
			end
		end

		if n < 0 then
			if not ign(ERR_NUMBER_NEGATIVE) then
				return ERR_NUMBER_NEGATIVE
			end
		end
		
		return false -- if none of the above are found, return false (no error)
	end
end

function MSYS.errMsg(text)
	if MSYS.err(text) == false then
		error("[MSYS] errMsg called on a non-error?\n")
	end
	return MSYS.Errors[MSYS.err(text)]
end

function ents.GetBySerial(serial)
	for k,v in pairs(ents.GetAll()) do
		if table.HasValue(MSYS.SerialedEntities,v:GetClass()) then
			print("TRYING FOR ",v)
			if v.serial != nil then
				if v.serial == serial then
					print("HI?!")
					return v
				end
			end
			if v:GetSerialKey() != nil then
				if v:GetSerialKey() == serial then
					return v
				end
			end
			print("STOP ",v)
		end
	end
end

print("sh_msys.lua reloaded.")