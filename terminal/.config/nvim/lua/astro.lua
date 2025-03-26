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
    opts = { features = { inlay_hints = true } }
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
  { "nvim-neo-tree/neo-tree.nvim", opts = { filesystem = { group_empty_dirs = true } } }
}
