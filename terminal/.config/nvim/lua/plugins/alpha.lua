---@type LazySpec
return {
  "goolord/alpha-nvim",
  dependencies = {
    "MaximilianLloyd/ascii.nvim",
  },
  opts = function(_, opts) opts.section.header.val = require("ascii").get_random_global() end,
}
