local M = {}

M.on_attach = function(_, buf_id)
    vim.lsp.inlay_hint.enable(true)

    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = buf_id, desc = 'LSP: ' .. desc })
    end

    -- gq is already bound to format lines using lsp
    map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    map('grr', vim.lsp.buf.references, '[G]oto [R]eferences')
    map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gY', vim.lsp.buf.type_definition, '[G]oto T[Y]pe Definition')
    map('grn', vim.lsp.buf.rename, '[G]oto [R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
  end

return M
