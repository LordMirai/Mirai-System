ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Flag test"
ENT.Category = "Mirai System"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Author = "Lord Mirai  (未来)"
ENT.Purpose = "Test player/entity flags"
ENT.Instructions = "E then do stuff."
ENT.Contact = "cocomemelol@yahoo.com | Lord Mirai(未来)#0039"

MirUtil = MirUtil or {}
MSYS = MSYS or {}

function ENT:SetupDataTables()
	
end

ENT.Dialogue = {
    [FLAG_INITIAL] = {
        "Hello there, human. I am the one, the only, the myth, the legend, '"..self.PrintName.."', who worships "..self.Author..". Tremble before me."
    },
    [FLAG_USED_ONCE] = {
        "Hello again, person of your kind."
    },
    [FLAG_MULTIPLE_USE] = {
        "ET IN LOREM IPSUM",
        "These should be called at random",
        "This should be like 'oh shit, end of dialogue? boring.'",
        "more text here",
        "Asdfadfgasdfadfadf"
    },
    [FLAG_DAMAGE_TAKEN] = {
        "You dare strike me?",
    },
    [FLAG_DAMAGED_2] = {
        "No, you will not.",
    },
    [FLAG_DAMAGED_3] = {
        "Thine doom is in sight",
    },
    [FLAG_DAMAGED_4] = {
        "Vel mortis sunt ad inima gnao, garno verto immortalis. Mortis sumus ad aeternam, vale vale alis grave."
    },
    [FLAG_DAMAGED_FINAL] = {
        "In nomine dei, Kyrie Eleison."
    }
}