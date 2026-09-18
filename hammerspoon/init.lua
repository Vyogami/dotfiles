-- Hammerspoon config, split into independent modules under ./modules.
--
-- Flip any flag below to false (or delete the line) to disable that feature.
-- Each module is self-contained, so turning one off never affects the others.

hs.urlevent.bind("reload", function() hs.reload() end)

local features = {
  menubarScrollSpaces     = true, -- scroll over the menu bar to switch Spaces
  menubarClickMissionCtrl = true, -- click empty menu bar to toggle Mission Control
  cmdTabMonitorFocus      = true, -- Cmd+Tab moves focus to the next monitor
}

local modules = {
  menubarScrollSpaces     = "modules.menubar_spaces",
  menubarClickMissionCtrl = "modules.menubar_missioncontrol",
  cmdTabMonitorFocus      = "modules.monitor_focus",
}

-- Keep references so the modules (and their eventtaps) are not garbage collected.
loadedModules = {}
for key, path in pairs(modules) do
  if features[key] then
    local mod = require(path)
    mod.start()
    loadedModules[key] = mod
  end
end

hs.alert.show("Hammerspoon config loaded")
