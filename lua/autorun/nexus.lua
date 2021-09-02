MSYS = MSYS or {}
NEXUS = NEXUS or {}
NEXUS.Akasha = NEXUS.Akasha or {}

NEXUS.Logs = NEXUS.Logs or {}
NEXUS.Akasha.Logs = NEXUS.Akasha.Logs or {}

function NEXUS.Akasha.Log(fullMessage, clientAuthorized)
    -- for the record, clientAuthorized being true implies wanting the log to originate from a CLIENT realm.
    if clientAuthorized == nil then
        clientAuthorized = false
    end
    if (CLIENT and not clientAuthorized) then
        return
    end -- we only want this to run serverside.
    if SERVER and clientAuthorized then
        return
    end -- we can't log it twice
    if SERVER then
        table.insert(NEXUS.Akasha.Logs, fullMessage)
    elseif CLIENT then
        net.Start("MSYS_AKASHA_RequestLog")
        net.WriteString(fullMessage)
        net.SendToServer()
    end
end

function NEXUS.Log(message, clientAuthorized)
    if clientAuthorized == nil then
        clientAuthorized = false
    end
    if (CLIENT and not clientAuthorized) then
        return
    end -- we only want this to run serverside.
    if SERVER and clientAuthorized then
        return
    end -- we can't log it twice...
    if message == nil then
        error("[MSYS - NEXUS] Message returns nil.")
    end
    message = string.Trim(message)
    if not isstring(message) or message == "" then
        error("[MSYS - NEXUS] The logged message is not a string or is unreadable.")
    end
    local time = os.date("[%x  %X] ")

    local fullMessage = time .. message
    local shortMessage = os.date("[%X]  ") .. message
    if SERVER then
        table.insert(NEXUS.Logs, shortMessage)
    elseif CLIENT then
        net.Start("MSYS_NEXUS_RequestLog")
        net.WriteString(shortMessage)
        net.SendToServer()
    end
    NEXUS.Akasha.Log(fullMessage) -- EVERYTHING goes in the Akasha and STAYS there.
end

function NEXUS.ClearLog()
    table.Empty(NEXUS.Logs)
    net.Start("NEXUS_ClearLogs")
    net.Broadcast()
end

print("nexus.lua reloaded.")
