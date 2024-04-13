local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", ".project" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/site/java/workspace-root/" .. project_name
vim.fn.mkdir(workspace_dir, "p")

local config = {
	cmd = {
		"jdtls",
		"--jvm-arg=" .. "-javaagent:" .. vim.fn.expand("$MASON/share/jdtls/lombok.jar"),
		"-configuration",
		vim.fn.expand("$MASON/share/jdtls/config"),
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
		},
		signatureHelp = { enabled = true },
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
	},
	init_options = {},
	handlers = {
		["$/progress"] = function() end, -- disable progress updates.
	},
	filetypes = { "java" },
}

require("jdtls").start_or_attach(config)
-- vim: ts=2 sts=2 sw=2 et
