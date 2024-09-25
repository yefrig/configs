-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup({ path = { package = path_package } })

local add, later = MiniDeps.add, MiniDeps.later

vim.cmd.colorscheme("randomhue")

-- TODO: might want to disable helper symbols but keep extra_ui goodies enabled
require("mini.basics").setup({
	options = { extra_ui = true },
	mappings = { windows = true, move_with_alt = true },
	autocommands = { relnum_in_visual_mode = true },
})
require("mini.statusline").setup()

later(function() require("mini.ai").setup() end)
later(function() require("mini.git").setup() end)
-- TODO: test around provided mappings
later(function() require("mini.diff").setup() end)

-- Core Plugins
later(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	require("nvim-treesitter.configs").setup({
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
	})
end)
