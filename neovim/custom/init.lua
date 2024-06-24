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
