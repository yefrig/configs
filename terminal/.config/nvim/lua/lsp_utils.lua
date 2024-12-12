local M = {}

local fzf = require('fzf-lua')

M.on_attach = function(_, buf_id)
  vim.lsp.inlay_hint.enable(true)

  local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { buffer = buf_id, desc = 'LSP: ' .. desc })
  end

  -- gq is already bound to format lines using lsp
  map('gd', function() fzf.lsp_definitions({ jump_to_single_result = true, ignore_current_line = true }) end,
    '[G]oto [D]definition')
  map('grr', function() fzf.lsp_references({ jump_to_single_result = true, ignore_current_line = true }) end,
    '[G]oto [R]eferences')
  map('gI', fzf.lsp_implementations, '[G]oto [I]mplementation')
  map('gD', fzf.lsp_declarations, '[G]oto [D]eclaration')
  map('gY', fzf.lsp_typedefs, '[G]oto T[Y]pe Definition')
  map('grn', vim.lsp.buf.rename, '[G]oto [R]e[n]ame')
  map('gra', fzf.lsp_code_actions, '[C]ode [A]ction', { 'n', 'x' })
end

return M
