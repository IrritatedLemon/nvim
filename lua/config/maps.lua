vim.g.mapleader = "\\"

local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Exit insert mode
map("i", "jk", "<ESC>")

-- NeoTree
map("n", "<Leader>e", "<CMD>Neotree toggle<CR>")
map("n", "<Leader>r", "<CMD>Neotree focus<CR>")

-- Splitting
map("n", "<Leader>o", "<CMD>vsplit<CR>")
map("n", "<Leader>p", "<CMD>split<CR>")

-- Window Nagivation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize windows
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")
