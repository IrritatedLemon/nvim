vim.g.have_nerd_font = true

vim.opt.number = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.cursorline = true

vim.opt.hlsearch = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.termguicolors = true

require("config.maps")
require("config.lazy")
require("config.lsp")
