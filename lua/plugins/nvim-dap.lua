return {
  "mfussenegger/nvim-dap",

  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
  },

  config = function ()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_ui_widgets = require("dap.ui.widgets")

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

    dap.adapters.lldb = {
      type = "executable",
      command = lldb_path,
      name = "lldb"
    }

    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "lldb",
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
      }
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
    dap.listeners.after.event_initialized["dapui_config"] = function ()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function ()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function ()
      dapui.close()
    end

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserDapConfig', {}),
      callback = function (ev)
        local whichkey = require("which-key")
        whichkey.register({
          d = {
            name = "Debug",

            R = { function () dap.run_to_cursor() end, "Run to Cursor" },
            E = { function () dapui.eval(vim.fn.input '[Expression] > ') end, "Evaluate Input" },
            C = { function () dap.set_breakpoint(vim.fn.input '[Condition] > ') end, "Conditional Breakpoint" },
            U = { function () dapui.toggle() end, "Toggle UI" },
            b = { function () dap.step_back() end, "Step Back" },
            c = { function () dap.continue() end, "Continue" },
            d = { function () dap.disconnect() end, "Disconnect" },
            e = { function () dapui.eval() end, "Evaluate" },
            g = { function () dap.session() end, "Get Session" },
            h = { function () dap_ui_widgets.hover() end, "Hover Variables" },
            S = { function () dap_ui_widgets.scopes() end, "Scopes" },
            i = { function () dap.step_into() end, "Step Into" },
            o = { function () dap.step_over() end, "Step Over" },
            p = { function () dap.pause.toggle() end, "Pause" },
            q = { function () dap.close() end, "Quit" },
            r = { function () dap.repl.toggle() end, "Toggle Repl" },
            s = { function () dap.continue() end, "Start" },
            t = { function () dap.toggle_breakpoint() end, "Toggle Breakpoint" },
            x = { function () dap.terminate() end, "Terminate" },
            u = { function () dap.step_out() end, "Step Out" },
          }
        }, {
          prefix = "<leader>",
          buffer = ev.buf
        })
      end
    })
  end
}
