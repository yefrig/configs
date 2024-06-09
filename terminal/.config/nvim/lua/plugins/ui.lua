return {
  {
    "LazyVim/LazyVim",
    dependencies = {
      "Shatur/neovim-ayu",
    },
    opts = {
      colorscheme = "catppuccin",
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
