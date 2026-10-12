local shell = require("shell")
local filesystem = require("filesystem")
local scripts = {"lib/config.lua", "lib/utility.lua", "BreederTron3000.lua"}

local paths = {"lib"}

local function exists(filename)
    return filesystem.exists(shell.getWorkingDirectory() .. "/" .. filename)
end

local args = shell.parse(...)
local repo = args[1]
if type(repo) ~= "string"
    or not repo:match("^https://raw%.githubusercontent%.com/")
    or repo:find("[^%w:/._%-]") then
    print("Usage: setup <raw GitHub folder URL>")
    os.exit()
end
repo = repo:gsub("/+$", "")

for i = 1, #paths do
    if not filesystem.exists(shell.getWorkingDirectory() .. "/" .. paths[i]) then
        filesystem.makeDirectory(shell.getWorkingDirectory() .. "/" .. paths[i]);
    end
end

for i = 1, #scripts do
    if exists(scripts[i]) then
        filesystem.remove(shell.getWorkingDirectory() .. "/" .. scripts[i]);
    end

    shell.execute(string.format("wget %s/%s %s", repo, scripts[i], scripts[i]));
end

shell.execute("reboot");
