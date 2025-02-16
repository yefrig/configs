----@diagnostic disable: duplicate-set-field, missing-fields
pcall(function() vim.loader.enable() end)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = ","

vim.opt.cmdheight = 0 -- hide command line unless needed

vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

require("lazy").setup({
  spec = {
    {
      'rose-pine/neovim',
      name = 'rose-pine',
      opts = {
        highlight_groups = {
          -- Needed for java to look decent
          ["@lsp.type.modifier.java"] = { link = "@keyword" }
        }
      },
      init = function()
        vim.cmd('colorscheme rose-pine')
      end
    },
    {
      'echasnovski/mini.basics',
      opts = {
        mappings = { windows = true, move_with_alt = true },
        autocommands = { relnum_in_visual_mode = true },
      }
    },
    { 'echasnovski/mini.icons',       opts = {} },
    'HiPhish/rainbow-delimiters.nvim',
    -- TODO: separate dev info into groups highlighted differently
    { 'echasnovski/mini.statusline',  opts = {} },
    -- indent lines + ii and ai for text objects
    { 'echasnovski/mini.indentscope', opts = {} },
    { "j-hui/fidget.nvim",            opts = { notification = { override_vim_notify = true } } },
    { 'sindrets/diffview.nvim',       opts = {}, cmd = { 'DiffviewOpen', 'DiffviewFileHistory' } },
    -- Detect tabstop and shiftwidth automatically
    { 'tpope/vim-sleuth' },
    {
      'nvim-treesitter/nvim-treesitter',
      main = 'nvim-treesitter.configs',
      opts = {
        auto_install = true,
        highlight = { enable = true },
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
        indent = { enable = true }
      }
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        {
          'yefrig/blink.cmp',
          version = 'v0.*',
          ---@module 'blink.cmp'
          ---@type blink.cmp.Config
          opts = {
            keymap = { preset = 'enter' },
            completion = {
              documentation = { auto_show = true },
              menu = { draw = { treesitter = { 'lsp' } } },
            },
            signature = { enabled = true },
            sources = { cmdline = {} }
          }
        }
      },
      config = function()
        local methods = vim.lsp.protocol.Methods
        local lspconfig = require('lspconfig')
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        local on_attach = function(client, buf_id)
          vim.lsp.inlay_hint.enable(true)
          vim.lsp.codelens.refresh({ bufnr = buf_id })
          vim.diagnostic.config({ float = { source = 'if_many', border = 'rounded' }, virtual_lines = { current_line = true } })

          if client:supports_method(methods.textDocument_formatting) then
            vim.keymap.set('n', 'gQ', vim.lsp.buf.format, { desc = 'Format Buffer' })
          end

          vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
            buffer = buf_id,
            group = vim.api.nvim_create_augroup('lsp-codelens', {}),
            callback = function() vim.lsp.codelens.refresh({ bufnr = 0 }) end
          })
        end

        -- Update configs globally
        lspconfig.util.default_config = vim.tbl_extend(
          "force",
          lspconfig.util.default_config,
          {
            capabilities = capabilities,
            on_attach = on_attach
          }
        )

        lspconfig.lua_ls.setup {
          settings = {
            Lua = {
              hint = { enable = true, arrayIndex = "Disable" }
            }
          }
        }
        lspconfig.jsonls.setup({})
        lspconfig.clojure_lsp.setup({})
        -- basically a spell checker but with code actions!
        lspconfig.typos_lsp.setup({})
      end,
    },
    -- configure LuaLS for editing neovim config
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          "snacks.nvim",
          "mini.diff",
          { path = "${3rd}/luv/library", words = { "vim%.uv" } }, }
      }
    },
    { 'mfussenegger/nvim-jdtls', ft = 'java' },
    -- example: change inside next argument (cina)
    { 'echasnovski/mini.ai',          event = 'VeryLazy', opts = {} },
    { 'echasnovski/mini.pairs',       event = 'VeryLazy', opts = {} },
    { 'echasnovski/mini-git',         event = 'VeryLazy', opts = {}, main = 'mini.git' },
    {
      'echasnovski/mini.diff',
      event = 'VeryLazy',
      opts = {},
      keys = { { '\\o', function() MiniDiff.toggle_overlay(0) end, desc = 'Toggle Overlay (git)' } }
    },
    -- <M-(hjkl)> to move lines in N and V
    { "echasnovski/mini.move",        event = 'VeryLazy', opts = {} },
    {
      'folke/snacks.nvim',
      priority = 1000,
      lazy = false,
      opts = {
        input = {},
        words = {},
        dashboard = { example = "compact_files" },
        statuscolumn = {},
        picker = {},
        explorer = {}
      },
      keys = {
        { '<Leader>e',        function() Snacks.explorer.open() end,                       desc = 'Open explorer' },
        { '<Leader>E',        function() Snacks.explorer.open({ follow_file = true }) end, desc = 'Open explorer from current file' },
        { '<Leader>d',        function() Snacks.bufdelete() end,                           desc = "Delete Buffer" },
        { "]]",               function() Snacks.words.jump(vim.v.count1) end,              desc = "Next Reference",                 mode = { "n", "t" } },
        { "[[",               function() Snacks.words.jump(-vim.v.count1) end,             desc = "Prev Reference",                 mode = { "n", "t" } },
        { "<M-p>",            function() Snacks.picker.smart() end,                        desc = "Smart files picker" },
        { "<M-P>",            function() Snacks.picker.pickers() end,                      desc = "Pickers" },
        { "<Leader><Leader>", function() Snacks.picker.buffers() end,                      desc = "Buffers" },
        { "<Leader>f",        function() Snacks.picker.files() end,                        desc = "Files" },
        { "<Leader>/",        function() Snacks.picker.lines() end,                        desc = "Search buffer lines" },
        { "<Leader>c",        function() Snacks.picker.grep_word() end,                    desc = "Search word under cursor" },
        { "<Leader>l",        function() Snacks.picker.grep() end,                         desc = "Live grep project" },
        -- These could be inside lsp on_attach function but it's simpler to have them here
        -- gq is already bound to format lines using lsp
        { "gd",               function() Snacks.picker.lsp_definitions() end,              desc = "Goto Definition" },
        { "gD",               function() Snacks.picker.lsp_declarations() end,             desc = "Goto Declarations" },
        { "gY",               function() Snacks.picker.lsp_type_definitions() end,         desc = "Goto Type Definitions" },
        -- TODO: remove these once they become defaults in nvim 0.11
        { "grn",              vim.lsp.buf.rename,                                          desc = "Rename References" },
        { "gra",              vim.lsp.buf.code_action,                                     desc = "Code Actions",                   mode = { "n", "x" } },
        { "grr",              function() Snacks.picker.lsp_references() end,               desc = "Goto References" },
        { "gri",              function() Snacks.picker.lsp_implementations() end,          desc = "Goto Implementations" },
        { "gO",               function() Snacks.picker.lsp_symbols() end,                  desc = "Goto LSP Symbols" },
      }
    },
    { 'folke/which-key.nvim', event = 'VeryLazy', opts = { preset = 'helix' } },
  },
  checker = { enabled = true, notify = false },
})
