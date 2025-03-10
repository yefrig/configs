return {
  -- branches are only needed until v5 is released for astronvim
  {
    "AstroNvim/astrocore",
    version = false,
    branch = "v2",
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
    version = false,
    branch = "v3",
    ---@type AstroLSPOpts
    opts = { features = { inlay_hints = true } }
  },
  {
    "AstroNvim/astroui",
    version = false,
    branch = "v3",
    ---@type AstroUIOpts
    opts = { colorscheme = "astrodark" }
  },
}
