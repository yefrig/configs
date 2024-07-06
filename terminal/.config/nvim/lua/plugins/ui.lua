return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
    },
  },
  "rebelot/kanagawa.nvim",
  {
    "LazyVim/LazyVim",
    dependencies = {
      "Shatur/neovim-ayu",
    },
    opts = {
      colorscheme = "kanagawa",
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
