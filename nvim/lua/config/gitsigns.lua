require("gitsigns").setup({
    signs = {
        add = { text = "┃" },          -- Line added
        change = { text = "┃" },       -- Line modified
        delete = { text = "▁" },       -- Line deleted
        topdelete = { text = "‾" },    -- Top of a deleted block
        changedelete = { text = "≃" }, -- Modified and deleted lines
    },
    signcolumn = true, -- Enable Git signs in the sign column
    numhl = true, -- Disable line number highlighting
    linehl = false, -- Disable line highlighting
    word_diff = false, -- Disable word diff highlighting
    watch_gitdir = {
        interval = 3000, -- Refresh interval (in ms)
        follow_files = true,
    },
    attach_to_untracked = true, -- Show signs for untracked files
    current_line_blame = false, -- Show Git blame for the current line
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- Display blame at the end of the line
        delay = 1000, -- Delay before showing blame (in ms)
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6, -- Priority of Git signs
    update_debounce = 200, -- Debounce time for updates (in ms)
    status_formatter = nil, -- Use default status formatter
})

-- Function to toggle Git blame
local gitsigns = require("gitsigns")
vim.keymap.set("n", "<leader>gb", function()
    local blame_enabled = gitsigns.config.current_line_blame
    gitsigns.toggle_current_line_blame() -- Toggle blame
    if blame_enabled then
        print("Git blame disabled")
    else
        print("Git blame enabled")
    end
end, { noremap = true, silent = true, desc = "Toggle Git blame" })