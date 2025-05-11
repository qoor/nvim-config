return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  keys = {
    { "<leader>q", group = "+session" },
    -- load the session for the current directory
    { "<leader>qq", function () require("persistence").load() end, desc = "load session" },
    -- select a session to load
    { "<leader>qs", function () require("persistence").select() end, desc = "select session" },
    -- load the last session
    { "<leader>ql", function () require("persistence").load({ last = true }) end, desc = "load last session" },
    -- stop Persistence => session won't be saved on exit
    { "<leader>qd", function () require("persistence").stop() end, desc = "do not save on exit" },
  },
  opts = {}
}
