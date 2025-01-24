---@diagnostic disable: duplicate-set-field, missing-fields
pcall(function() vim.loader.enable() end)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '

require("lazy").setup({
  spec = {
    {
      'folke/tokyonight.nvim',
      priority = 1000,
      -- update word highlight to be less distracting
      opts = { style = "night", on_highlights = function(hl, c) hl.LspReferenceRead = { bg = c.bg_highlight } end },
      init = function()
        vim.cmd('colorscheme tokyonight')
      end
    },
    {
      'echasnovski/mini.basics',
      opts = {
        mappings = { windows = true, move_with_alt = true },
        autocommands = { relnum_in_visual_mode = true },
      }
    },
    { 'echasnovski/mini.icons',      opts = {} },
    -- Test this out. might want something similar to vscode
    { 'echasnovski/mini.statusline', opts = {} },
    { 'lewis6991/gitsigns.nvim',     opts = {} },
    -- Detect tabstop and shiftwidth automatically
    { 'tpope/vim-sleuth' },
    {
      'nvim-treesitter/nvim-treesitter',
      main = 'nvim-treesitter.configs',
      opts = {
        auto_install = true,
        highlight = {
          enable = true
        },
        -- TODO: update keybinds for selection
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<cr>',
            node_incremental = '<cr>',
            scope_incremental = false,
            node_decremental = '<bs>',
          }
        },
        -- indent based on treesitter for = operator
        indent = {
          enable = true
        }
      }
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        {
          'saghen/blink.cmp',
          version = 'v0.*',
          ---@module 'blink.cmp'
          ---@type blink.cmp.Config
          opts = {
            keymap = { preset = 'enter' },
            completion = { documentation = { auto_show = true }, menu = { draw = { treesitter = { 'lsp' } } } },
            signature = { enabled = true },
            sources = { cmdline = {} }
          }
        }
      },
      config = function()
        local lspconfig = require('lspconfig')
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        lspconfig.lua_ls.setup {
          capabilities = capabilities,
          on_attach = function(client, buf_id)
            -- Reduce unnecessarily long list of completion triggers for better completion experience
            client.server_capabilities.completionProvider.triggerCharacters = { '.', ':' }

            require('lsp_utils').on_attach(client, buf_id)
          end,
          settings = {
            Lua = {
              hint = { enable = true, arrayIndex = "Disable" }
            }
          }
        }
      end,
    },
    -- configure LuaLS for editing neovim config
    { 'folke/lazydev.nvim',      ft = 'lua', opts = { library = { "snacks.nvim" } } },
    { 'mfussenegger/nvim-jdtls', ft = 'java' },
    {
      'mfussenegger/nvim-lint',
      config = function()
        local lint = require('lint')
        vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
          group = vim.api.nvim_create_augroup('lint', {}),
          callback = function()
            if vim.opt_local.modifiable:get() then
              -- ft specific
              lint.try_lint()
              -- for all fts
              lint.try_lint("codespell")
            end
          end,
        })
      end
    },
    {
      'echasnovski/mini.notify',
      -- lazy after initial ui
      event = 'VeryLazy',
      config = function()
        require('mini.notify').setup()
        vim.notify = MiniNotify.make_notify()
      end
    },
    -- indent lines + ii and ai for text objects
    { 'echasnovski/mini.indentscope', opts = {} },
    {
      'echasnovski/mini.files',
      config = function()
        require('mini.files').setup()
        vim.keymap.set('n', '<Leader>e', function() if not MiniFiles.close() then MiniFiles.open() end end,
          { desc = "File [E]xplorer" })
        vim.keymap.set('n', '<Leader>E',
          function() if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end end,
          { desc = "Current File [E]xplorer" })
      end
    },
    -- example: change inside next argument (cina)
    { 'echasnovski/mini.ai',          event = 'VeryLazy', opts = {} },
    { 'echasnovski/mini.pairs',       event = 'VeryLazy', opts = {} },
    -- <M-(hjkl)> to move lines in N and V
    { "echasnovski/mini.move",        event = 'VeryLazy', opts = {} },
    {
      'folke/snacks.nvim',
      priority = 1000,
      lazy = false,
      opts = {
        input = {},
        words = {},
        dashboard = { example = "advanced" },
        statuscolumn = {},
        picker = {}
      },
      keys = {
        { '<Leader>d',        function() Snacks.bufdelete() end,                   desc = "Delete Buffer" },
        { "]]",               function() Snacks.words.jump(vim.v.count1) end,      desc = "Next Reference",          mode = { "n", "t" } },
        { "[[",               function() Snacks.words.jump(-vim.v.count1) end,     desc = "Prev Reference",          mode = { "n", "t" } },
        { "<M-p>",            function() Snacks.picker.smart() end,                desc = "Smart files picker" },
        { "<M-P>",            function() Snacks.picker.pickers() end,              desc = "Pickers" },
        { "<Leader><Leader>", function() Snacks.picker.buffers() end,              desc = "Buffers" },
        { "<Leader>f",        function() Snacks.picker.files() end,                desc = "Files" },
        { "<Leader>g",        function() Snacks.picker.git_diff() end,             desc = "Git diff files" },
        { "<Leader>/",        function() Snacks.picker.lines() end,                desc = "Search buffer lines" },
        { "<Leader>c",        function() Snacks.picker.grep_word() end,            desc = "Search word under cursor" },
        { "<Leader>l",        function() Snacks.picker.grep() end,                 desc = "Live grep project" },
        -- These could be inside lsp on_attach function but it's simpler to have them here
        -- gq is already bound to format lines using lsp
        { "gd",               function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition" },
        { "gD",               function() Snacks.picker.lsp_declarations() end,     desc = "Goto Declarations" },
        { "gY",               function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definitions" },
        -- TODO: remove these once they become defaults in nvim 0.11
        { "grn",              vim.lsp.buf.rename,                                  desc = "Rename References" },
        { "gra",              vim.lsp.buf.code_action,                             desc = "Code Actions",            mode = { "n", "x" } },
        { "grr",              function() Snacks.picker.lsp_references() end,       desc = "Goto References" },
        { "gri",              function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementations" },
        { "gO",               function() Snacks.picker.lsp_symbols() end,          desc = "Goto LSP Symbols" },
      }
    },
    { 'folke/which-key.nvim', event = 'VeryLazy', opts = { preset = 'helix' } },
  },
  checker = { enabled = true, notify = false },
})
