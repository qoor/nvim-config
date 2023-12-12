
return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  dependencies = {
    "dracula.nvim",
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  config = function()
    local colors = require("dracula").colors()

    require("barbecue").setup {
      -- configurations go here
      theme = {
        -- this highlight is used to override other highlights
        -- you can take advantage of its `bg` and set a background throughout your winbar
        -- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
        normal = { fg = colors.comment },

        basename = { bold = false },

        -- these highlights are used for context/navic icons
        context_file = { fg = "#ffffff" },
        context_module = { fg = "#ffffff" },
        --context_namespace = { fg = "#ac8fe4" },
        context_package = { fg = "#ffffff" },
        context_class = { fg = "#ee9d28" },
        context_method = { fg = "#b180d7" },
        context_property = { fg = "#ffffff" },
        context_field = { fg = "#75beff" },
        context_constructor = { fg = "#b180d7" },
        context_enum = { fg = "#ee9d28" },
        context_interface = { fg = "#75beff" },
        context_function = { fg = "#b180d7" },
        context_variable = { fg = "#75beff" },
        context_constant = { fg = "#ffffff" },
        context_string = { fg = "#ffffff" },
        context_number = { fg = "#ffffff" },
        context_boolean = { fg = "#ffffff" },
        context_array = { fg = "#ffffff" },
        context_object = { fg = "#ffffff" },
        context_key = { fg = "#ffffff" },
        --context_null = { fg = "#ac8fe4" },
        context_enum_member = { fg = "#75beff" },
        context_struct = { fg = "#ac8fe4" },
        context_event = { fg = "#ee9d28" },
        context_operator = { fg = "#ffffff" },
        context_type_parameter = { fg = "#ffffff" },
      },
      exclude_filetypes = { "toggleterm" }
    }
  end
}
