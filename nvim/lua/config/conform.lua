-- lua/config/conform.lua
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    go = { "gofumpt" },
    rust = { "rustfmt" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
  },

  format_on_save = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    return ft ~= "markdown" -- Disable autosave formatting for markdown
  end,
})

