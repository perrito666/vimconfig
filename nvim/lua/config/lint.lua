
local lint = require("lint")

lint.linters_by_ft = {
  python      = { "ruff" },
  javascript  = { "eslint_d" },
  typescript  = { "eslint_d" },
  sh          = { "shellcheck" },
  bash        = { "shellcheck" },
  zsh         = { "shellcheck" },
  yaml        = { "yamllint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("UserLinting", { clear = true }),
  callback = function(ev)
    require("lint").try_lint(nil, { bufnr = ev.buf })
  end,
})

vim.api.nvim_create_user_command("Lint", function()
  local ran = require("lint").try_lint()
  if not ran or #ran == 0 then
    vim.notify(("nvim-lint: no linters for '%s'"):format(vim.bo.filetype), vim.log.levels.WARN)
  end
end, {})

vim.keymap.set("n", "<leader>cl", "<cmd>Lint<cr>", { desc = "Run linters (nvim-lint)" })

