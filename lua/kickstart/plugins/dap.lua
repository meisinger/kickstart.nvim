return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      dependencies = {
        'mfussenegger/nvim-dap',
        'nvim-neotest/nvim-nio',
      },
      keys = {
        {
          '<leader>du',
          function()
            require('dapui').toggle {}
          end,
          desc = 'Dap UI',
        },
        {
          '<leader>de',
          function()
            require('dapui').eval()
          end,
          desc = 'Eval',
          mode = { 'n', 'v' },
        },
      },
      opts = {
        controls = {
          enabled = false,
        },
      },
      config = function(_, opts)
        local dap = require 'dap'
        local dapui = require 'dapui'
        local widgets = require 'dap.ui.widgets'

        local debug_keys_set = false
        local debug_ui_open = false

        local function set_debug_keys()
          if debug_keys_set then return end

          vim.keymap.set('n', '<S-F5>', function ()
            dap.disconnect { terminateDebuggee = false }
          end, { desc = 'Debug: Disconnect' })
          vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug; Step Over' })
          vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
          vim.keymap.set('n', '<F12>', dap.setp_out, { desc = 'Debug: Step Out' })
          vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, { desc = 'Debug: Run to Cursor' })
          vim.keymap.set('n', '<leader>dr', dap.repl.toggle, { desc = 'Debug: Toggle REPL' })
          vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Debug: Terminate' })
          vim.keymap.set('n', '<leader>dw', widgets.hover, { desc = 'Debug: Widgets' })
          debug_keys_set = true
        end

        local function clear_debug_keys()
          if not debug_keys_set then return end

          pcall(vim.keymap.del, 'n', '<S-F5>')
          pcall(vim.keymap.del, 'n', '<F10>')
          pcall(vim.keymap.del, 'n', '<F11>')
          pcall(vim.keymap.del, 'n', '<F12>')
          pcall(vim.keymap.del, 'n', '<leader>dc')
          pcall(vim.keymap.del, 'n', '<leader>dr')
          pcall(vim.keymap.del, 'n', '<leader>dt')
          pcall(vim.keymap.del, 'n', '<leader>dw')
          debug_keys_set = false
        end

        local function open_ui()
          if debug_ui_open then return end

          dapui.open {}
          debug_ui_open = true
        end

        local function close_ui()
          if not debug_ui_open then return end

          dapui.close {}
          debug_ui_open = false
        end

        dapui.setup(opts)
        dap.listeners.after.event_initialized['dap-keys'] = set_debug_keys
        dap.listeners.before.event_terminated['dap-keys'] = clear_debug_keys
        dap.listeners.before.event_exited['dap-keys'] = clear_debug_keys

        dap.listeners.after.event_initialized['dapui_config'] = open_ui
        dap.listeners.before.event_terminated['dapui_config'] = close_ui
        dap.listeners.before.event_exited['dapui_config'] = close_ui

        dap.adapters.coreclr = {
          type = 'executable',
          command = vim.fn.exepath 'netcoredbg',
          args = { '--interpreter=vscode' },
        }

        dap.configurations.cs = {
          {
            type = 'coreclr',
            name = 'Launch - dotnet core',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to dll:', vim.fn.getcwd() .. '/bin/Debug', 'file')
            end,
          },
          {
            type = 'coreclr',
            name = 'Unit Test - dotnet core',
            request = 'launch',
            program = 'dotnet',
            args = { 'test', '--no-build', '--verbosity', 'normal' },
            cwd = '${workspaceFolder}',
            stopAtEntry = false,
            console = 'internalConsole',
          },
          {
            type = 'coreclr',
            name = 'Attach - dotnet core',
            request = 'attach',
            processId = require('dap.utils').pick_process,
          }
        }
      end,
    },
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {},
    },
    --[[
    {
      'jay-babu/mason-nvim-dap.nvim',
      dependencies = {
        'williamboman/mason.nvim',
        'mfussenegger/nvim-dap',
      },
      cmd = { 'DapInstall', 'DapUninstall' },
      opts = {
        automatic_installation = true,
        handlers = {},
        ensure_installed = { 'coreclr' },
      },
    },
    ]]
    --
  },
  keys = function()
    local dap = require 'dap'
    return {
      {
        '<F5>',
        function()
          if (not dap.session()) or (not dap.session().config) then
            dap.continue()
          else
            dap.run_to_cursor()
          end
        end,
        desc = 'Debug: Start/Continue',
      },
      {
        '<F9>',
        function()
          dap.toggle_breakpoint()
        end,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<S-F9>',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
    }
  end,
  config = function()
    local dap = require 'dap'
    dap.set_log_level 'TRACE'
  end,
}
