-- Scroll over the menu bar to switch Spaces / desktops.
--
-- Uses the same technique as LinearMouse: instead of faking an arrow keypress
-- (which modern macOS ignores for space-switching and leaks into the focused
-- app), it calls a small compiled helper that triggers the REAL "Move left/right
-- a space" symbolic hotkey, so the WindowServer animates natively.
--
-- The helper is built from hammerspoon/bin/spaceswitch.swift via build.sh.

local util = require("modules.util")

local M = {}

local HELPER = os.getenv("HOME") .. "/.hammerspoon/bin/spaceswitch"
local lastSwitch = 0

local function switchSpace(dir) -- "left" or "right"
  hs.task.new(HELPER, nil, { dir }):start()
end

function M.start()
  M.tap = hs.eventtap.new({ hs.eventtap.event.types.scrollWheel }, function(e)
    if not util.pointerInMenuBar() then return false end

    local now = hs.timer.secondsSinceEpoch()
    if now - lastSwitch < util.COOLDOWN then return true end

    local dy = e:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1)
    if dy == 0 then return true end

    lastSwitch = now
    hs.timer.doAfter(0, function()
      switchSpace((dy > 0) and "left" or "right") -- up -> previous, down -> next
    end)
    return true -- consume the scroll so it does not reach the app underneath
  end)
  M.tap:start()
end

return M
