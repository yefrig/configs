local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
vim.fn.mkdir(workspace_dir, "p")

local root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" })

local jdtls = require('jdtls')
local default_config = require('lspconfig').util.default_config

local config = {
  -- nvim-jdtls does not merge with lspconfig so defaults need to be added manually
  capabilities = default_config.capabilities,
  cmd = {
    -- point to jdtls installation
    vim.fn.expand "~/projects/jdt/bin/jdtls",
    "-configuration",
    vim.fn.expand "~/.cache/jdtls",
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {
      eclipse = { downloadSources = true },
      configuration = { updateBuildConfiguration = "interactive" },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },
  filetypes = { "java" },
}

jdtls.start_or_attach(config)
