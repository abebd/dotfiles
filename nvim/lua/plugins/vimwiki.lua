return {
  "vimwiki/vimwiki",
  init = function()
    vim.g.vimwiki_list = {
      { path = "H:\\docs", syntax = "markdown", ext = ".md" },
    }
  end,

  vim.keymap.set("n", "<leader>x", "<Plug>VimwikiToggleListItem", { 
    desc = "Vimwiki: Toggle Todo Item" 
  })
} 

