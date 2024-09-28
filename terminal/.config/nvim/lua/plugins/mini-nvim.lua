return {
  {
    "echasnovski/mini.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              -- mini.files is managed by astrocommunity to allow it to disable other plugins
              ["<Leader>E"] = {
                function()
                  local minifiles = require "mini.files"
                  if not minifiles.close() then minifiles.open(vim.api.nvim_buf_get_name(0)) end
                end,
                desc = "Explorer (File)",
              },
            },
          },
        },
      },
    },
    config = function(_, _)
      require("mini.ai").setup()
      -- most opts are dropped but keybinds and auto commands still useful
      require("mini.basics").setup {
        mappings = { windows = true, move_with_alt = true },
        autocommands = { relnum_in_visual_mode = true },
      }
      require("mini.bracketed").setup()
    end,
  },
}
