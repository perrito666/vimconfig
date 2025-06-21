require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'bamboo',
    component_separators = { left = '', right = ''},
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = {}, winbar = {} },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', function() return vim.fn['tagbar#currenttag']("%s", '', 'f', 'nearest-stl') end},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
    },
    lualine_z = {
        {
            function()
                return " " .. os.date("%R")
            end,
            separator = { right = "" },
        },
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}