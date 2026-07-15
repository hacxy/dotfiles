return {
  'saghen/blink.cmp',
  version = '1.*',
  opts = {
    completion = {
      accept = {
        auto_brackets = { enabled = false }, -- 不启用自动补全括号
      },
    },
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-D>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-P>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-N>'] = { 'scroll_documentation_down', 'fallback' },
    },
    cmdline = {
      keymap = {
        ['<C-j>'] = { 'show_and_insert_or_accept_single', 'select_next' },
        ['<C-k>'] = { 'show_and_insert_or_accept_single', 'select_prev' },
      },
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
  },
}
