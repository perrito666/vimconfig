-- Entry point for new Neovim config using lazy.nvim
-- Structure: lua/plugins/, lua/config/

-- ensure .vimrc does not interfere
vim.cmd("set runtimepath-=~/.vim")
vim.cmd("set runtimepath-=~/.vim/after")
vim.cmd("set runtimepath+=~/.config/nvim")

-- macOS-only: prepend Homebrew + Mason bins to PATH for Neovide/GUI sessions
do
  local is_macos = (vim.loop.os_uname().sysname == "Darwin")
    or (vim.fn.has("mac") == 1)
  if is_macos then
    local function exists(p)
      return p and p ~= "" and vim.loop.fs_stat(p) ~= nil
    end
    local function not_in_path(p)
      local PATH = vim.env.PATH or ""
      return not PATH:find("(^|:)" .. vim.pesc(p) .. "(:|$)")
    end
    local to_prepend = {}

    -- Apple Silicon Homebrew
    if exists("/opt/homebrew/bin") and not_in_path("/opt/homebrew/bin") then
      table.insert(to_prepend, "/opt/homebrew/bin")
    end
    -- Intel Homebrew (in case I find an older Mac)
    if exists("/usr/local/bin") and not_in_path("/usr/local/bin") then
      table.insert(to_prepend, "/usr/local/bin")
    end
    -- Mason bin (LSP servers installed by por mason)
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    if exists(mason_bin) and not_in_path(mason_bin) then
      table.insert(to_prepend, mason_bin)
    end

    if #to_prepend > 0 then
      vim.env.PATH = table.concat(to_prepend, ":")
        .. ":"
        .. (vim.env.PATH or "")
      vim.fn.setenv("PATH", vim.env.PATH) -- set for child processes
    end
  end
end

-- Ensure lazy.nvim is installed
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
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").load()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.lualine")
    end,
  },
  {
    "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.barbar")
    end,
  },

  -- File Explorer (nvim-tree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
        renderer = {
          icons = {
            show = {
              folder = true,
              file = true,
              folder_arrow = true,
            },
          },
        },
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        git = {
          enable = true,
        },
      })
    end,
  },

  -- fzf
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    config = function()
      require("config.fzf")
    end,
  },

  -- LSP, Formatting, and Linting

  {
    "rcarriga/nvim-notify",
    config = function()
      require("config.notify")
    end,
    lazy = false, -- this ensures that it is available for early messages
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("config.mason")
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("config.mason-lspconfig")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("config.lsp")
    end,
  },

  {
    "stevearc/conform.nvim",
    config = function()
      require("config.conform")
    end,
  },

  {
    "mfussenegger/nvim-lint",
    config = function()
      require("config.lint")
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.cmp")
    end,
  },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },
  { "saadparwaiz1/cmp_luasnip" },
  { "L3MON4D3/LuaSnip" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

  -- Git
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "ibhagwan/fzf-lua", -- optional
    },
  },

  -- Session Management
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    config = function()
      require("config.persistence")
    end,
  },
  -- version control
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.gitsigns") -- Load the configuration from gitsigns.lua
    end,
  },
  -- Misc
  { "folke/neoconf.nvim", lazy = true },
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("config.gitlinker")
    end,
    keys = {
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("n", {
            action_callback = require("gitlinker.actions").copy_to_clipboard,
          })
        end,
        desc = "GitLink: yank URL to clipboard",
      },
      {
        "<leader>go",
        function()
          require("gitlinker").get_buf_range_url("n", {
            action_callback = require("gitlinker.actions").open_in_browser,
          })
        end,
        desc = "GitLink: open in browser",
      },
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url("v", {
            action_callback = require("gitlinker.actions").copy_to_clipboard,
          })
        end,
        mode = "v",
        desc = "GitLink: yank URL (visual)",
      },
      {
        "<leader>go",
        function()
          require("gitlinker").get_buf_range_url("v", {
            action_callback = require("gitlinker.actions").open_in_browser,
          })
        end,
        mode = "v",
        desc = "GitLink: open URL (visual)",
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
})

-- Global options
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
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

-- Transparent background
local transparent_background = false
if transparent_background then
  vim.cmd("highlight Normal guibg=none")
  vim.cmd("highlight NonText guibg=none")
end

vim.keymap.set("n", "<leader>un", function()
  require("notify").dismiss({ silent = true, pending = true })
end, { desc = "Dismiss all notifications" })

-- Custom Commands
-- Conform: Format
vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "use conform to format the current file" })

-- Key mappings
vim.keymap.set("n", "tn", ":tabnext<CR>")
vim.keymap.set("n", "tp", ":tabprevious<CR>")

-- Key mappings for nvim-tree
vim.keymap.set("n", "<F3>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", ",t", ":NvimTreeFindFile<CR>")
vim.keymap.set("n", "<F4>", ":TagbarToggle<CR>")
vim.keymap.set("n", "<leader>b", ":Buffers<CR>")
vim.keymap.set("n", "<leader>ffg", function()
  vim.cmd("silent grep! " .. vim.fn.expand("<cword>") .. " .")
  vim.cmd("cwindow 20")
end)

-- Key mappings for persistence
--load the session for the current directory
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end)

-- select a session to load
vim.keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end)

-- load the last session
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end)

-- stop Persistence => session won't be saved on exit
vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end)

-- persist now => save whatever we are on now as the session
vim.keymap.set("n", "<leader>sS", function()
  persist.save()
end, { desc = "Session: save now" })

-- Tagbar settings
vim.g.tagbar_autofocus = 1
vim.g.tagbar_foldlevel = 1
vim.api.nvim_create_user_command(
  "MakeTags",
  "!ctags -R --exclude=.venv --exclude=.mypy* --exclude=.pip* --exclude=*.pyc --exclude=*.orig .",
  {}
)
vim.api.nvim_create_user_command(
  "LibTags",
  "!find `~/.nvim_vim/venv/bin/python -c 'import distutils; print(distutils.sysconfig.get_python_lib())'` -name \\*.py | ctags -L- --append",
  {}
)

-- Autocommands
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.tmux.conf", "tmux.conf*" },
  command = "setf tmux",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.nginx.conf", "nginx.conf*" },
  command = "setf nginx",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.gotmpl",
  command = "set filetype=gotexttmpl",
})

-- Load configuration for diagnostics
require("config.diagnostics")
