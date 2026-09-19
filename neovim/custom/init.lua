vim.g.mapleader = ","

-- Create an augroup to manage the autocommands
-- Enable relative line numbering in normal mode and absolute line numbering in insert mode
vim.cmd([[
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set relativenumber | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &nu | set norelativenumber | endif
augroup END
]])

-- OSC 52 clipboard for SSH remote clipboard sharing
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
