return {
  "vimwiki/vimwiki",
  keys = { { "<leader>ww", "<cmd>VimwikiIndex<cr>", desc = "Open Vimwiki Index" } },
  init = function()
    -- Your existing configurations
    vim.g.vimwiki_list = {
      {
        path = 'H:/docs/',
        syntax = 'markdown',
        ext = '.md',
      },
    }
    vim.g.vimwiki_global_ext = 0

    -- ======================================================================
    -- RIPGREP TODO FUNCTIONS & COMMANDS
    -- ======================================================================
    local wiki_path = 'H:/docs/'

    -- Helper function to execute ripgrep and parse results into quickfix
    local function run_wiki_search(pattern, error_msg)
      -- Escape patterns and paths for Windows shell safety
      local cmd = string.format('rg --vimgrep --no-heading --smart-case %s %s',
        vim.fn.shellescape(pattern),
        vim.fn.shellescape(wiki_path)
      )

      local result = vim.fn.system(cmd)

      -- Check if ripgrep found anything (v:shell_error != 0 means no matches/error)
      if vim.v.shell_error ~= 0 then
        print(error_msg)
        return
      end

      -- CLEAN LUA FIX: Parse the raw string using the quickfix compiler parser
      vim.fn.setqflist({}, 'r', {
        title = "Vimwiki Search: " .. pattern,
        lines = vim.split(result, "\n", { trimempty = true })
      })
      
      -- Open the window
      vim.cmd('copen')
    end
    -- 1. General TODO Search
    _G.VimWikiTodo = function()
      run_wiki_search('\\[[^X]\\] TODO', "No TODOs found (or rg error)")
    end

    -- 2. Ticket TODO Search
    _G.VimWikiTicketsTodo = function()
      run_wiki_search('\\[[^X]\\] TODO DRIV', "No TODO tickets found (or rg error)")
    end

    -- Create user commands so you can type :TODO and :TICKETS
    vim.api.nvim_create_user_command('TODO', _G.VimWikiTodo, {})
    vim.api.nvim_create_user_command('TICKETS', _G.VimWikiTicketsTodo, {})
  end,
}
