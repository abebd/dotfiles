vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config.lazy")
require("mason").setup()
require("mason-lspconfig").setup()
require("lsp.powershell_es")

vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers (great for jumping around)
vim.opt.shiftwidth = 4        -- Size of an indent
vim.opt.tabstop = 4           -- Number of spaces tabs count for
vim.opt.expandtab = true      -- Turn tabs into spaces
vim.opt.updatetime = 300      -- Snappier diagnostics/hover response
vim.opt.clipboard = "unnamedplus"

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

vim.cmd[[colorscheme onedark]]
