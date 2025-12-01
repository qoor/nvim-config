--- Return running processes as a list with { pid, name } tables.
---
--- Takes an optional `opts` table with the following options:
---
--- - filter string|fun: A lua pattern or function to filter the processes.
---                      If a function the parameter is a table with
---                      {pid: integer, name: string}
---                      and it must return a boolean.
---                      Matches are included.
---
--- <pre>
--- require("dap.utils").pick_process({ filter = "sway" })
--- </pre>
---
--- <pre>
--- require("dap.utils").pick_process({
---   filter = function(proc) return vim.endswith(proc.name, "sway") end
--- })
--- </pre>
---
---@param opts? {filter: string|(fun(proc: dap.utils.Proc): boolean)}
---
---@return dap.utils.Proc[]
local function get_processes(prefix, opts)
  opts = opts or {}
  local is_windows = vim.fn.has('win32') == 1
  local separator = is_windows and ',' or ' \\+'
  local user
  if prefix then
    user = vim.fn.trim(vim.fn.system({'id', '-un'}))
  else
    user = os.getenv("USER")
  end
  local command = is_windows and {'tasklist', '/nh', '/fo', 'csv'} or {'ps', 'ah', '-U', user}

  local full_command
  if prefix then
    full_command = prefix
    table.insert(full_command, table.concat(command, " "))
  else
    full_command = command
  end

  -- output format for `tasklist /nh /fo` csv
  --    '"smss.exe","600","Services","0","1,036 K"'
  -- output format for `ps ah`
  --    " 107021 pts/4    Ss     0:00 /bin/zsh <args>"
  local get_pid = function (parts)
    if is_windows then
      return vim.fn.trim(parts[2], '"')
    else
      return parts[1]
    end
  end

  local get_process_name = function (parts)
    if is_windows then
      return vim.fn.trim(parts[1], '"')
    else
      return table.concat({unpack(parts, 5)}, ' ')
    end
  end

  local output = vim.fn.system(full_command)
  local lines = vim.split(output, '\n')
  local procs = {}

  local nvim_pid = vim.fn.getpid()
  for _, line in pairs(lines) do
    if line ~= "" then -- tasklist command outputs additional empty line in the end
      local parts = vim.fn.split(vim.fn.trim(line), separator)
      local pid, name = get_pid(parts), get_process_name(parts)
      pid = tonumber(pid)
      if pid and pid ~= nvim_pid then
        table.insert(procs, { pid = pid, name = name })
      end
    end
  end

  if opts.filter then
    local filter
    if type(opts.filter) == "string" then
      filter = function(proc)
        return proc.name:find(opts.filter)
      end
    elseif type(opts.filter) == "function" then
      filter = function(proc)
        return opts.filter(proc)
      end
    else
      error("opts.filter must be a string or a function")
    end
    procs = vim.tbl_filter(filter, procs)
  end

  return procs
end

local function pick_remote_process(config)
  local prefix = {unpack(config.pipeTransport.pipeArgs)}
  table.insert(prefix, 1, config.pipeTransport.pipeProgram)

  local label_fn = function(proc)
    return string.format("id=%d name=%s", proc.pid, proc.name)
  end

  local co = coroutine.running()
  if co then
    return coroutine.create(function()
      local procs = get_processes(prefix)
      require('dap.ui').pick_one(procs, "Select remote process", label_fn, function(choice)
        coroutine.resume(co, choice and choice.pid or nil)
      end)
    end)
  else
    local procs = get_processes(prefix)
    local result = require('dap.ui').pick_one_sync(procs, "Select remote process", label_fn)
    return result and result.pid or nil
   end
end

local function telescope_pick_process(config)
  return coroutine.create(function(coro)
    ----------------------------------------------------------------
    -- 1) prefix 결정 (config.pipeTransport 기반)
    ----------------------------------------------------------------
    local prefix = nil

    if config.pipeTransport and config.pipeTransport.pipeProgram
    then
      local pt = config.pipeTransport
      if type(pt.pipeArgs) == "table" then
        prefix = { unpack(pt.pipeArgs) }
      else
        prefix = {}
      end
      -- 예: { "ssh", "user@vm-host", ... }
      table.insert(prefix, 1, pt.pipeProgram)
    end

    ----------------------------------------------------------------
    -- 2) 프로세스 목록 취득 (필터 없음)
    ----------------------------------------------------------------
    local ok, procs = pcall(get_processes, prefix, {})
    if not ok then
      vim.notify("get_processes failed: " .. tostring(procs), vim.log.levels.ERROR)
      coroutine.resume(coro, nil)
      return
    end

    if #procs == 0 then
      vim.notify("no processes found", vim.log.levels.WARN)
      coroutine.resume(coro, nil)
      return
    end

    ----------------------------------------------------------------
    -- 3) Telescope picker
    ----------------------------------------------------------------
    local pickers      = require("telescope.pickers")
    local finders      = require("telescope.finders")
    local conf         = require("telescope.config").values
    local actions      = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local entries = {}
    for _, p in ipairs(procs) do
      table.insert(entries, {
        pid  = p.pid,
        name = p.name,
        line = string.format("id=%d    name=%s", p.pid, p.name),
      })
    end

    local t_opts = {}

    pickers.new(t_opts, {
      prompt_title = "Pick process"
        .. (prefix and " (remote)" or " (local)"),
      finder = finders.new_table {
        results = entries,
        entry_maker = function(e)
          return {
            value   = e,
            display = e.line,
            ordinal = e.line,
          }
        end,
      },
      sorter = conf.generic_sorter(t_opts),
      attach_mappings = function(bufnr, _)
        actions.select_default:replace(function()
          actions.close(bufnr)
          local selection = action_state.get_selected_entry()
          if not selection or not selection.value then
            coroutine.resume(coro, nil)
            return
          end
          coroutine.resume(coro, selection.value.pid)
        end)
        return true
      end,
    }):find()
  end)
end

return {
  {
    "folke/trouble.nvim",
    dependencies = {
      "folke/which-key.nvim",
    },
    cmd = { "Trouble" },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    init = function()
      require("which-key").add({
        { "<leader>x", group = "+problem" },
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "show problems" },
        { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "show current buffer problems" },
        { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "show problem symbols" },
        { "<leader>xw", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "show workspace problems" },
        { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "show location list" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "show quickfix list" },
      })
    end,
  },

  {
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

      dap.listeners.on_config["user"] = function(config)
        if type(config.processId) == "string" and config.processId:match("pickRemoteProcess") then
          config.processId = function()
            -- return pick_remote_process(config)
            return telescope_pick_process(config)
          end
        end
        return config
      end

      vim.fn.sign_define("DapBreakpoint", { text = "•", texthl = "DapBreakpoint", linehl = "", numhl = "" })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserDapConfig', {}),
        callback = function (ev)
          require("which-key").add({
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
}
