local function vimwiki_todo2()
    local search_term = [[\-\ \[ \]\ TODO]]
    local target_path = [[H:\\docs\\diary]]

    vim.cmd(string.format('grep! %s %s', search_term, target_path))
    vim.cmd('copen')
end

vim.api.nvim_create_user_command("TODO", vimwiki_todo2, {})
