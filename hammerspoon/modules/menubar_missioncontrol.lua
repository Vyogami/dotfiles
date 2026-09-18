-- Click an empty area of the menu bar to toggle Mission Control.
--
-- Only fires when the cursor is NOT over a real menu-bar item, so app menus
-- (File / Edit / ...) and status icons keep working. Those elements report an
-- AXRole of "AXMenuBarItem"; empty space does not.

local util = require("modules.util")

local M = {}

local lastClick = 0

local function overEmptyMenuBar()
  local pos = hs.mouse.absolutePosition()
  local el = hs.axuielement.systemElementAtPosition(pos.x, pos.y)
  if not el then return true end
  return el:attributeValue("AXRole") ~= "AXMenuBarItem"
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
