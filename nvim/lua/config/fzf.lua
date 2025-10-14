-- lua/config/fzf.lua
local fzf = require("fzf-lua")

fzf.setup({
  -- Some shallow visual tricks
  winopts = {
    border = "rounded",
  },
  -- oldfiles defaults
  oldfiles = {
    cwd_only = true,
    stat_file = true,
  },
})

-- Replace vim.ui.select with fzf-lua (once setup is done)
fzf.register_ui_select()

-- Keymaps
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

map("n", "<leader>ff", function()
  fzf.files()
end, "Find files (fzf-lua)")
map("n", "<leader>fg", function()
  fzf.live_grep()
end, "Live grep (fzf-lua)")
map("n", "<leader>fr", function()
  fzf.oldfiles()
end, "Recent files (fzf-lua)")
map("n", "<leader>fb", function()
  fzf.buffers()
end, "Buffers (fzf-lua)")
map("n", "<leader>fh", function()
  fzf.help_tags()
end, "Help tags (fzf-lua)")
