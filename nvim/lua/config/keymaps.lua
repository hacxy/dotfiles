-- [[ 基本快捷键映射 ]]
--  参见 `:help vim.keymap.set()`

-- 在普通模式下按 <Esc> 时清除搜索高亮
--  参见 `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- 诊断快捷键映射
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = '打开诊断 [Q]uickfix 列表' })

-- 提示：在普通模式下禁用方向键
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- 使分割窗口导航更容易的快捷键绑定。
--  使用 CTRL+<hjkl> 在窗口之间切换
--
--  所有窗口命令列表，请参见 `:help wincmd`
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = '将焦点移动到左侧窗口' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = '将焦点移动到右侧窗口' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = '将焦点移动到下方窗口' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = '将焦点移动到上方窗口' })

-- 按ctrl + s 保存并回到默认模式
vim.keymap.set('i', '<C-s>', '<cmd>w<CR><esc>', { desc = '保存并回到默认模式', silent = true })
vim.keymap.set('n', '<C-s>', '<cmd>w<CR><esc>', { desc = '保存并回到默认模式', silent = true })

-- 按 <leader>q 退出编辑器
vim.keymap.set('n', '<leader>qq', '<cmd>q<CR>', { desc = '退出编辑器' })

-- 撤回
vim.keymap.set({ 'n', 'i' }, '<D-z>', '<Cmd>undo<CR>', { silent = true })

-- buffer
vim.keymap.set({ 'n' }, '<leader>bd', '<Cmd>bdelete<CR>', { silent = true })

-- Markdown 预览
vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', { desc = 'Markdown 预览切换', silent = true })
