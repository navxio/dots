function redrawBorder()
  win = hs.window.focusedWindow()
  if win ~= nil then
    top_left = win:topLeft()
    size = win:size()
    if global_border ~= nil then
      global_border:delete()
    end
    global_border = hs.drawing.rectangle(hs.geometry.rect(top_left["x"], top_left["y"], size["w"], size["h"]))
    global_border:setStrokeColor({["red"] = 1, ["blue"] = 0, ["green"] = 0, ["alpha"] = 0.8})
    global_border:setFill(false)
    global_border:setStrokeWidth(8)
    global_border:show()
  end
end
hs.hotkey.bind(
  {"cmd", "alt"},
  "h",
  function()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.x = f.x - 10
    win:setFrame(f)
  end
)

hs.hotkey.bind(
  {"cmd", "alt"},
  "l",
  function()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.x = f.x + 10
    win:setFrame(f)
  end
)
hs.hotkey.bind(
  {"cmd"},
  "h",
  function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
  end
)

hs.hotkey.bind(
  {"cmd"},
  "l",
  function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
  end
)
hs.hotkey.bind(
  -- maximize window
  {"cmd", "shift"},
  "Return",
  function()
    local win = hs.window.focusedWindow()
    if win == nil then
      return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
  end
)
hs.hotkey.bind(
  -- focus right
  {"cmd", "shift"},
  "l",
  function()
    local win = hs.window.filter.new():setCurrentSpace(true)
    if win == nil then
      return
    end
    win:focusWindowEast(nil, false, true)
  end
)
hs.hotkey.bind(
  -- focus left
  {"cmd", "shift"},
  "h",
  function()
    local win = hs.window.filter.new():setCurrentSpace(true)
    if win == nil then
      return
    end
    win:focusWindowWest(nil, false, true)
  end
)

function open_app(name)
  return function()
    hs.application.launchOrFocus(name)
    if name == "Finder" then
      hs.appfinder.appFromName(name):activate()
    end
  end
end

hs.hotkey.bind({"cmd"}, "Return", open_app("kitty"))
hs.hotkey.bind({"cmd", "shift"}, "C", open_app("Chromium"))
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
