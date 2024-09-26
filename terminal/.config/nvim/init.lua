
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

-- Mini.nvim

require("mini.deps").setup({ path = { package = path_package } })

-- TODO: deal with lazy loading later using now() and later()
local add = MiniDeps.add

vim.cmd.colorscheme("randomhue")

-- TODO: might want to disable helper symbols but keep extra_ui goodies enabled
require("mini.basics").setup({
	options = { extra_ui = true },
	mappings = { windows = true, move_with_alt = true },
	autocommands = { relnum_in_visual_mode = true },
})
-- TODO: use tweak_lsp_kind()
require("mini.icons").setup()
MiniDeps.later(MiniIcons.tweak_lsp_kind)

require("mini.statusline").setup()
require("mini.ai").setup()
require("mini.git").setup()
-- TODO: test around provided mappings
require("mini.diff").setup()
require("mini.completion").setup()

-- Core Plugins

-- NOTE: both mason and nvim-lspconfig are loaded instantly to avoid issues when opening files
add('williamboman/mason.nvim')
require('mason').setup()


add({
	source = 'neovim/nvim-lspconfig',
	depends = { 'williamboman/mason.nvim'}
})
local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				version = 'LuaJIT'
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true)
			}
		})
	end,
	settings = {
		Lua = {}
	}
}

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
