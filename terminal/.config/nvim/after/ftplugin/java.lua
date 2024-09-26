-- use this function notation to build some variables
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }
local root_dir = require("jdtls.setup").find_root(root_markers)
-- calculate workspace dir
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
vim.fn.mkdir(workspace_dir, "p")

local opts = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. vim.fn.expand "$MASON/share/jdtls/lombok.jar",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		vim.fn.expand "$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
		"-configuration",
		vim.fn.expand "$MASON/share/jdtls/config",
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
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
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
	init_options = {
		bundles = {
			vim.fn.expand "$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
			-- unpack remaining bundles
			(table.unpack or unpack)(vim.split(vim.fn.glob "$MASON/share/java-test/*.jar", "\n", {})),
		},
	},
	handlers = {
		["$/progress"] = function() end, -- disable progress updates.
	},
	filetypes = { "java" },
	on_attach = function(...)
		require("jdtls").setup_dap { hotcodereplace = "auto" }
		local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
		if astrolsp_avail then astrolsp.on_attach(...) end
	end,
}

require("jdtls").start_or_attach(opts)
