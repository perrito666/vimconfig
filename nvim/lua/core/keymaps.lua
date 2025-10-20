-- Key mappings
vim.keymap.set("n", "tn", ":tabnext<CR>")
vim.keymap.set("n", "tp", ":tabprevious<CR>")

-- Key mappings for nvim-tree
vim.keymap.set("n", "<F3>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", ",t", ":NvimTreeFindFile<CR>")

-- Key mappings for persistence
--load the session for the current directory
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end)

-- select a session to load
vim.keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end)

-- load the last session
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end)

-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end)

-- persist now => save whatever we are on now as the session
vim.keymap.set("n", "<leader>sS", function()
  require("persistence").save()
end, { desc = "Session: save now" })

-- GitLinker
vim.keymap.set("n", "<leader>gy", function()
  require("gitlinker").get_buf_range_url("n", {
    action_callback = require("gitlinker.actions").copy_to_clipboard,
  })
end, {
  desc = "GitLink: yank URL to clipboard",
})
vim.keymap.set("n", "<leader>go", function()
  require("gitlinker").get_buf_range_url("n", {
    action_callback = require("gitlinker.actions").open_in_browser,
  })
end, {
  desc = "GitLink: open in browser",
})
vim.keymap.set("v", "<leader>gy", function()
  require("gitlinker").get_buf_range_url("v", {
    action_callback = require("gitlinker.actions").copy_to_clipboard,
  })
end, {
  desc = "GitLink: yank URL (visual)",
})

vim.keymap.set("v", "<leader>go", function()
  require("gitlinker").get_buf_range_url("v", {
    action_callback = require("gitlinker.actions").open_in_browser,
  })
end, {
  desc = "GitLink: open URL (visual)",
})

-- Which keym
vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, {
  desc = "Buffer Local Keymaps (which-key)",
})

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", {
  desc = "Diagnostics (Trouble)",
})
vim.keymap.set(
  "n",
  "<leader>xX",
  "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  {
    desc = "Buffer Diagnostics (Trouble)",
  }
)
vim.keymap.set(
  "n",
  "<leader>cs",
  "<cmd>Trouble symbols toggle focus=false<cr>",
  {
    desc = "Symbols (Trouble)",
  }
)
vim.keymap.set(
  "n",
  "<leader>cl",
  "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  {
    desc = "LSP Definitions / references / ... (Trouble)",
  }
)
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", {
  desc = "Location List (Trouble)",
})
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", {
  desc = "Quickfix List (Trouble)",
})
-- LSP Quickfix
vim.keymap.set("n", "<leader>ci", function()
  -- Prefer quickfix actions (where gopls puts “Add import …”)
  local ok = pcall(vim.lsp.buf.code_action, {
    apply = true, -- Neovim ≥ 0.10 applies if only one action
    context = { only = { "quickfix" } },
  })
  if not ok then
    -- Fallback for older Neovim: just open the code action menu
    vim.lsp.buf.code_action({ context = { only = { "quickfix" } } })
  end
end, { desc = "LSP: import/fix at cursor (Go)" })
-- Notify
vim.keymap.set("n", "<leader>un", function()
  require("notify").dismiss({ silent = true, pending = true })
end, { desc = "Dismiss all notifications" })
-- Conform
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "never" })
end, { desc = "Format buffer (Conform)" })
