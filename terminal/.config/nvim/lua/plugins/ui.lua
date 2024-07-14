return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
    },
  },
  "rebelot/kanagawa.nvim",
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      highlight_groups = {
        DashboardDesc = { fg = "rose" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    dependencies = {
      "Shatur/neovim-ayu",
    },
    opts = {
      colorscheme = "rose-pine",
    },
  },
  {
    "nvimdev/dashboard-nvim",
    dependencies = {
      "MaximilianLloyd/ascii.nvim",
    },
    opts = function(_, opts)
      local ascii = require("ascii")
      if opts.config == nil then
        opts.config = {}
      end
      opts.config.header = ascii.get_random_global()
    end,
  },
}
