ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "NEXUS"
ENT.Category = "Mirai System"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = ""
ENT.Instructions = "E then we see."
ENT.Contact = "cocomemelol@yahoo.com | Lord Mirai(未来)#0039"

MSYS = MSYS or {}
NEXUS = NEXUS or {}

function ENT:Reset()
    if not self:IsValid() then
        return
    end

    self.MonitorConnected = false
    self.UUConnected = false
    self.ACUConnected = false
    self.CMMConnected = false
    self.DEEPConnected = false

    if self.Monitor then
        self.Monitor.NEXUS = nil
    end

    if self.UU then
        self.UU.NEXUS = nil
    end

    if self.ACU then
        self.ACU.NEXUS = nil
    end

    if self.CMM then
        self.CMM.NEXUS = nil
    end

    if self.DEEP then
        self.DEEP.NEXUS = nil
    end

    self.Monitor = nil
    self.UU = nil
    self.ACU = nil
    self.CMM = nil
    self.DEEP = nil

    print("Nexus reset")
    NEXUS.Log("NEXUS Reset")
end

function ENT:OnRemove()
    self:Reset()
    NEXUS.Spawned = false
    NEXUS.ClearLog()
    NEXUS.Akasha.Log("NEXUS removed.")
end

function ENT:GetStatus()
    return self:GetNEXUSState()
end

function ENT:IsActive()
    return self:GetStatus() == NEXUS_ACTIVE
end

function ENT:SetStatus(status, suppressLog)
    if suppressLog == nil then
        suppressLog = false
    end
    self:SetNEXUSState(status)
    if not suppressLog then -- if suppressed, don't send any logs here.
        NEXUS.Log("Status changed to " .. NEXUS.StatusStrings[status] .. ".")
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "NEXUSState")

    if SERVER then
        self:SetStatus(NEXUS_SHUTDOWN)
    end
end

function ENT:DisconnectMonitor()
    if SERVER then
        NEXUS.Log("Monitor disconnected.")
        if self.Monitor then
            if self.Monitor:IsValid() then
                if self.monRope then
                    self.monRope:Remove()
                end
            end
        end
        self.MonitorConnected = false
        self.Monitor = nil
    elseif CLIENT then
        net.Start("MSYS_NEXUS_RequestDisconnectMonitor")
        net.WriteEntity(self)
        net.SendToServer()
    end
end
