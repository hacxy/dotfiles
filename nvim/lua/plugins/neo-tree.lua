return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    keys = {
      {
        "<leader>e",
        function()
          -- 使用 reveal 命令：如果文件树未打开则打开并聚焦到当前文件，如果已打开则聚焦到当前文件
          -- 如果需要关闭，可以在文件树窗口内按 <leader>e
          vim.cmd.Neotree "reveal"
        end,
        desc = "切换文件资源管理器",
        silent = true,
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      local refresh = function()
        local ok, manager = pcall(require, "neo-tree.sources.manager")
        if ok then
          manager.refresh("filesystem")
        end
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "TermClose", "ShellCmdPost" }, {
        callback = refresh,
      })
    end,
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      git_status_async = true,
      filesystem = {
        use_libuv_file_watcher = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        window = {
          mappings = {
            ["<leader>e"] = "close_window",
            ["<space>"] = nil, -- 移除 space 键的映射
          },
        },
        filtered_items = {
          never_show = {
            ".git",
          },
        },
      },
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            -- auto close
            -- vimc.cmd("Neotree close")
            -- OR
            require("neo-tree.command").execute { action = "close" }
          end,
        },
      },
    },
  },
}
