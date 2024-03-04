-- apps.lua
-- all app related shortcuts
local hotkey = require("hs.hotkey")
-- stylua: ignore hs
-- stylua: ignore spoon

local alt = { "alt" }

-- launch iterm2
hotkey.bind(alt, "return", function()
	hs.execute("osascript -e 'tell application \"iTerm2\" to create window with default profile'")
end)

-- focus browser space
hotkey.bind(alt, ".", function()
	hs.execute("open -a Arc")
end)

-- focus obsidian note space
hotkey.bind(alt, "o", function()
	hs.execute("open -a Obsidian")
end)

-- focus chrome space
hotkey.bind(alt, "u", function()
	hs.execute('open -a "Google Chrome"')
end)

-- focus poe space
hotkey.bind(alt, "-", function()
	hs.execute('open -a "POE"')
end)
