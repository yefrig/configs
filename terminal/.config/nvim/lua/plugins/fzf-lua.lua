return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      "default",
    },
    keys = {
      { "<C-\\>", "<Cmd>FzfLua buffers<CR>", desc = "Fzf: buffers" },
      { "<C-k>", "<Cmd>FzfLua builtin<CR>", desc = "Fzf: builtin" },
      { "<C-p>", "<Cmd>FzfLua files<CR>", desc = "Fzf: files" },
      { "<C-l>", "<Cmd>FzfLua lgrep_curbuf<CR>", desc = "Fzf: live grep buffer" },
      { "<C-g>", "<Cmd>FzfLua grep_project<CR>", desc = "Fzf: grep project" },
    },
  },
}
