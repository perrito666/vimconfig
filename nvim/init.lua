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

require("core.lazy")
require("core.options")
require("core.keymaps")
require("config.diagnostics")

-- Transparent background
local transparent_background = false
if transparent_background then
  vim.cmd("highlight Normal guibg=none")
  vim.cmd("highlight NonText guibg=none")
end

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
