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

        dapui.setup(opts)
        dap.listeners.after.event_initialized['dapui_config'] = function()
          dapui.open {}
        end
        dap.listeners.before.event_terminated['dapui_config'] = function()
          dapui.close {}
        end
        dap.listeners.before.event_exited['dapui_config'] = function()
          dapui.close {}
        end

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
            name = 'Attach - dotnet core',
            request = 'attach',
            processId = require('dap.utils').pick_process,
          },
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
  keys = {
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Breakpoint Condition',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Toggle Breakpoint',
    },
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = 'Continue',
    },
    {
      '<leader>dC',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Run to Cursor',
    },
    {
      '<leader>dg',
      function()
        require('dap').goto_()
      end,
      desc = 'Go to line (no execute)',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'Step Into',
    },
    {
      '<leader>dj',
      function()
        require('dap').down()
      end,
      desc = 'Down Stacktrace',
    },
    {
      '<leader>dk',
      function()
        require('dap').up()
      end,
      desc = 'Up Stacktrace',
    },
    {
      '<leader>dl',
      function()
        require('dap').run_last()
      end,
      desc = 'Run Last',
    },
    {
      '<leader>do',
      function()
        require('dap').step_out()
      end,
      desc = 'Step Out',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_over()
      end,
      desc = 'Step Over',
    },
    {
      '<leader>dp',
      function()
        require('dap').pause()
      end,
      desc = 'Pause',
    },
    {
      '<leader>dr',
      function()
        require('dap').repl.toggle()
      end,
      desc = 'Toggle REPL',
    },
    {
      '<leader>ds',
      function()
        require('dap').session()
      end,
      desc = 'Session',
    },
    {
      '<leader>dT',
      function()
        require('dap').disconnect { terminateDebuggee = false }
      end,
      desc = 'Disconnect',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = 'Terminate',
    },
    {
      '<leader>dw',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = 'Widgets',
    },
  },
  config = function()
    local dap = require 'dap'
    dap.set_log_level 'TRACE'
  end,
}
