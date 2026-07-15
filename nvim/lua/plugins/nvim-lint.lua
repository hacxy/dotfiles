return {
  {
    'mfussenegger/nvim-lint',
    event = {
      'BufReadPre',
      'BufNewFile',
    },
    config = function()
      local lint = require('lint')

      lint.linters_by_ft = {
        javascript = { 'eslint' },
        typescript = { 'eslint' },
        javascriptreact = { 'eslint' },
        typescriptreact = { 'eslint' },
        -- svelte = { 'eslint' },
        -- python = { 'pylint' },
      }

      vim.keymap.set('n', '<leader>l', function()
        lint.try_lint()
      end, { desc = 'lint file' })
    end,
  },
}
