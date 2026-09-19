-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
	Comment = {
		fg = "#76889c",
		italic = true,
	},
	LineNr = {
		fg = "#627387",
	},
	CursorLineNr = {
		fg = "#ffcc66",
		bold = true,
	},
	WinSeparator = {
		fg = "#384556",
		bg = "NONE",
	},
	NvimTreeWinSeparator = {
		fg = "#384556",
		bg = "NONE",
	},
	NvimTreeFolderName = {
		fg = "#d0d7de",
	},
	NvimTreeFolderIcon = {
		fg = "#e6c446",
	},
	NvimTreeOpenedFolderName = {
		fg = "#95e5cb",
		bold = true,
	},
	NvimTreeEmptyFolderName = {
		fg = "#8c95a0",
	},
	NvimTreeIndentMarker = {
		fg = "#384556",
	},
	NvDashAscii = { bg = "NONE", fg = "blue" },
	NvDashButtons = { bg = "NONE" },
	NotifyDEBUGBorder = { fg = "blue" },
}

---@type HLTable
M.add = {}

return M
