local hotkey = require("hs.hotkey")
local yabaiCmd = "/opt/homebrew/bin/yabai -m"

-- Window Management
local alt = { "alt" }
local alt_shift = { "alt", "shift" }
hotkey.bind(alt, "h", function()
	hs.execute(yabaiCmd .. " window --focus west")
end)

hotkey.bind(alt, "j", function()
	hs.execute(yabaiCmd .. " window --focus south")
end)

hotkey.bind(alt, "k", function()
	hs.execute(yabaiCmd .. " window --focus north")
end)

hotkey.bind(alt, "l", function()
	hs.execute(yabaiCmd .. " window --focus east")
end)

--- Swapping windows
hotkey.bind(alt_shift, "h", function()
	hs.execute(yabaiCmd .. " window --swap west")
end)

hotkey.bind(alt_shift, "j", function()
	hs.execute(yabaiCmd .. " window --swap south")
end)

hotkey.bind(alt_shift, "k", function()
	hs.execute(yabaiCmd .. " window --swap north")
end)

hotkey.bind(alt_shift, "l", function()
	hs.execute(yabaiCmd .. " window --swap east")
end)

-- maximize
hotkey.bind(alt, "m", function()
	hs.execute(yabaiCmd .. " window --toggle zoom-fullscreen")
end)

-- increase window width
hotkey.bind(alt_shift, "e", function()
	hs.execute(yabaiCmd .. " window --resize right:+20:0")
end)

-- decrease window width
hotkey.bind(alt_shift, "a", function()
	hs.execute(yabaiCmd .. " window --resize right:-20:0")
end)

-- close a window
hotkey.bind(alt, "w", function()
	hs.execute(yabaiCmd .. " window --close")
end)
