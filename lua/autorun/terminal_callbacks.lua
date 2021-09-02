MSYS = MSYS or {}
NEXUS = NEXUS or {}
MirUtil = MirUtil or {}

-- this is for the terminal_functions.lua functino callbacks

MSYS.Callbacks = MSYS.Callbacks or {}

MSYS.Callbacks.Help = function(...)
	print("optArg returns here",table.concat({...},", "))
	helpCallback(unpack({...}))
end

MSYS.Callbacks.ModuleConnect = function(module) 
	print("should attempt to connect to module '"..module.."'.")
end

MSYS.Callbacks.ModuleDisconnect = function(module)
	tprint("pretend we're disconnecting "..module)
end
