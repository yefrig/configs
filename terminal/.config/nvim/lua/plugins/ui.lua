return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
    },
  },
  "rebelot/kanagawa.nvim",
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      highlight_groups = {
        DashboardDesc = { fg = "rose" },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    dependencies = {
      "Shatur/neovim-ayu",
    },
    opts = {
      colorscheme = "rose-pine",
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
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local lsp_source = opts.sources[1]
      assert(lsp_source.name == "nvim_lsp")
      lsp_source.entry_filter = function(entry, _)
        -- filter out snippets for all languages
        -- TODO: check if this can be disabled per language server
        return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
      end

      local lazy_format = opts.formatting.format

      opts.formatting = {
        -- Match order with vscode
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          -- Apply LazyVim's format func
          vim_item = lazy_format(entry, vim_item)
          -- drop text only keep icon
          vim_item.kind = vim.fn.strcharpart(vim_item.kind, 0, 1)

          -- This does two things:
          -- 1. appends parameter signature to abbr to better distinguish overloaded methods
          -- 2. uses the labelDetails.description (return type of func) in the menu (for non-methods this shows import path)
          --
          -- nvim-cmp just appends detail and description together in the menu which is malformatted and looks terrible
          --
          -- This matches the completion UI for vscode. Ref: https://github.com/microsoft/vscode/blob/main/src/vs/editor/contrib/suggest/browser/suggestWidgetRenderer.ts#L71
          -- AFAIK, this only works in Java where the signature and return type are sent by jdtls
          if entry.source.name == "nvim_lsp" and entry.source.source.client.name == "jdtls" then
            if vim_item and entry:get_kind() == require("cmp").lsp.CompletionItemKind.Method then
              local completion_item = entry:get_completion_item()
              vim_item.abbr = completion_item.label
                .. (completion_item.labelDetails and completion_item.labelDetails.detail or "")
              vim_item.menu = (completion_item.labelDetails and completion_item.labelDetails.description or "")
            end
          end
          return vim_item
        end,
      }
    end,
  },
}
