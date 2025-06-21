-- Entry point for new Neovim config using lazy.nvim
-- Structure: lua/plugins/, lua/config/

-- Entry point for new Neovim config using lazy.nvim
-- Structure: lua/plugins/, lua/config/

-- 1. Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- UI and Theme
  { "ribru17/bamboo.nvim", lazy = false, priority = 1000, config = function() require("bamboo").load() end },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("config.lualine") end },
  { "romgrk/barbar.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("config.barbar") end },

  -- LSP, Formatting, and Linting
  { "neovim/nvim-lspconfig", config = function() require("config.lsp") end },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", config = true },
{
  "stevearc/conform.nvim",
  opts = {},
},
{
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
},
  { "rcarriga/nvim-notify", config = function() require("config.notify") end },

  -- Autocompletion
  { "hrsh7th/nvim-cmp", config = function() require("config.cmp") end },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },
  { "saadparwaiz1/cmp_luasnip" },
  { "L3MON4D3/LuaSnip" },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function() require("config.treesitter") end },

  -- Telescope
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" }, config = function() require("config.telescope") end },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- Session Management
  { "rmagatti/auto-session", config = function() require("config.autosession") end },

  -- Misc
  { "folke/neoconf.nvim", lazy = true },
})

-- Global options
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"

-- Load Neovide customizations if needed
if vim.g.neovide then
  require("config.neovide")
end

vim.keymap.set("n", "<leader>un", function()
  require("notify").dismiss({ silent = true, pending = true })
end, { desc = "Dismiss all notifications" })

