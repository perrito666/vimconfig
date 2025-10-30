-- Global options
vim.g.mapleader = "\\"
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.winborder = "rounded"
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.encoding = "utf-8"
vim.opt.autoread = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.showcmd = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.opt.wildmode = { "list", "longest" }
vim.opt.scrolloff = 3
vim.opt.shell = "/bin/bash"
vim.opt.lazyredraw = true
vim.opt.fillchars:append("vert:|")
vim.opt.signcolumn = "yes:3"

-- Persistent undo
if vim.fn.has("persistent_undo") == 1 then
  vim.opt.undofile = true
  vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
end
