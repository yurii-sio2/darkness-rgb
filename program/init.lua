local ACTIVE_FOLDER_FILE = "active_folder.txt"

print(file.list())

local function getActiveFolder()
    -- Read the active folder from a file, default to 'a' if not found
    local activeFolder = "a"
    if file.open(ACTIVE_FOLDER_FILE, "r") then
        activeFolder = file.readline():gsub("\n", "")
        file.close()
    end
    return activeFolder
end

activeFolder = getActiveFolder() .. "_"

-- Load configuration files
dofile("sensors-count.lua")

-- Load files from the active folder
dofile(activeFolder .. "init-common.lua")

print("Loaded files from: " .. activeFolder)

-- Schedule update check at 3 AM every day (10800 seconds after midnight)
tmr.create():alarm(10800 * 1000, tmr.ALARM_SEMI, function()
    dofile(activeFolder .. "update.lua")
end)
