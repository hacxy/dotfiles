return {
  'neovim/nvim-lspconfig',
  dependencies = { 'saghen/blink.cmp' },
  config = function(_)
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local severity = vim.diagnostic.severity

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    vim.diagnostic.config({
      update_in_insert = true,
      virtual_text = true,
      signs = {
        text = {
          [severity.ERROR] = ' ',
          [severity.WARN] = ' ',
          [severity.HINT] = '󰠠 ',
          [severity.INFO] = ' ',
        },
      },
    })
  end,
}
