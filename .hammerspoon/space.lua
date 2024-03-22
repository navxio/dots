local hotkey = require("hs.hotkey")
local yabaiCmd = "/opt/homebrew/bin/yabai -m"
-- stylua: ignore hs
-- stylua: ignore spoon

local alt = { "alt" }
local alt_shift = { "alt", "shift" }

-- move windows to space
hotkey.bind(alt_shift, "1", function()
	hs.execute(yabaiCmd .. " window --space 1")
end)

hotkey.bind(alt_shift, "2", function()
	hs.execute(yabaiCmd .. " window --space 2")
end)

hotkey.bind(alt_shift, "3", function()
	hs.execute(yabaiCmd .. " window --space 3")
end)

hotkey.bind(alt_shift, "4", function()
	hs.execute(yabaiCmd .. " window --space 4")
end)

hotkey.bind(alt_shift, "5", function()
	hs.execute(yabaiCmd .. " window --space 5")
end)

hotkey.bind(alt_shift, "6", function()
	hs.execute(yabaiCmd .. " window --space 6")
end)

hotkey.bind(alt_shift, "7", function()
	hs.execute(yabaiCmd .. " window --space 7")
end)

-- focus spaces
hotkey.bind(alt, "1", function()
	hs.execute(yabaiCmd .. " space --focus 1")
end)

hotkey.bind(alt, "2", function()
	hs.execute(yabaiCmd .. " space --focus 2")
end)

hotkey.bind(alt, "3", function()
	hs.execute(yabaiCmd .. " space --focus 3")
end)

hotkey.bind(alt, "4", function()
	hs.execute(yabaiCmd .. " space --focus 4")
end)

hotkey.bind(alt, "5", function()
	hs.execute(yabaiCmd .. " space --focus 5")
end)

hotkey.bind(alt, "6", function()
	hs.execute(yabaiCmd .. " space --focus 6")
end)

hotkey.bind(alt, "7", function()
	hs.execute(yabaiCmd .. " space --focus 7")
end)

-- more spaces commands
hotkey.bind(alt, "c", function()
	hs.execute(yabaiCmd .. " space --create")
end)

-- rotate tree
hotkey.bind(alt, "r", function()
	hs.execute(yabaiCmd .. " space --rotate 90")
end)

-- focus media space
hotkey.bind(alt, ",", function()
	hs.execute(yabaiCmd .. " space --focus 8")
end)

-- focus empty space or create one
hotkey.bind(alt, "e", function()
	hs.execute("/bin/bash /Users/nav/.scripts/focus_create_space_yabai.sh")
end)

-- focus the recent space
hotkey.bind(alt, "tab", function()
	hs.execute(yabaiCmd .. " space --focus recent")
end)

-- focus the primary space (:1)
hotkey.bind(alt, "t", function()
	hs.execute("/bin/bash /Users/nav/.scripts/focus_first_term.sh")
end)
