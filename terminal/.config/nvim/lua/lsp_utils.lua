local M = {}

local methods = vim.lsp.protocol.Methods

M.on_attach = function(client, buf_id)
  vim.lsp.inlay_hint.enable(true)
  vim.lsp.codelens.refresh( { bufnr = buf_id })
  vim.diagnostic.config({ virtual_lines = { current_line = true } })

  if client:supports_method(methods.textDocument_formatting) then
    vim.keymap.set('n', 'gQ', vim.lsp.buf.format, { desc = 'Format Buffer' })
  end

  vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
    buffer = buf_id,
    group = vim.api.nvim_create_augroup('lsp-codelens', {}),
    callback = function() vim.lsp.codelens.refresh({ bufnr = 0 }) end
  })
end

return M
