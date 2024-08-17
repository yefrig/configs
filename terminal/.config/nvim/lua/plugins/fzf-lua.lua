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
            ["<C-p>"] = {
              function() require("fzf-lua").builtin() end,
              desc = "Fzf: builtin",
            },
            grr = {
              function() require("fzf-lua").lsp_references { jump_to_single_result = true, ignore_current_line = true } end,
              desc = "Show references",
            },
          },
        },
      },
    },
    {
      "AstroNvim/astrolsp",
      -- I don't know why providing an opts table drops the desc and cond keys of a mapping that is already defined
      opts = function(_, opts)
        if opts.mappings.n.gd then
          opts.mappings.n.gd[1] = function()
            require("fzf-lua").lsp_definitions { jump_to_single_result = true, ignore_current_line = true }
          end
        end
      end,
    },
  },
}
