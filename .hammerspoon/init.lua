local hotkey = require("hs.hotkey")
local yabaiCmd = "/opt/homebrew/bin/yabai -m"
-- stylua: ignore hs
-- stylua: ignore spoon

local alt = { "alt" }
local alt_shift = { "alt", "shift" }

-- enable hs.cli
require("hs.ipc")

-- everything about windows
require("window")
-- everything about spaces
require("space")

-- apps
require("apps")

--- other management commands
-- stop yabai
hotkey.bind(alt_shift, "q", function()
	hs.execute(yabaiCmd .. " quit")
end)

-- lock screen
hotkey.bind(alt, "escape", function()
	hs.execute("pmset displaysleepnow")
end)

-- toggle show desktop
hotkey.bind(alt, "s", function()
	hs.execute(yabaiCmd .. " space --toggle show-desktop")
end)

-- reload yabai and hammerspoon
-- TODO: not working
hotkey.bind(alt_shift, "r", function()
	hs.execute("$SCRIPTS/restart_ui.zsh")
end)

-- reload configuration
hs.loadSpoon("ReloadConfiguration")

spoon.ReloadConfiguration:start()
