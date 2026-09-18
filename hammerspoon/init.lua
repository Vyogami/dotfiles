-- Scroll on the menu bar (top strip) to switch Spaces, using the SAME technique
-- as LinearMouse: trigger the real "Move left/right a space" symbolic hotkey by
-- posting explicit modifier flagsChanged events around the arrow key. This makes
-- the WindowServer treat it as a genuine hotkey (native smooth animation) instead
-- of leaking a bare arrow keypress into the frontmost app.

hs.urlevent.bind("reload", function() hs.reload() end)

local KC = { shift = 56, ctrl = 59, cmd = 55, alt = 58 }
local FLAGS_CHANGED = hs.eventtap.event.types.flagsChanged
local ARROW = { left = 123, right = 124 }
local SPACE_MODS = { "ctrl", "cmd" } -- macOS "Move left/right a space" = Ctrl+Cmd+Arrow

local MENUBAR_HEIGHT = 25
local COOLDOWN = 0.30
local lastSwitch = 0

local function postFlagsChanged(keycode, flagsTable)
  local e = hs.eventtap.event.newKeyEvent({}, "a", true)
  e:setKeyCode(keycode)
  e:setType(FLAGS_CHANGED)
  e:setFlags(flagsTable)
  e:post()
end

local function copyFlags(t)
  local c = {} ; for k, v in pairs(t) do c[k] = v end ; return c
end

local function log(m) local f=io.open("/tmp/hs_space.log","a") f:write(os.date("%H:%M:%S ")..m.."\n") f:close() end

local HELPER = os.getenv("HOME") .. "/.hammerspoon/bin/spaceswitch"
local function switchSpace(dir) -- "left" or "right"
  log("switchSpace "..dir)
  hs.task.new(HELPER, nil, { dir }):start()
end

local function pointerInMenuBar()
  local screen = hs.mouse.getCurrentScreen()
  if not screen then return false end
  local pos = hs.mouse.absolutePosition()
  local f = screen:fullFrame()
  return pos.y >= f.y and pos.y <= (f.y + MENUBAR_HEIGHT)
    and pos.x >= f.x and pos.x <= (f.x + f.w)
end

scrollTap = hs.eventtap.new({ hs.eventtap.event.types.scrollWheel }, function(e)
  if not pointerInMenuBar() then return false end

  local now = hs.timer.secondsSinceEpoch()
  if now - lastSwitch < COOLDOWN then return true end

  local dy = e:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1)
  if dy == 0 then return true end

  lastSwitch = now
  hs.timer.doAfter(0, function()
    switchSpace((dy > 0) and "left" or "right") -- up -> previous, down -> next
  end)
  return true
end)

scrollTap:start()

-- Click on empty menu-bar space -> Mission Control (overview).
-- Only fires when the cursor is NOT over a real menu-bar item (app menus /
-- status icons keep working); those report AXRole "AXMenuBarItem".
local lastClick = 0
local function overEmptyMenuBar()
  local pos = hs.mouse.absolutePosition()
  local el = hs.axuielement.systemElementAtPosition(pos.x, pos.y)
  if not el then return true end
  local role = el:attributeValue("AXRole")
  return role ~= "AXMenuBarItem"
end

clickTap = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, function(e)
  if not pointerInMenuBar() then return false end
  if not overEmptyMenuBar() then return false end
  local now = hs.timer.secondsSinceEpoch()
  if now - lastClick < COOLDOWN then return false end
  lastClick = now
  hs.timer.doAfter(0, function() hs.spaces.toggleMissionControl() end)
  return false
end)
-- Empty menu-bar click -> Mission Control.
clickTap:start()

-- Cmd+Tab -> cycle keyboard focus to the frontmost window on the next display.
-- (Overrides the macOS app switcher, by request.) Implemented as an eventtap that
-- consumes the keypress -- this intercepts more reliably than a Carbon hotkey,
-- which sometimes loses the race to the system app switcher after a space switch.
local function frontmostWindowOnScreen(screen)
  for _, w in ipairs(hs.window.orderedWindows()) do
    if w:isStandard() and not w:isMinimized() and w:screen() == screen then
      return w
    end
  end
  return nil
end

local function focusNextMonitorAction()
  local screens = hs.screen.allScreens()
  if #screens < 2 then return end

  local fw = hs.window.focusedWindow()
  local cur = (fw and fw:screen()) or hs.mouse.getCurrentScreen() or screens[1]

  local idx = 1
  for i, s in ipairs(screens) do if s == cur then idx = i break end end
  local target = screens[(idx % #screens) + 1]

  local w = frontmostWindowOnScreen(target)
  if w then
    w:focus()
    -- Also move the cursor onto the target display: macOS routes the
    -- space-switch hotkey (Ctrl+Cmd+Arrow) to the display under the CURSOR,
    -- not the keyboard-focused window. Without this, desktop switching would
    -- still act on the previous monitor until the mouse is moved manually.
    local wf = w:frame()
    hs.mouse.absolutePosition({ x = wf.x + wf.w / 2, y = wf.y + wf.h / 2 })
  else
    local f = target:frame()
    hs.mouse.absolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
  end
end

local TAB = 48
cmdTabTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
  if e:getKeyCode() ~= TAB then return false end
  local m = e:getFlags()
  -- plain Cmd+Tab only (ignore if shift/ctrl/alt/fn are held)
  if m.cmd and not (m.shift or m.ctrl or m.alt or m.fn) then
    hs.timer.doAfter(0, focusNextMonitorAction)
    return true -- consume so the system app switcher never appears
  end
  return false
end)
cmdTabTap:start()

local f=io.open("/tmp/hs_space.log","a") f:write(os.date("%H:%M:%S ").."LOADED new init, scrollTap="..tostring(scrollTap~=nil)..", clickTap="..tostring(clickTap~=nil).."\n") f:close()
hs.alert.show("Menu-bar: scroll -> Spaces, click -> Mission Control")
