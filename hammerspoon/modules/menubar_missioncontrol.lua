-- Click an empty area of the menu bar to toggle Mission Control.
--
-- Only fires for empty menu-bar space on the ACTIVE screen, so app menus
-- (File / Edit / ...) and status icons keep working.

local util = require("modules.util")

local M = {}

local lastClick = 0

-- True only when the cursor is over EMPTY menu-bar space on the ACTIVE screen.
--
-- macOS keeps a live, accessibility-queryable menu bar only on the screen that
-- currently owns keyboard focus (hs.screen.mainScreen()). On any inactive
-- monitor, systemElementAtPosition returns stale / wrong-screen elements, so a
-- click on a real menu item there would be misread as empty. We therefore only
-- act on the active screen; clicking an inactive monitor's bar just switches to
-- it (its normal behaviour) and never toggles Mission Control.
local function overEmptyMenuBar()
  local screen = hs.mouse.getCurrentScreen()
  if not screen or screen ~= hs.screen.mainScreen() then return false end

  local pos = hs.mouse.absolutePosition()
  local el = hs.axuielement.systemElementAtPosition(pos.x, pos.y)
  if not el then return true end

  local role = el:attributeValue("AXRole")
  if role == "AXMenuBarItem" or role == "AXMenuExtra" then return false end
  if role == "AXMenuBar" then
    for _, k in ipairs(el:attributeValue("AXChildren") or {}) do
      local f = k:attributeValue("AXFrame")
      if f and pos.x >= f.x and pos.x <= f.x + f.w and pos.y >= f.y and pos.y <= f.y + f.h then
        return false
      end
    end
  end
  return true
end

function M.start()
  M.tap = hs.eventtap.new({ hs.eventtap.event.types.leftMouseDown }, function()
    if not util.pointerInMenuBar() then return false end
    if not overEmptyMenuBar() then return false end

    local now = hs.timer.secondsSinceEpoch()
    if now - lastClick < util.COOLDOWN then return false end
    lastClick = now

    hs.timer.doAfter(0, function() hs.spaces.toggleMissionControl() end)
    return false -- do not consume; let the click through harmlessly
  end)
  M.tap:start()
end

return M
