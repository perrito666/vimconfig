-- lua/config/persistence.lua
local persistence = require("persistence")

persistence.setup({
  dir = vim.fn.stdpath("state") .. "/sessions/", -- ~/.local/state/nvim/sessions
  options = {
    "buffers",
    "curdir",
    "tabpages",
    "winsize",
    "help",
    "globals",
    "localoptions",
    "folds",
    "terminal",
    "winpos",
    "options",
  },
  pre_save = function()
    -- Optional: close transient UIs so sessions stay clean
    pcall(function()
      require("neo-tree.command").execute({ action = "close" })
    end)
    -- Add similar lines here for Trouble, Undotree, etc. if needed
  end,
})

-- 🔄 Auto-save sessions on quit
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("PersistOnQuit", { clear = true }),
  callback = function()
    if vim.bo.filetype ~= "gitcommit" then
      persistence.save()
    end
  end,
})
