MSYS = MSYS or {}
NEXUS = NEXUS or {}

-- Access level enums (might be removed.)
-- ###############################################################

ACCESS_MONITOR = 0 -- base-level access, nothing.
ACCESS_USER = 1 -- logged user access
ACCESS_ADMIN = 2 -- admin-level
ACCESS_DEEP = 5 -- DEEP level
ACCESS_NEXUS = 42 -- full control

ACCESS_NONE = -1 -- if disconnected
ACCESS_BLOCKED = -2 -- if kicked by safeguard

-- ###############################################################

-- Monitor (terminal "depth/level")

LEVEL_SURFACE = 0 -- base-level
LEVEL_ADMIN = 1 -- if passed by ACU
LEVEL_DEEP = 12 -- if passed by DEEP
LEVEL_NEXUS = 42

MSYS.LevelTable = {LEVEL_SURFACE, LEVEL_ADMIN, LEVEL_DEEP, LEVEL_NEXUS} -- these MUST be in order

MSYS.LevelStrings = {
    [LEVEL_SURFACE] = "Surface",
    [LEVEL_ADMIN] = "Administrator",
    [LEVEL_DEEP] = "D.E.E.P.",
    [LEVEL_NEXUS] = "EPSILON"
}

MSYS.LeveFullNames = {
    [LEVEL_SURFACE] = "Surface Level",
    [LEVEL_ADMIN] = "Administrator",
    [LEVEL_DEEP] = "Database Enhanced Execution Point",
    [LEVEL_NEXUS] = "EPSILON - Y [codename NEXUS]"
}

MSYS.LevelColors = {
    [LEVEL_SURFACE] = Color(250, 250, 250),
    [LEVEL_ADMIN] = Color(250, 0, 0),
    [LEVEL_DEEP] = Color(0, 0, 0),
    [LEVEL_NEXUS] = Color(20, 5, 130)
}

NEXUS.DummyMessages = { -- these are useless processing things, to just be put there.
"Scanned for hostilities.", "Checking peripherals... OK", "DEEP Connection healthy",
"ERROR in module " .. math.random(23, 50) .. " at 'ACU/A" .. math.random(2000, 5000) .. string.char(65, 90) ..
    "-EPSILON'", "You need to purge the primary and auxiliary polar casing.",
"These messages aren't really a thing, they're just here to fill space.", "Cleaned up mishandled connections.",
"Purged " .. math.random(1, 5) .. " unused channels.", "Terminated connection with UU/D13904J.",
"Stitched " .. math.random(2, 9) .. " files.", "Defragmented registry.", "Refreshed requests from ACU",
"Disengaged Cross Medium Module", "Environment healthy", "Handling packets from UU", "Transmitting status to ACU",
"Performing handshake protocol", "Handshake completed with connected modules.", "Invalid gateway between threads.",
math.random(10, 100) .. " packets to be imported.", "Exchanged " .. math.random(12, 22) .. " packages with D.E.E.P"}

-- General enums. Closer thing to a config so far.
-- #################################################

ROPE_LENGTH = 200 -- initial i suppose
MSYS.DEBUG = true -- enabling debug mode for now, so we can use everything.
CRED_CHAR_LIMIT = 60 -- the limit of characters for username/password (credentials)

TERMINAL_CHAR_LIMIT = 6000
TERMINAL_NUMBER_MAX = 200000000000 -- 200 billion.
TERMINAL_NUMBER_MIN = -200000000000

-- #################################################

-- NEXUS status enums

NEXUS_SHUTDOWN = 0
NEXUS_ACTIVE = 1
NEXUS_LOCKDOWN = -100 -- if someone fucked up
NEXUS_BROKEN = -1

NEXUS.StatusStrings = {
    [NEXUS_SHUTDOWN] = "Shutdown",
    [NEXUS_ACTIVE] = "Active",
    [NEXUS_LOCKDOWN] = "LOCKDOWN",
    [NEXUS_BROKEN] = "Broken"
}

NEXUS.ValidLogins = { -- For testing only. the real system should be made either with SQL or with filesystem
    [LEVEL_ADMIN] = {{
        username = "admin",
        password = "password"
    }, {
        username = "admin2",
        password = "pass"
    }},
    [LEVEL_DEEP] = {{
        username = "deep",
        password = "deepPass"
    }, {
        username = "D E E P",
        password = "DP"
    }},
    [LEVEL_NEXUS] = {{
        username = "Mirai",
        password = "RegnumSolem"
    }, {
        username = "Archaeus",
        password = "DeificProminence"
    }}
}

-- MONITOR / TERMINAL ERRORS
-- ############################################################################################################

TARGET_STRING = 10
TARGET_NUMBER = 20

ERR_STRING_NULL = 1
ERR_STRING_EMPTY = 2
ERR_STRING_LARGE = 3
ERR_STRING_NOT_STRING = 2.5
ERR_STRING_INVALID = 1.5

ERR_NUMBER_LARGE = 4
ERR_NUMBER_NEGATIVE = 5
ERR_NUMBER_NULL = 6
ERR_NUMBER_SMALL = 7
ERR_NUMBER_NAN = 8

MSYS.Errors = { -- every error *MUST* have an assigned string here!
    [ERR_STRING_NULL] = "STRING RECEIVED IS NULL (or cannot be read)",
    [ERR_STRING_EMPTY] = "RECEIVED AN EMPTY STRING",
    [ERR_STRING_LARGE] = "STRING RECEIVED EXCEEDS MAXIMUM CHARACTER LIMIT (" .. TERMINAL_CHAR_LIMIT .. ")",
    [ERR_STRING_NOT_STRING] = "INPUT RECEIVED IS NOT A STRING",
    [ERR_STRING_INVALID] = "STRING IS INVALID (size somehow returns negative?)",

    [ERR_NUMBER_LARGE] = "NUMBER RECEIVED IS TOO LARGE",
    [ERR_NUMBER_SMALL] = "NUMBER RECEIVED IS TOO SMALL",
    [ERR_NUMBER_NEGATIVE] = "NUMBER RECEIVED CANNOT BE NEGATIVE",
    [ERR_NUMBER_NULL] = "NUMBER RECEIVED IS 'NULL' (or cannot be read)",
    [ERR_NUMBER_NAN] = "INPUT IS NOT A NUMBER"
}

-- END OF MONITOR/TERMINAL ERRORS
-- ############################################################################################################
