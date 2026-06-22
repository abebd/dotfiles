-- Construct the path to your PowerShellEditorServices bundle
local mason_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"
local cache_path = vim.fn.stdpath("cache")

-- Build the PowerShell launch string
local ps_command = string.format(
  "& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s/powershell_es.log' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal",
  mason_path, mason_path, cache_path, cache_path
)

-- Define/Override the config using the new vim.lsp API
vim.lsp.config('powershell_es', {
  cmd = { 'pwsh', '-NoLogo', '-NoProfile', '-Command', ps_command }
})

filetypes = { 'ps1', 'psm1' },

-- Enable it
vim.lsp.enable('powershell_es')

-- Add these to your init.lua
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to Definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Show References' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to Implementation' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename Variable/Function' })
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Actions' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line diagnostic' })
