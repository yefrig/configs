return {
  {
    "ibhagwan/fzf-lua",
    opts = {
      fzf_opts = {
        ["--cycle"] = true,
      },
    },
    keys = {
      { "<C-\\>", "<Cmd>FzfLua buffers<CR>", desc = "Fzf: buffers" },
      { "<C-k>", "<Cmd>FzfLua builtin<CR>", desc = "Fzf: builtin" },
      { "<C-p>", "<Cmd>FzfLua files<CR>", desc = "Fzf: files" },
      { "<C-/>", "<Cmd>FzfLua lgrep_curbuf<CR>", desc = "Fzf: live grep buffer" },
      { "<C-g>", "<Cmd>FzfLua grep_project<CR>", desc = "Fzf: grep project" },
    },
  },
}
