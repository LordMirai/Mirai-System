MSYS = MSYS or {}
NEXUS = NEXUS or {}

surface.CreateFont("MSYS_Monitor_Font", {
    font = "Times New Roman",
    size = 30,
    weight = 6000,
    bold = true,
    shadow = true
})

surface.CreateFont("MSYS_Monitor_Font_Small", {
    font = "Times New Roman",
    size = 20,
    weight = 6000,
    bold = true,
    shadow = true
})

surface.CreateFont("MSYS_Monitor_Font_noshadow", {
    font = "Times New Roman",
    size = 30,
    weight = 6000,
    bold = true,
    shadow = false
})

net.Receive("MSYS_RequestTell", function()
    local str = net.ReadString()
    local col = net.ReadColor()
    chat.AddText(Color(250, 0, 0), "[MSYS]  ", col, str)
end)

function MSYS.attemptLogin(ply, user, pass, monitor)
    local level = monitor:nextLevel()
    if not ply:IsValid() then
        return
    end
    if not level then
        return
    end
    user = tostring(user)
    pass = tostring(pass)
    if user == '' then
        ply:Tell("Blank username provided.",Color(250,50,50))
        return
    end

    if pass == '' then
        ply:Tell("Blank password provided.",Color(250,50,50))
        return
    end
    NEXUS.Log("Login attempt from '" .. ply:Nick() .. "' (" .. ply:SteamID() .. ")")

    ply:Tell("Attempting to log in to level  " .. MSYS.LevelStrings[level] .. "\nwith username  " .. user ..
                 " and password  " .. pass)

    local userConf = false
    local passConf = false

    for k, v in pairs(NEXUS.ValidLogins[level]) do
        if v.username == user then
            userConf = true
            if v.password == pass then
                passConf = true
                break
            end
        end
    end

    timer.Simple(0.05, function() -- i think it's good to have a small timer here, so the monitor can attempt its login.
        if not monitor:IsValid() then
            return
        end
        MSYS.OpenMonitorView()
    end)

    if not userConf then
        ply:Tell("Provided username not found.", Color(250, 0, 0))
    elseif userConf and not passConf then
        ply:Tell("Incorrect password.", Color(250, 250, 250))
    elseif userConf and passConf then
        ply:Tell("Succssfully connected to level " .. MSYS.LevelStrings[level])
        NEXUS.Log("Login successful to level " .. MSYS.LevelStrings[level] .. " (" .. level .. ")")

        monitor:SetLevel(level)
    end
end

print("cl_msys.lua reloaded.")
