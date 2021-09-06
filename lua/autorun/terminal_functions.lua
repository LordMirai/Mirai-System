MSYS = MSYS or {}
NEXUS = NEXUS or {}
MirUtil = MirUtil or {}


--[[

Right, let's plan this first.
This should work somewhat similar to both cmd and, I suppose, maxnet's terminal.
the command string should be something like uh...

"LibraryName CommandName AnyArguments", following the table that is to be written below.
If there is an issue in writing these, or if an incorrect statement is to be found, then an error should be printed.... maybe in the exact text box?

We should have a 'help' command to print everything, idk how we'll actually execute them tho.
I think what I'll end up doing is calling action from the respective 'libraries' with the additional arguments (that may or may not be ignored).


I suppose one way we could actually these would be something like

module connect cmm

module <- the library
connect <- the command
cmm <- module name (taken as parameter)

The way we'll check for "folders" of commands would be to see if they have an 'action' key.

the 'example' key in the table should give any user a good idea of how to use the command well, especially if it has a specific syntax

]]

function tprint(txt)
    MSYS.TerminalPrint(txt)
end

MSYS.TerminalCommands = {}

local function libList()
    local lTb = {}
    for k,v in pairs(MSYS.TerminalCommands) do
        table.insert(lTb,k)
    end
    return lTb
end

local function helpinfo(func)
    local ply = LocalPlayer()
    PrintTable(func)
    if not MSYS.TerminalCommands[func] then
        error("[MSYS] helpinfo was called on a command that doesn't exist (uncaught before this)")
    end

    print("helpinfo call with func as ",func)

    message = "Displaying help for command.\nTip: "
    if func["help"] then
        message = message..func["help"].."\n"
    end
    if func["example"] then
        message = message.."Example: '"..func["example"].."'\n"
    end
    if func["parameters"] then
        message = message.."Parameters:\n"
        addM = "" -- additional
        for parNam,v in pairs(func["parameters"]) do
            addM = addM..parNam..(v.optional and " (optional)" or "")..(v.help and (" : '"..v.help.."'") or "").."\n"
            --[[
                Parameters:
                paramName (optional) : 'help message here'
                paramName2 : 'another help message'
                paramName3 (optional)
            ]]
        end
        message = message..addM

    end

    return message
end

function MSYS.helpCallback(...)
    local args = {...}
    local ttab = table.LowerKeyNames(MSYS.TerminalCommands) -- temporary table
    local usingArgs = false
    -- the argument would be used to work like "help module", to display that library and all the functions it could do
    local msg = ""
    if table.IsEmpty(args) then
        msg = [[
Displaying 'help' for all libraries.

use 'help (library)' to display the usage of specific libraries
Example: 'help module'

Available libraries:
]]
        msg = msg..table.concat(libList(),", ")
    else
        usingArgs = true
    end

    if usingArgs then

        local lib = args[1]
        if ttab[lib] then
            msg = [[   ]]
            if ttab[lib]["help"] then
                msg = msg..ttab[lib]["help"]
            end
            if ttab[lib]["commands"] then
                if ttab[lib]["commands"]["help"] then
                    msg = msg..ttab[lib]["commands"]["help"].."\n"
                end
                if ttab[lib]["commands"]["example"] then
                    msg = msg.."\nExample: "..ttab[lib]["commands"]["example"].."\n"
                end

                local met = "\nLibrary commands: "

                for k,v in pairs(ttab[lib]["commands"]) do
                    if k == "help" then continue end
                    met = met.."  "..k.."  "
                end

                msg = msg..met.."\n"
            end

            if args[2] then -- we expect more arguments to follow, so we trace them.
                local path = ttab[lib]["commands"]
                table.remove(args,1)
                for k,v in pairs(args) do
                    if not path[v] then
                        msg = msg.."No such command found. ("..v..")"
                        break
                    else
                        if path[v]["help"] then
                            msg = msg.."'"..v.."' : "..path[v]["help"].."\n"
                        end

                        if path[v]["example"] then
                            msg = msg.."Usage example: '"..path[v]["example"].."'\n"
                        end
                        if path[v]["parameters"] then
                            msg = msg.."Parameters used for '"..v.."' are:\n"
                            local parStr = ""
                            PrintTable(path[v]["parameters"])
                            for key,param in pairs(path[v]["parameters"]) do
                                parStr = parStr.."\n '"..v.."' "..(param.optional and "(OPTIONAL)" or "")..(param.help and "  "..param.help or "")..(param.example and "Example: "..param.example or "")..";"
                            end
                            msg = msg..parStr
                        end
                    end
                end
            end

        else
            msg = msg.."\nNo such library or command found ("..lib..")\n"
        end

        
    end
    
    tprint(msg.."\n")

end

MSYS.TerminalCommands = {
    ["Test"] = {
        ["commands"] = {
            ["testcmd"] = {
                ["help"] = "Testing command.",
                ["action"] = function() print("I'm almost sure I'll need to print all of these.") end,
            },
            ["manyargs"] = {
                ["help"] = "test function that takes arguments or parameters.",
                ["parameters"] = {
                    ["par1"] = {
                        help = "param 1",
                        optional = true,
                    },
                    ["par2"] = {
                        help = "param 2",
                        optional = true,
                    },
                    ["par3"] = {
                        help = "param 3",
                        optional = true,
                    },
                },
                ["action"] = function(par1,par2,par3) print("The parameters given are: ",par1,par2,par3) end,
            },  
            ["help"] = "A testing thingy. idk what i'm doing."
        }
    },

    ["Help"] = {
        ["help"] = "A function for displaying the help tips from all other libraries. Available libraries:\n"..table.concat(libList(),", "),
        ["parameters"] = {
            ["module"] = {
                optional = true,
                help = "Optional module name to display the help of.",
            },
        },
        ["action"] = MSYS.Callbacks.Help,
    },

    ["Module"] = {
        ["commands"] = {
            ["connect"] = {
                ["help"] = "Connect a module to the system",
                ["parameters"] = {
                    ["module"] = {
                        help = "The module to attempt the connection to",
                    },
                },
                ["example"] = "module connect cmm",
                ["action"] = MSYS.Callbacks.ModuleConnect,
                
            },
            ["status"] = {
                ["help"] = "Displays the status for all modules",
                ["example"] = "module status",
                ["action"] = function() tprint("Module status is to be printed below.") end,
            },
            ["disconnect"] = {
                ["help"] = "Disconnect a module from the system.",
                ["parameters"] = {
                    ["module"] = {
                        help = "The module to disconnect"
                    },
                },
                ["example"] = "module disconnect cmm",
                ["action"] =  MSYS.Callbacks.ModuleDisconnect
            },
        },
        ["help"] = "A library to hold module elements (connect, disconnect etc)",
    },
    ["Clear"] = {
        ["help"] = "A function to clear the terminal",
        ["action"] = MSYS.clearTerminal,
        ["alias"] = "cls"
    },
    ["Echo"] = {
        ["help"] = "Prints something to the screen",
        ["parameters"] = {
            ["echoObject"] = {
                optional = true,
                many = true, -- WIP
                help = "what to echo",
            }
        },
        ["action"] = function(...) tprint(table.concat({...}," ")) end,
    },
    ["Exit"] = {
        ["help"] = "Closes the monitor terminal",
        ["action"] = function()
            if LocalPlayer().activeTxtInput then
                LocalPlayer().activeTxtInput:GetParent():GetParent():Remove()
            end
        end
    },

    ["System"] = {
        ["help"] = "Get information about the system",
        ["commands"] = {

        },
    },

    ["Nexus"] = {
        ["access"] = LEVEL_EPSILON,
        ["help"] = "Control the NEXUS (EPSILON)",
        ["commands"] = {
            ["akasha"] = {
                ["help"] = "Access the Akasha section",
                ["action"] = function() end,
            },
            ["dummy"] = {
                ["help"] = "Print dummy messages to the screen",
                ["parameters"] = {
                    ["count"] = {
                        help = "How many dummy messages to send",
                        optional = true,
                        forceType = PAR_TYPE_NUMBER,
                    },
                },
                ["action"] = MSYS.Callbacks.Dummy,
            },
        },
    },

}

local function need(tab) -- returns a table of necessary parameters (not marked as optional)
    necessary = {}
    for k,v in pairs(tab) do
        if not v.optional then
            table.insert(necessary,v)
        end
    end
    return necessary
end

function MSYS.locateFunc(str)
    if not isstring(str) then
        error("[MSYS] locateFunc called on non-string")
    end
    str = string.lower(string.Trim(str))
    if str == "" then
        return ERR_STRING_EMPTY
    end

    local strTab = string.Explode(" ",str)
    local path = table.LowerKeyNames(MSYS.TerminalCommands)
    local useParameters = false
    local paramTab = {}
    local act

    local lib = strTab[1] -- the library

    local foundAlias = false -- WORK ON THIS LATER

    if path[lib] == nil  then return NOT_FOUND end

    -- assuming strTab = {"module","connect","nexus"}

    table.remove(strTab,1) -- removing first key, so we have the rest to work with
    if table.IsEmpty(strTab) then -- no further arguments
        print("lib is, again",lib)
        if ((not path[lib]["action"]) and (path[lib]["help"])) then
            tprint(path[lib]["help"])
            return NO_EXEC
        end
    end

    if path[lib].action then -- it has no action, try looking for commands
        if path[lib].parameters then
            if not table.IsEmpty(strTab) then
                useParameters = true
                print("We have parameters for help, yes?")
            end
        end
        return path[lib].action,strTab -- it's good to have this early so we can execute things like the help cmd
    else
        path = path[lib].commands
    end

    if not path then return NOT_FOUND end -- if we didn't find the ["commands"] key, stop.
    --There can't be a command with neither subcommands nor an action, it'd be useless

    --strTab = {"connect","nexus"}
    if not table.IsEmpty(strTab) then

        if strTab[1] == "help" then -- keyword reached. only print what you get
            local helpStr = path[strTab[1]]
            if not isstring(helpStr) then
                tprint("No help provided for this.")
            else
                tprint(helpStr)
            end
            return NO_EXEC
        end

        path = path[strTab[1]] -- MSYS.TerminalCommands["module"]["commands"]["connect"]
        table.remove(strTab,1) -- removing first key, so we have the rest to work with
    end

    --strTab = {"nexus"}

    if path.action then
        if path.parameters then
            if not table.IsEmpty(path.parameters) then
                useParameters = true
            end
        end
        act = path.action
    end
    
    if useParameters then
        table.CopyFromTo(strTab,paramTab) -- paramTab = {"nexus"}

        if #paramTab < #need(path.parameters) then
            tprint("Expected "..#need(path.parameters).." parameters, received "..#paramTab)
            return PARAM_ERR
        end

        for k,v in pairs(paramTab) do
            if path.parameters[k].forceType then -- we acknowledge that it must be of this specific type
                if path.parameters[k].forceType == PAR_TYPE_NUMBER then
                    if not (tonumber(v)) then
                        return PARAM_ERR_NUMBER
                    end
                elseif path.parameters[k].forceType == PAR_TYPE_STRING then
                    if (tonumber(v) != nil) then
                        return PARAM_ERR_STRING
                    end
                end
            end
        end


        return act,paramTab
    end

    return path.action or NOT_FOUND -- if we return false it should mean we weren't able to find anything
end

function MSYS.parseCommand(cmdInput)
    local cmdTable = string.Explode(" ",cmdInput)
    if table.IsEmpty(cmdTable) then
        print("received cmdTable is empty.")
    end
    
    local execFunc,params = MSYS.locateFunc(cmdInput)
    print(execFunc,params)
    -- execFunc should return a valid function

    if execFunc == NO_EXEC then return end

    if not execFunc or not isfunction(execFunc) then
        if MSYS.Errors[execFunc] then
            tprint("execFunc returns error: "..MSYS.Errors[execFunc])
            return
        end
    end

    -- the actual execution of the function
        print("execFunc returns ",execFunc)
    if istable(execFunc) then
        PrintTable(execFunc)
    end
    if params then
        execFunc(unpack(params)) 
    elseif params == nil or table.IsEmpty(params) then
        execFunc()
    end
    -- we can actually get the monitor entity from here... just by doing NEXUS.NEXUS.ConnectedMonitor.
end