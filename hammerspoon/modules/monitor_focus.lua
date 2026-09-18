-- Cmd+Tab -> move keyboard focus to the frontmost window on the next display.
--
-- Overrides the macOS app switcher (by design). Implemented as an eventtap that
-- consumes the keypress, which intercepts more reliably than a Carbon hotkey --
-- the latter sometimes loses the race to the system app switcher after a space
-- switch.

local M = {}

local TAB = 48

local function frontmostWindowOnScreen(screen)
  for _, w in ipairs(hs.window.orderedWindows()) do
    if w:isStandard() and not w:isMinimized() and w:screen() == screen then
      return w
    end
  end
  return nil
end

local function focusNextMonitor()
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
    -- Also move the cursor onto the target display: macOS routes the space-switch
    -- hotkey (Ctrl+Cmd+Arrow) to the display under the CURSOR, not the keyboard-
    -- focused window. Without this, desktop switching would still act on the
    -- previous monitor until the mouse is moved manually.
    local wf = w:frame()
    hs.mouse.absolutePosition({ x = wf.x + wf.w / 2, y = wf.y + wf.h / 2 })
  else
    local f = target:frame()
    hs.mouse.absolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
  end
end

function M.start()
  M.tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(e)
    if e:getKeyCode() ~= TAB then return false end
    local m = e:getFlags()
    -- plain Cmd+Tab only (ignore if shift/ctrl/alt/fn are held)
    if m.cmd and not (m.shift or m.ctrl or m.alt or m.fn) then
      hs.timer.doAfter(0, focusNextMonitor)
      return true -- consume so the system app switcher never appears
    end
    return false
  end)
  M.tap:start()
end

return M
