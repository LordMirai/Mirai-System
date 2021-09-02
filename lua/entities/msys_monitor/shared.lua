ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Monitor"
ENT.Category = "Mirai System"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = ""
ENT.Instructions = "E then we see."
ENT.Contact = "cocomemelol@yahoo.com | Lord Mirai(未来)#0039"

MSYS = MSYS or {}

function ENT:OnRemove()
    if self.NEXUS then
        if SERVER then
            self.NEXUS:DisconnectMonitor()
        end
    end
end

function ENT:AccessLevelColor()
    return MSYS.LevelColors[self:GetAccessLevel()]
end

function ENT:GetAccessLevelString()
    return MSYS.LevelStrings[self:GetAccessLevel()]
end

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "AccessLevel")
    self:NetworkVar("String", 1, "SerialKey")

    if SERVER then
        self:SetAccessLevel(LEVEL_SURFACE)
        self:SetSerialKey("KEY INIT")
    end
end

function ENT:SetLevel(level)
    NEXUS.Log("Monitor switched to level " .. MSYS.LevelStrings[level], true)
    self:SetAccessLevel(level)
end

function ENT:nextLevel()
    local lev = self:GetAccessLevel()
    local key = table.KeyFromValue(MSYS.LevelTable, lev)
    if key then
        return MSYS.LevelTable[key + 1]
    else
        error("[MSYS] nextLevel can't find the supplied access level. Maybe entity invalid?\n")
    end
end

function ENT:DisconnectNexus()
    if CLIENT then
        net.Start("MSYS_Monitor_RequestDisconnectNexus")
        net.WriteEntity(self)
        net.SendToServer()
    elseif SERVER then
        if self.NEXUS then
            self.NEXUS:DisconnectMonitor()
        end
    end
end

function ENT:Allowed(acc)
    -- will likely be called like mon:Allowed(ACCESS_DEEP), which would compare the monitor's access "ACCESS_EPSILON" with "ACCESS_DEEP", returning 42 >= 12 (true)
    if not MSYS.LevelTable[acc] then
        error("[MSYS] Allowed called on an unregistered level.")
    end
    return self:GetAccessLevel() >= acc
end
