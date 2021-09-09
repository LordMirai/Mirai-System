MSYS = MSYS or {}
MirUtil = MirUtil or {}

local entmeta = FindMetaTable("Entity")


local deleteCvar = CreateConVar("msys_full_delete_on_remove",MSYS_REMOVE_ALL and 1 or 0,FCVAR_NONE,"Whether the entire system should be removed when the nexus is deleted",0,1)
local clearCvar = CreateConVar("msys_should_clear_terminal",MSYS_CLEAR_DEFAULT and 1 or 0,FCVAR_NONE,"Whether the terminal should be cleared whenever it's closed",0,1)

cvars.AddChangeCallback("msys_should_clear_terminal", function(cv,old,new)
    
end, "ClearCvarCallback")

function entmeta:ConnectMonitor(ent)
    if self.MonitorConnected == true then
        return
    end
    self.MonitorConnected = true
    self.Monitor = ent
    self.MonitorRope = constraint.Rope(self, ent, 0, 0, self:WorldToLocal(self:GetPos()), Vector(0, 0, 0),
        ROPE_LENGTH_MONITOR, 50, 0, 1, "cable/cable2", false)
    hook.Run("MSYSPeripheralConnected", ent, self)
end

net.Receive("MSYS_RequestBroadcast", function()
    local str = net.ReadString()
    local col = net.ReadColor()
    MSYS.TellAll(str, col)
end)

net.Receive("MSYS_Request_FetchLogs", function()
    local ply = net.ReadEntity()
    local mon = net.ReadEntity()
    local ak = net.ReadBool()
    local logs = NEXUS.Logs

    net.Start("MSYS_Request_SendLogs")
    net.WriteEntity(mon)
    net.WriteBool(ak)
    net.WriteTable(logs)
    net.Send(ply)
end)

function MSYS.showSerial(ply)
    if not ply:IsValid() then return end
    local ent = ply:GetEyeTrace().Entity
    if not table.HasValue(MSYS.SerialedEntities,ent:GetClass()) then
        MirUtil.RequestMessage(ply,"Entity has no serial key (ID)",Color(251,120,20))
        return
    end

    if ent:GetSerialKey() == nil then
        error("Entity is registered in SerialEntities but does not have an ID?")
    end

    MirUtil.RequestMessage(ply,"Entity: "..ent.PrintName.."\nSerial ID: ["..ent:GetSerialKey().."]"..(cvars.Bool("msys_copy_serial_clipboard") and "\n(copied to clipboard)" or ""),Color(40,180,180))


end

print("sv_msys.lua reloaded.")
