require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "ruff",
    "bashls",
    "jsonls",
    "yamlls",
    "gopls",
    "rust_analyzer",
  },
  automatic_installation = true, -- Mason should install the missing servers
})
