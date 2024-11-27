---@diagnostic disable: duplicate-set-field
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
now(function() add('tpope/vim-sleuth') end)
-- TODO: Figure out why nvim-lspconfig cannot be lazy loaded or else ls won't start when opening a file directly
now(function()
  add('neovim/nvim-lspconfig')
  add({ source = 'saghen/blink.cmp', checkout = 'v0.6.1' })

  require('blink-cmp').setup({
    keymap = { preset = 'enter' },
    accept = { auto_brackets = { enabled = true } },
    trigger = { signature_help = { enabled = true } }
  })

  local function custom_on_attach(_, buf_id)
    vim.lsp.inlay_hint.enable(true)

    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = buf_id, desc = 'LSP: ' .. desc })
    end

    -- gq is already bound to format lines using lsp
    map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    map('grr', vim.lsp.buf.references, '[G]oto [R]eferences')
    map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gY', vim.lsp.buf.type_definition, '[G]oto T[Y]pe Definition')
    map('grn', vim.lsp.buf.rename, '[G]oto [R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
  end

  local lspconfig = require('lspconfig')
  local capabilities = require('blink.cmp').get_lsp_capabilities()

  -- lua (with setup for neovim)
  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
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
      Lua = {
        hint = { enable = true }
      }
    }
  }
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end }
  })
  ---@diagnostic disable-next-line: missing-fields
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
later(function() require('mini.pairs').setup() end)
-- indent lines + ii and ai for text objects
later(function() require('mini.indentscope').setup() end)
later(function()
  require('mini.diff').setup()
  vim.keymap.set('n', '<Leader>go', function() MiniDiff.toggle_overlay(0) end, { desc = "Toggle diff overlay" })
end)
later(function()
  require('mini.git').setup()
  vim.keymap.set({ 'n', 'x' }, '<Leader>gs', MiniGit.show_at_cursor, { desc = 'Show at cursor' })
end)
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
      { mode = 'n', keys = '<Leader>g', desc = '[G]it' },
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
  })
end)
later(function()
  require('mini.files').setup({ windows = { preview = true } })
  vim.keymap.set('n', '<Leader>e', function() if not MiniFiles.close() then MiniFiles.open() end end,
    { desc = "File [E]xplorer" })
  vim.keymap.set('n', '<Leader>E',
    function() if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end end,
    { desc = "Current File [E]xplorer" })
end)
-- TODO: add ui.select
later(function()
  -- add more pickers
  require('mini.extra').setup()
  require('mini.pick').setup()

  vim.ui.select = MiniPick.ui_select

  -- add custom picker to pick registry pickers
  MiniPick.registry.registry = function()
    local items = vim.tbl_keys(MiniPick.registry)
    table.sort(items)
    local source = { items = items, name = 'Registry', choose = function() end }
    local chosen_picker_name = MiniPick.start({ source = source })
    if chosen_picker_name == nil then return end
    return MiniPick.registry[chosen_picker_name]()
  end

  vim.keymap.set('n', '<Leader>p', MiniPick.registry.registry, { desc = 'Pickers' })
end)
later(function()
  -- example: change inside next argument (cina)
  require('mini.ai').setup()
end)
