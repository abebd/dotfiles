vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config.lazy")
require("mason").setup()
require("mason-lspconfig").setup()
require("lsp.powershell_es")
require("custom_functions")

vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Relative line numbers (great for jumping around)
vim.opt.shiftwidth = 4          -- Size of an indent
vim.opt.tabstop = 4             -- Number of spaces tabs count for
vim.opt.expandtab = true        -- Turn tabs into spaces
vim.opt.updatetime = 300        -- Snappier diagnostics/hover response
vim.o.expandtab = true          -- Convert tabs into spaces
vim.o.tabstop = 4               -- The width of a tab character
vim.o.shiftwidth = 4            -- Number of spaces used for each step of (auto)indent
vim.o.smartindent = true        -- Make indenting smart (e.g., auto-indenting after an if statement)
vim.o.ignorecase = true

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
--vim.keymap.set('n', '<leader>b', ':ls<cr>:b<space>')

vim.o.shell = "pwsh"

if vim.fn.has("win32") == 1 then
    vim.o.shell = "powershell.exe"
    vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command "
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
    vim.o.shellpipe = "| Out-File -Encoding UTF8 %s"
    vim.o.shellredir = "| Out-File -Encoding UTF8 %s"
end

vim.cmd[[colorscheme onedark]]

-- Resize split panes using Shift + Arrow keys
vim.keymap.set('n', '<S-Up>', ':resize +6<CR>', { silent = true })
vim.keymap.set('n', '<S-Down>', ':resize -6<CR>', { silent = true })
vim.keymap.set('n', '<S-Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<S-Right>', ':vertical resize +2<CR>', { silent = true })

vim.opt.grepprg = "rg --vimgrep --glob '!.git' --glob '!tags'"
