return {
  {
    "3rd/image.nvim",
    dependencies = {
      "leafo/magick", -- LuaRock for ImageMagick bindings
    },
    build = "luarocks --local --lua-version=5.1 install magick",
    event = "VeryLazy",
    opts = {
      backend = "kitty", -- 根据你的终端选择: kitty, iterm2, ueberzug
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
    },
    config = function(_, opts)
      -- 检查是否在 tmux 中
      if vim.env.TMUX then
        opts.backend = "kitty"
        opts.tmux_show_only_in_active_window = true
      end
      require("image").setup(opts)
    end,
  },
}
