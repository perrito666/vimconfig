-- lua/config/treesitter.lua
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua", "vim", "bash", "python", "go", "rust",
    "html", "css", "javascript", "typescript",
    "json", "yaml", "markdown"
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      node_decremental = "grm",
      scope_incremental = "grc",
    },
  },
})

