local vscode = require("vscode")

local function vscmd(cmd)
  return function()
    vscode.action(cmd)
  end
end

local function vscmds(cmds)
  return function()
    for _, c in ipairs(cmds) do
      pcall(vscode.action, c)
    end
  end
end

return {
  {
    "folke/which-key.nvim",

    config = function()
      print("key configured!")
      require("which-key").add({
        { "<C-k>", vscmd("workbench.action.previousEditor"), mode = "n", desc = "move to the previous buffer" },
        { "<C-j>", vscmd("workbench.action.nextEditor"), mode = "n", desc = "move to the next buffer" },

        { "]d", vscmd("editor.action.marker.next"), mode = "n", desc = "next Diagnostic" },
        { "[d", vscmd("editor.action.marker.prev"), mode = "n", desc = "prev Diagnostic" },

        {
          "[c",
          vscmds({
            "workbench.action.editor.previousChange",
            "workbench.action.compareEditor.previousChange"
          }),
          mode = "n",
          desc = "go to the previous change"
        },
        {
          "]c",
          vscmds({
            "workbench.action.editor.nextChange",
            "workbench.action.compareEditor.nextChange"
          }),
          mode = "n",
          desc = "go to the next change"
        },

        { "<leader>b", group = "+buffer" },

        { "<leader>bh", vscmd("workbench.action.previousEditor"), mode = "n", desc = "move to the previous buffer" },
        { "<leader>bl", vscmd("workbench.action.nextEditor"), mode = "n", desc = "move to the next buffer" },
        { "<leader>bd", vscmd("workbench.action.closeActiveEditor"), mode = "n", desc = "move to the next buffer" },
        { "<leader>bo", vscmd("workbench.action.closeOtherEditors"), mode = "n", desc = "close other buffers" },

        -- Debugging
        { "<leader>d", group = "+debug" },
        {
          "<leader>db",
          vscmd("editor.debug.action.toggleBreakpoint"),
          mode = "n",
          desc = "Toggle Breakpoint",
        },
        {
          "<leader>dB",
          vscmd("workbench.debug.viewlet.action.removeAllBreakpoints"),
          mode = "n",
          desc = "Remove All Breakpoints",
        }, -- NOTE: resolves conflict in favor of "remove all"
        {
          "<leader>da",
          vscmd("workbench.debug.viewlet.action.enableAllBreakpoints"),
          mode = "n",
          desc = "Enable All Breakpoints",
        },
        {
          "<leader>dA",
          vscmd("workbench.debug.viewlet.action.disableAllBreakpoints"),
          mode = "n",
          desc = "Disable All Breakpoints",
        },
        { "<leader>dc", vscmd("workbench.action.debug.continue"), mode = "n", desc = "Continue" },
        { "<leader>di", vscmd("workbench.action.debug.stepInto"), mode = "n", desc = "Step Into" },
        { "<leader>du", vscmd("workbench.action.debug.stepOut"), mode = "n", desc = "Step Out" },
        { "<leader>do", vscmd("workbench.action.debug.stepOver"), mode = "n", desc = "Step Over" },

        { "<leader>l", group = "+lsp" },

        { "<leader>la",  group = "+code actions" },
        { "<leader>laa", vscmd("editor.action.refactor"), mode = {"n", "v"}, desc = "code actions" },

        { "<leader>lr", group = "+refactor" },
        { "<leader>lrr", vscmd("editor.action.rename"), mode = {"n", "v"}, desc = "rename" },

        { "<leader>l=",  group = "+formatting" },
        { "<leader>l==", vscmd("editor.action.formatDocument"), mode = "n", desc = "format document" },
        { "<leader>l==", vscmd("editor.action.formatSelection"), mode = "v", desc = "format selection" },

        { "<leader>lg",  group = "+goto" },
        { "<leader>lgh", vscmd("references-view.showIncomingCalls"), mode = "n", desc = "show incoming call hierarchy" },
        { "<leader>lgo", vscmd("references-view.showOutgoingCalls"), mode = "n", desc = "show outgoing call hierarchy" },
        { "<leader>lgo", vscmd("workbench.action.showAllSymbols"), mode = "n", desc = "find all meaningful symbols" },
        { "<leader>lgt", vscmd("editor.action.goToTypeDefinition"), mode = "n", desc = "find type definitions" },
        { "<leader>lgr", vscmd("editor.action.goToReferences"), mode = "n", desc = "find references" },

        { "<leader>g", vscmd("workbench.scm.focus"), mode = "n", desc = "source control" },
        { "<leader>G", vscmd("magit.status"), mode = "n", desc = "magit status" },

        { "<leader>s", vscmd("workbench.action.terminal.toggleTerminal"), mode = "n", desc = "toggle shell" },

        { "<leader>t", vscmd("workbench.files.action.focusFilesExplorer"), mode = "n", desc = "source control" },

        { "<leader>f", group = "+file" },
        { "<leader>ff", vscmd("workbench.action.quickOpen"), mode = "n", desc = "go to file" },
        { "<leader>fF", vscmd("periscope.searchFiles"), mode = "n", desc = "go to file" },
        { "<leader>fg", vscmd("periscope.search"), mode = "n", desc = "live grep" },
        { "<leader>fG", vscmd("workbench.view.search.focus"), mode = "n", desc = "live grep" },

        { "<leader>x", group = "+problem" },
        { "<leader>xx", vscmd("workbench.action.problems.focus"), mode = "n", desc = "list problems" },

        { "<leader>;", vscmd("breadcrumbs.focusAndSelect"), mode = "n", desc = "pick symbols in breadcrumbs" },
      })
    end
  }
}
