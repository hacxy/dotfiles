return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = function()
    local vscode_settings = require('utils.vscode_settings')
    local vscodeSettings = vscode_settings.read_vscode_settings()

    local res = {
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'never' },
        typescript = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'never' },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'never' },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'never' },
        markdown = { 'prettierd', 'prettier', stop_after_first = true, lsp_format = 'never' },
      },
      format_after_save = {
        lsp_format = 'fallback',
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
      formatters = {
        prettier = {
          condition = function()
            return not vscodeSettings
          end,
        },
        prettierd = {
          condition = function()
            return not vscodeSettings
          end,
        },
      },
    }
    return res
  end,
}
