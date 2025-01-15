return {
  'stevearc/oil.nvim',
  --@module 'oil'
  --@type oil.SetupOpts
  opts = {},
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  config = function()
    require('oil').setup {
      columns = { 'icon' },
      view_options = {
        show_hidden = true,
      },
    }

    vim.keymap.set('n', '_', '<cmd>Oil<cr>', { desc = 'Open current directory' })
    vim.keymap.set('n', '<space>_', require('oil').toggle_float)
  end,
}
