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
    options = { extra_ui = true },
    mappings = { windows = true, move_with_alt = true },
    autocommands = { relnum_in_visual_mode = true },
  })
end)
now(function() require('mini.statusline').setup() end)
now(function()
  require('mini.notify').setup()
  vim.notify = MiniNotify.make_notify()
end)
now(function() 
  require('mini.icons').setup()
  later(MiniIcons.tweak_lsp_kind)
end)
-- TODO: Figure out why nvim-lspconfig cannot be lazy loaded or else ls won't start when opening a file directly
now(function()
  add('neovim/nvim-lspconfig')


  local function custom_on_attach(_, buf_id)
    vim.bo[buf_id].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end

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
          library = vim.api.nvim_get_runtime_file("", true)
        }
      })
    end,
    on_attach = function(client, buf_id)
      -- Reduce unnecessarily long list of completion triggers for better `MiniCompletion` experience
      client.server_capabilities.completionProvider.triggerCharacters = { '.', ':' }

      custom_on_attach(client, buf_id)
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
later(function()
  require('mini.completion').setup({
    lsp_completion = {
      auto_setup = false,
      source_func = 'omnifunc',
      process_items = function(items, base)
        -- Don't show 'Text' and 'Snippet' suggestions
        items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
        return MiniCompletion.default_process_items(items, base)
      end,
    },
    window = {
      info = { border = 'double' },
      signature = { border = 'double' }
    }
  })
end)
later(function() require('mini.pairs').setup() end)
-- indent lines + ii and ai for text objects
later(function() require('mini.indentscope').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.git').setup() end)
later(function()
  local miniclue = require('mini.clue')
  require('mini.clue').setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },


      -- mini.basics
      { mode = 'n', keys = [[\]] },

      -- mini.bracketed
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      { mode = 'n', keys = '<Leader>g', desc = 'Git' },
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end)


-- keymaps
local keycode = vim.keycode or function(x)
  return vim.api.nvim_replace_termcodes(x, true, true, true)
end
local keys = {
  ['cr']        = keycode('<CR>'),
  ['ctrl-y']    = keycode('<C-y>'),
  ['ctrl-y_cr'] = keycode('<C-y><CR>'),
}
_G.cr_action = function()
  if vim.fn.pumvisible() ~= 0 then
    -- If popup is visible, confirm selected item or add new line otherwise
    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
  else
    -- If popup is not visible, use plain `<CR>`.
    return MiniPairs.cr()
  end
end

vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })
-- Git
vim.keymap.set('n', '<Leader>go', function() MiniDiff.toggle_overlay(0) end, { desc = "Toggle diff overlay" })
vim.keymap.set({ 'n', 'x' }, '<Leader>gs',  '<Cmd>lua MiniGit.show_at_cursor()<CR>', { desc = 'Show at cursor' })
