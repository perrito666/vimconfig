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
    "rmagatti/auto-session",
    config = function()
      require("config.autosession")
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

-- Python virtual environment management
local function setup_python_venv()
  local venv_path = os.getenv("VIRTUAL_ENV") -- Check if a virtualenv is already active
  local file_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file
  local project_venv = nil

  -- Search for a venv or .venv folder in the current file's directory or its parents
  while file_dir ~= "/" do
    if vim.fn.isdirectory(file_dir .. "/venv") == 1 then
      project_venv = file_dir .. "/venv"
      break
    elseif vim.fn.isdirectory(file_dir .. "/.venv") == 1 then
      project_venv = file_dir .. "/.venv"
      break
    end
    file_dir = vim.fn.fnamemodify(file_dir, ":h") -- Move up one directory
  end

  -- If no project venv is found, create a fallback venv in ~/.nvim_venv
  if not project_venv then
    project_venv = vim.fn.expand("~/.nvim_venv")
    if vim.fn.isdirectory(project_venv) == 0 then
      vim.fn.system({ "python3", "-m", "venv", project_venv })
    end
  end

  -- Activate the virtual environment
  vim.g.python3_host_prog = project_venv .. "/bin/python"
  vim.env.VIRTUAL_ENV = project_venv
  vim.env.PATH = project_venv .. "/bin:" .. vim.env.PATH

  -- Check if the environment is a `uv` environment
  local is_uv_env = vim.fn.executable("uv") == 1
  if is_uv_env then
    -- Use `uv pip` to install dependencies
    vim.fn.system({
      "uv",
      "pip",
      "install",
      "--upgrade",
      "pip",
      "setuptools",
      "wheel",
    })
    vim.fn.system({
      "uv",
      "pip",
      "install",
      "python-lsp-server",
      "pylint",
      "flake8",
      "isort",
    })
  else
    -- Use the standard `pip` for non-uv environments
    vim.fn.system({
      project_venv .. "/bin/pip",
      "install",
      "--upgrade",
      "pip",
      "setuptools",
      "wheel",
    })
    vim.fn.system({
      project_venv .. "/bin/pip",
      "install",
      "python-lsp-server",
      "pylint",
      "flake8",
      "isort",
    })
  end
end

-- Autocommand to set up Python virtual environment when editing Python files
--vim.api.nvim_create_autocmd("FileType", {
--  pattern = "python",
--  callback = setup_python_venv,
--})

-- Load configuration for diagnostics
require("config.diagnostics")
