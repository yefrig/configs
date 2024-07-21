return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    opts.jdtls = {
      handlers = {
        ["$/progress"] = function() end, -- disable progress updates.
      },
      settings = {
        java = {
          signatureHelp = {
            enabled = true,
          },
          configuration = {
            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            -- And search for `interface RuntimeOption`
            -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
            -- runtimes = {
            --   {
            --     name = "JavaSE_1_8",
            --     path = ws_root_dir .. "/env/OpenJDK8-1.1/runtime/jdk1.8/",
            --     default = true,
            --   },
            -- }
          },
          completion = {
            guessMethodArguments = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          inlayHints = {
            parameterNames = {
              enabled = "all", -- literals, all, none
            },
          },
          extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
          -- format = {
          --   settings = {
          --     url = vim.fn.stdpath("config") .. "/tidbits/eclipse-java-google-style.xml",
          --     profile = "GoogleStyle",
          --   },
          -- },
        },
      },
    }
  end,
}
