return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")
      local actions = require('telescope.actions')

      -- Function to toggle Telescope find_files
      local function toggle_telescope_find_files()
        -- Get the list of all open windows
        local windows = vim.api.nvim_list_wins()

        -- Check if any of the open windows is a TelescopePrompt
        for _, win in ipairs(windows) do
          local buf = vim.api.nvim_win_get_buf(win)
          local buf_ft = vim.api.nvim_buf_get_option(buf, 'filetype')

          -- If a Telescope window is open, close it immediately
          if buf_ft == 'TelescopePrompt' then
            vim.api.nvim_win_close(win, true) -- Force close the Telescope window
            return
          end
        end

        -- If no Telescope window is open, open Telescope find_files and start in insert mode
        builtin.find_files({
          attach_mappings = function(_, map)
            -- Bind <M-2> to close Telescope even when in insert mode
            map('i', '<M-2>', actions.close)
            map('n', '<M-2>', actions.close)
            return true
          end,
        })
      end

      -- Set keymaps
      vim.keymap.set('n', '<C-p>', builtin.find_files, {})
      vim.keymap.set('n', '<leader>p', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

      -- Use <M-2> to toggle Telescope find_files
      vim.keymap.set('n', '<M-2>', toggle_telescope_find_files, {})
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown{
            }
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  }
}

