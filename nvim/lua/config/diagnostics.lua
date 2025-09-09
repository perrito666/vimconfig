-- ================= Diagnostics Enhancements ===================

-- Customize diagnostic signs
local signs = { Error = "✗", Warn = "⚠", Hint = "➤", Info = "ℹ" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Keymaps to view diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Show diagnostics in a floating window" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true, desc = "Show diagnostics in the location list" })
vim.diagnostic.config({
    virtual_text = {
        prefix = "💩", -- Change the prefix to something meaningful (e.g., "●", ">>", etc.)
        spacing = 2,  -- Add spacing between the text and the diagnostic
    },
    signs = false, -- Enable diagnostic signs in the sign column
    underline = true, -- Underline the problematic code
    update_in_insert = false, -- Update diagnostics only in Normal mode
    severity_sort = true, -- Sort diagnostics by severity
})

-- Customize diagnostic sign colors
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#00c3ff" }) -- Green for Hint
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#FF0000" }) -- Red for Error
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#FFFF00" }) -- Yellow for Warning
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#0000FF" }) -- Blue for Info

vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "Comment" }) -- Dim unnecessary code like comments
vim.api.nvim_set_hl(0, "DiagnosticDeprecated", { link = "Error" }) -- Highlight deprecated code as errors