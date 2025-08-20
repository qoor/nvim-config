return {
  "mfussenegger/nvim-dap",

  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
    "Joakker/lua-json5",
  },

  config = function ()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_ui_widgets = require("dap.ui.widgets")

    require("dap.ext.vscode").json_decode = require("json5").parse

    local lldb_path = "/usr/bin/lldb-vscode"
    if vim.fn.has("macunix") then
      local Job = require("plenary.job")

      Job:new({
        command = "which",
        args = {
          "lldb-vscode"
        },
        on_exit = function (j, return_val)
          if return_val == 0 then
            lldb_path = j:result()[1]
          end
        end
      }):sync()

    end

    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
    }

    dap.adapters.lldb = {
      type = "executable",
      command = lldb_path,
      name = "lldb"
    }

    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "cppdbg",
        request = "launch",
        program = function ()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        env = function ()
          local variables = {}
          for k, v in pairs(vim.fn.environ()) do
            table.insert(variables, string.format("%s=%s", k, v))
          end
          return variables
        end,
      },
      {
        name = 'Attach to gdbserver :7777',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:7777',
        miDebuggerPath = '/usr/bin/gdb',
        cwd = '${workspaceFolder}',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
      },
    }

    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp

    vim.tbl_deep_extend("force", dap.configurations.rust, {
      {
        initCommands = function ()
          local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

          local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
          local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

          local commands = {}
          local file = io.open(commands_file, "r")
          if file then
            for line in file:lines() do
              table.insert(commands, line)
            end
            file:close()
          end
          table.insert(commands, 1, script_import)

          return commands
        end
      }
    })

    dapui.setup()
    dap.listeners.before.attach.dapui_config = function ()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function ()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function ()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function ()
      dapui.close()
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserDapConfig', {}),
      callback = function (ev)
        local wk = require("which-key")
        wk.add({
            buffer = ev.buf,

          { "<leader>d", group = "+debug" },
          { "<leader>dR", function () dap.run_to_cursor() end, desc = "Run to Cursor" },
          { "<leader>dE", function () dapui.eval(vim.fn.input '[Expression] > ') end, desc = "Evaluate Input" },
          { "<leader>dC", function () dap.set_breakpoint(vim.fn.input '[Condition] > ') end, desc = "Conditional Breakpoint" },
          { "<leader>dU", function () dapui.toggle() end, desc = "Toggle UI" },
          { "<leader>db", function () dap.step_back() end, desc = "Step Back" },
          { "<leader>dc", function () dap.continue() end, desc = "Continue" },
          { "<leader>dd", function () dap.disconnect() end, desc = "Disconnect" },
          { "<leader>de", function () dapui.eval() end, desc = "Evaluate" },
          { "<leader>dg", function () dap.session() end, desc = "Get Session" },
          { "<leader>dh", function () dap_ui_widgets.hover() end, desc = "Hover Variables" },
          { "<leader>dS", function () dap_ui_widgets.scopes() end, desc = "Scopes" },
          { "<leader>di", function () dap.step_into() end, desc = "Step Into" },
          { "<leader>do", function () dap.step_over() end, desc = "Step Over" },
          { "<leader>dp", function () dap.pause.toggle() end, desc = "Pause" },
          { "<leader>dq", function () dap.close() end, desc = "Quit" },
          { "<leader>dr", function () dap.repl.toggle() end, desc = "Toggle Repl" },
          { "<leader>ds", function () dap.continue() end, desc = "Start" },
          { "<leader>dt", function () dap.toggle_breakpoint() end, desc = "Toggle Breakpoint" },
          { "<leader>dx", function () dap.terminate() end, desc = "Terminate" },
          { "<leader>du", function () dap.step_out() end, desc = "Step Out" },
        })
      end
    })
  end
}
