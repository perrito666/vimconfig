require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format", "ruff_organize_imports", "ruff_fix" }, -- this is handled by ruff on the LSP
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
    if ft == "python" then
      return { lsp_format = "never", timeout_ms = 2000 }
    end
    if ft == "sh" or ft == "bash" or ft == "zsh" then
      return { timeout_ms = 1000, lsp_format = "never" }
    end
    return { timeout_ms = 1000, lsp_format = "never" }
  end,
})

-- Conform: Format
vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "use conform to format the current file" })
