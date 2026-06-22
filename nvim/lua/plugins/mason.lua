return {
  "williamboman/mason.nvim",
  -- Run this plugin on the 'VeryLazy' event so it doesn't slow down startup
  event = "VeryLazy",
  
  -- The 'opts' table automatically passes these settings to require("mason").setup()
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  },
  
  -- This config function runs after Mason loads. 
  -- We use it to make sure your T-SQL and PowerShell tools are automatically downloaded.
  config = function(_, opts)
    require("mason").setup(opts)

    -- List the tools you always want Mason to keep installed
    local tools = {
      "powershell-editor-services",
    }

    local registry = require("mason-registry")
    
    -- Loop through and install them automatically if they are missing
    for _, tool in ipairs(tools) do
      local p = registry.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end,
}
