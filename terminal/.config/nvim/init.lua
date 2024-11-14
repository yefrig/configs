pcall(function() vim.loader.enable() end)

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function() vim.cmd('colorscheme randomhue') end)

now(function()
  require('mini.basics').setup({
    mappings = { windows = true, move_with_alt = true },
    autocommands = { relnum_in_visual_mode = true },
  })
end)
now(function() require('mini.statusline').setup() end)
-- TODO: Figure out why nvim-lspconfig cannot be lazy loaded or else ls won't start when opening a file directly
now(function()
  add('neovim/nvim-lspconfig')

  local lspconfig = require('lspconfig')

  -- lua (with setup for neovim)
  lspconfig.lua_ls.setup {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
	  return
        end
      end
      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = { version = 'LuaJIT' },
        -- Make the server aware of Neovim runtime files
        workspace = {
  	  checkThirdParty = false,
	  library = { vim.env.VIMRUNTIME }
        }
      })
    end,
    settings = {
      Lua = {}
    }
  }
end)
later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end }
  })
  require('nvim-treesitter.configs').setup({
    auto_install = true,
    highlight = {
      enable = true
    },
    -- TODO: update keybinds for selection
    incremental_selection = {
      enable = true,
    },
    -- indent based on treesitter for = operator
    indent = {
      enable = true
    }
  })
end)
