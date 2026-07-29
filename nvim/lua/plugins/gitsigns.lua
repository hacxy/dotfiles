return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Hunk 导航
      map('n', ']h', function()
        if vim.wo.diff then return ']h' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, '下一个 Git Hunk')

      map('n', '[h', function()
        if vim.wo.diff then return '[h' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, '上一个 Git Hunk')

      -- 操作
      map('n', '<leader>gp', gs.preview_hunk, '预览 Git Hunk')
      map('n', '<leader>gr', gs.reset_hunk, '撤销光标处 Git 变更')
      map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, '撤销选中 Git 变更')
      map('n', '<leader>gR', gs.reset_buffer, '撤销整个文件 Git 变更')
      map('n', '<leader>gs', gs.stage_hunk, '暂存 Git Hunk')
      map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, '暂存选中 Git 变更')
      map('n', '<leader>gS', gs.stage_buffer, '暂存整个文件')
      map('n', '<leader>gu', gs.undo_stage_hunk, '撤销暂存 Git Hunk')
      map('n', '<leader>gd', gs.diffthis, '对比 Git Diff')
    end,
  },
}
