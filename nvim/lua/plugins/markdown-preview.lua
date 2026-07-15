return {
  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {
      file = { [".keep"] = { glyph = "", hl = "MiniIconsGrey" } },
      filetype = { dotenv = { glyph = "", hl = "MiniIconsYellow" } },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    ft = { "markdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      -- 启用沉浸式渲染
      enabled = true,
      -- 渲染模式：普通模式、命令模式、终端模式
      render_modes = { "n", "c", "t" },
      -- 防隐藏设置：光标行显示原始内容
      anti_conceal = {
        enabled = true,
        above = 0,
        below = 0,
        ignore = {
          code_background = true,
          indent = true,
          sign = true,
          virtual_lines = true,
        },
      },
      -- 标题设置：沉浸式样式
      heading = {
        enabled = true,
        position = "overlay",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "full",
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },
      -- 代码块设置
      code = {
        enabled = true,
        sign = true,
        conceal_delimiters = true,
        language = true,
        position = "left",
        language_icon = true,
        language_name = true,
        language_info = true,
        disable_background = { "diff" },
        width = "block",
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = "thin",
        above = "▄",
        below = "▀",
        highlight = "RenderMarkdownCode",
        highlight_language = nil,
        highlight_inline = "RenderMarkdownCodeInline",
      },
      -- 行内代码
      inline_code = {
        enabled = true,
        highlight = "RenderMarkdownCodeInline",
      },
      -- 列表设置
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
        highlight = "RenderMarkdownBullet",
      },
      -- 复选框
      checkbox = {
        enabled = true,
        unchecked = {
          icon = "   ",
          highlight = "RenderMarkdownUnchecked",
        },
        checked = {
          icon = "   ",
          highlight = "RenderMarkdownChecked",
        },
      },
      -- 引用块
      quote = {
        enabled = true,
        icon = "▋",
        highlight = "RenderMarkdownQuote",
      },
      -- 表格
      table = {
        enabled = true,
        highlight = "RenderMarkdownTable",
      },
      -- 分隔线
      dash = {
        enabled = true,
        icon = "─",
        highlight = "RenderMarkdownDash",
      },
      -- 链接
      link = {
        enabled = true,
        image = "󰥶 ",
        email = "󰀓 ",
        hyperlink = "󰌹 ",
        highlight = "RenderMarkdownLink",
      },
      -- LaTeX 数学公式
      latex = {
        enabled = true,
        render_modes = false,
        converter = { "utftex", "latex2text" },
        inline = true,
        block = true,
        highlight = "RenderMarkdownMath",
        position = "center",
        top_pad = 0,
        bottom_pad = 0,
      },
      -- 集成设置
      completions = {
        lsp = { enabled = true },
      },
      -- 回调函数
      on = {
        attach = function() end,
        initial = function() end,
        render = function() end,
        clear = function() end,
      },
    },
  },
}
