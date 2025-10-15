require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff" }, -- this is handled by ruff
    javascript = { "prettier" },
    typescript = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    go = { "gofumpt" },
    rust = { "rustfmt" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
  },

  formatters = {
    shfmt = { prepend_args = { "-i", "2", "-ci", "-bn" } },
  },

  format_on_save = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    if ft == "markdown" then
      return false
    end
    if ft == "sh" or ft == "bash" or ft == "zsh" then
      return { timeout_ms = 1000, lsp_format = "never" }
    end
    return { timeout_ms = 1000, lsp_format = "never" }
  end,
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "never" })
end, { desc = "Format buffer (Conform)" })
