-- 将 <space> 设置为 leader 键
-- 参见 `:help mapleader`
--  注意：必须在加载插件之前设置（否则会使用错误的 leader 键）
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 如果你在终端中安装并选择了 Nerd Font，请设置为 true
vim.g.have_nerd_font = true

-- 默认显示行号
vim.o.number = true
-- 相对行号
-- vim.opt.relativenumber = true
-- 高亮光标所在的行
vim.o.cursorline = true
-- tab转为空格
vim.o.expandtab = true
-- tab占用空格数
vim.o.tabstop = 2
vim.o.shiftwidth = 0

vim.o.autoread = true

-- 启用鼠标模式，例如调整分割窗口大小很有用！
-- vim.o.mouse = 'a'

-- 显示模式
vim.o.showmode = true

-- 在操作系统和 Neovim 之间同步剪贴板。
--  在 `UiEnter` 之后安排设置，因为它可能会增加启动时间。
--  如果你希望操作系统的剪贴板保持独立，请删除此选项。
--  参见 `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- 保持文本不换行
vim.o.wrap = false
vim.o.showbreak = ''

-- 启用断行缩进
vim.o.breakindent = true

-- 保存撤销历史
vim.o.undofile = true

-- 不区分大小写搜索，除非搜索词中有 \C 或一个或多个大写字母
vim.o.ignorecase = true
vim.o.smartcase = true

-- 默认保持符号列开启
vim.o.signcolumn = 'yes'

-- 减少更新时间
vim.o.updatetime = 250

-- 减少映射序列等待时间
-- vim.o.timeoutlen = 300

-- 配置如何打开新的分割窗口
vim.o.splitright = true
vim.o.splitbelow = true

-- 设置 neovim 如何在编辑器中显示某些空白字符。
--  参见 `:help 'list'`
--  和 `:help 'listchars'`
--
--  注意 listchars 使用 `vim.opt` 而不是 `vim.o` 设置。
--  它与 `vim.o` 非常相似，但提供了一个接口来方便地与表交互。
--   参见 `:help lua-options`
--   和 `:help lua-options-guide`
-- vim.o.list = true
-- vim.opt.listchars = { tab = '» ', trail = ' ', nbsp = '␣' }

-- 实时预览替换，在你输入时
vim.o.inccommand = 'split'

-- 在光标上方和下方保持的最小屏幕行数。
vim.o.scrolloff = 10

-- 如果由于缓冲区中有未保存的更改而执行操作会失败（如 `:q`），
-- 则弹出一个对话框询问你是否希望保存当前文件
-- 参见 `:help 'confirm'`
vim.o.confirm = true
