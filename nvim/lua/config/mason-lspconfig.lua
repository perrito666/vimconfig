require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "ts_ls",
    "bashls",
    "jsonls",
    "yamlls",
    "gopls",
    "rust_analyzer",
  },
  automatic_installation = true, -- Mason should install the missing servers
})
