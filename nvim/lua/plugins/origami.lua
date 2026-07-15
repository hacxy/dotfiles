return {
  'chrisgrieser/nvim-origami',
  event = 'VeryLazy',
  opts = {
    foldKeymaps = {
      setup = false,
    },
  },
  -- recommended: disable vim's auto-folding
  init = function()
    vim.o.foldcolumn = '0' -- '0' is not bad
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.foldmethod = 'expr'
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
}
