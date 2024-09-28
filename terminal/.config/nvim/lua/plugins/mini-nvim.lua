return {
  {
    "echasnovski/mini.nvim",
    config = function(_, opts)
      -- most opts are dropped but keybinds and auto commands still useful
      require("mini.basics").setup {
        mappings = { windows = true, move_with_alt = true },
        autocommands = { relnum_in_visual_mode = true },
      }
    end,
  },
}
