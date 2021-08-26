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


local function helpCallback(arg)
    -- the argument would be used to work like "help module", to display that library and all the functions it could do
end


MSYS.TerminalCommands = {

    ["Test"] = {
        ["help"] = "A testing thingy. idk what i'm doing.",
        ["commands"] = {
            ["testcmd"] = {
                ["help"] = "Testing command."
                ["action"] = function() print("I'm almost sure I'll need to print all of these.") end,
            },
            ["manyargs"] = {
                ["help"] = "test function that takes arguments or parameters.",
                ["action"] = function(par1,par2) print("The parameters given are: ",par1,par2) end,          
            },
        }
    },

    ["Help"] = {
        ["help"] = "A function for displaying the help tips from all other libraries",
        ["action"] = function(optArg) helpCallback(optArg) end,
    },

    ["Module"] = {
        ["help"] = "A library to hold module elements (connect, disconnect etc)",
        ["commands"] = {
            ["connect"] = {
                ["help"] = "Connect a module to the system",
                ["example"] = "module connect cmm",
                ["action"] = function(module) print("should attempt to connect to module '"..module.."'.") end
            }
        }
    }

}

function MSYS.parseCommand(cmdInput)
    local cmdTable = string.Explode(cmdInput)
    if tabl.isempty(cmdTable) then
        MSYS.TerminalError("received cmdTable is empty.")
    end
    local lib = cmdTable[0]
end