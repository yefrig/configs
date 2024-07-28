---@type LazySpec
return {
  "ibhagwan/fzf-lua",
  opts = {
    fzf_opts = {
      ["--cycle"] = true,
    },
  },
  dependencies = {
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            ["<C-k>"] = {
              function() require("fzf-lua").builtin() end,
              desc = "Fzf: builtin",
            },
          },
        },
      },
    },
  },
}
