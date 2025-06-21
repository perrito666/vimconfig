-- lua/config/barbar.lua
vim.g.barbar_auto_setup = false

require("barbar").setup({
  animation = true,
  auto_hide = false,
  tabpages = true,
  clickable = true,
  focus_on_close = "left",
  hide = { extensions = true, inactive = true },
  highlight_alternate = false,
  highlight_inactive_file_icons = false,
  highlight_visible = true,
  icons = {
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "ﬀ" },
      [vim.diagnostic.severity.HINT] = { enabled = true },
    },
    gitsigns = {
      added = { enabled = true, icon = "+" },
      changed = { enabled = true, icon = "~" },
      deleted = { enabled = true, icon = "-" },
    },
    filetype = { enabled = true },
    modified = { button = "●" },
    pinned = { button = "", filename = true },
    separator = { left = "▎", right = "" },
    preset = "default",
  },
  insert_at_end = false,
  maximum_length = 30,
  semantic_letters = true,
  sidebar_filetypes = {
    NvimTree = true,
    ["neo-tree"] = { event = "BufWipeout" },
    Outline = { event = "BufWinLeave", text = "symbols-outline", align = "right" },
  },
  letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
})

