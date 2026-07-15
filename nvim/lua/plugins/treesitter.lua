--@module "lazy"
--@type LazySpec

vim.g.ts_install = {
  'bash',
  'comment',
  'css',
  'diff',
  'fish',
  'git_config',
  'git_rebase',
  'gitcommit',
  'gitignore',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'regex',
  'scss',
  'toml',
  'tsx',
  'typescript',
  'typst',
  'vim',
  'vimdoc',
  'vue',
  'xml',
}

local ts_install = vim.g.ts_install or {}
local ts_filetypes = vim
  .iter(ts_install)
  :map(function(lang)
    return vim.treesitter.language.get_filetypes(lang)
  end)
  :flatten()
  :totable()

return {
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
    },
    config = function()
      local ts = require('nvim-treesitter').install(ts_install)

      vim.api.nvim_create_autocmd('FileType', {
        desc = 'Setup treesitter for a buffer',
        -- NOTE: We explicitly define filetypes
        pattern = ts_filetypes,
        group = vim.api.nvim_create_augroup('ts_setup', { clear = true }),
        callback = function(e)
          vim.treesitter.start(e.buf)
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
