MSYS = MSYS or {}

--[[

These network strings are for global use, as in autorun files or similar.
Entity-specific NWStrings are to be used in their respective folders,
meaning not here.

]]

-- Messaging and General use
util.AddNetworkString("MSYS_RequestTell")
util.AddNetworkString("MSYS_RequestBroadcast")


util.AddNetworkString("MSYS_NEXUS_RequestLog")
util.AddNetworkString("MSYS_AKASHA_RequestLog")

util.AddNetworkString("MSYS_Request_FetchLogs") -- for getting the sv logs clientside
util.AddNetworkString("MSYS_Request_SendLogs")
util.AddNetworkString("NEXUS_ClearLogs")

util.AddNetworkString("MSYS_UpdateNexusClientside")
util.AddNetworkString("MSYS_UpdateNexusClientsideFinal") -- another one, for when it's actually ready. this is to write all entities to client