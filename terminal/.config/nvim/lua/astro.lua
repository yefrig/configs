local methods = vim.lsp.protocol.Methods
return {
  -- branches are only needed until v5 is released for astronvim
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      options = {
        opt = {
          relativenumber = false,
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      features = { inlay_hints = true },
      mappings = {
        n = {
          gd = {
            function() Snacks.picker.lsp_definitions() end,
            desc = 'Goto Definition',
            cond = methods.textDocument_definition
          },
          gD = {
            function() Snacks.picker.lsp_declarations() end,
            desc = 'Goto Declaration',
            cond = methods.textDocument_declaration
          },
          grr = {
            function() Snacks.picker.lsp_references() end,
            desc = 'Goto References',
            cond = methods.textDocument_references
          },
          gri = {
            function() Snacks.picker.lsp_implementations() end,
            desc = 'Goto Implementation',
            cond = methods.textDocument_implementation
          }
        }
      }
    }
  },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "astromars",
      highlights = {
        init = {
          ["@lsp.type.modifier"] = { link = "@modifier" },
          ["@lsp.type.class"] = { link = "@class" },
        }
      }
    }
  },
  { "nvim-neo-tree/neo-tree.nvim", opts = { filesystem = { group_empty_dirs = true } } },
  {
    "folke/lazydev.nvim",
    -- library is already setup to be extended by astronvim
    opts = { library = { { path = "snacks.nvim", words = { "Snacks" } } } },
  },
}
