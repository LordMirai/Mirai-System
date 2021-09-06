MSYS = MSYS or {}

local entmeta = FindMetaTable("Entity")


local cvar = CreateConVar("msys_full_delete_on_remove",MSYS_REMOVE_ALL and 1 or 0,FCVAR_NONE,"Whether the entire system should be removed when the nexus is deleted",0,1)

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

print("sv_msys.lua reloaded.")
