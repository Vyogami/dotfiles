-- Shared helpers used by the menu-bar modules.

local M = {}

-- Height (in points) of the menu-bar strip we treat as "the menu bar".
M.MENUBAR_HEIGHT = 25

-- Minimum gap between two triggers, to debounce rapid scroll/click events.
M.COOLDOWN = 0.30

-- True when the mouse pointer is inside the menu-bar strip of its current screen.
function M.pointerInMenuBar()
  local screen = hs.mouse.getCurrentScreen()
  if not screen then return false end
  local pos = hs.mouse.absolutePosition()
  local f = screen:fullFrame()
  return pos.y >= f.y and pos.y <= (f.y + M.MENUBAR_HEIGHT)
    and pos.x >= f.x and pos.x <= (f.x + f.w)
end

return M
