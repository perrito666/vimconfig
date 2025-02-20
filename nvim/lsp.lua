require('lspconfig').ruff.setup({
    on_attach = function(client, bufnr)
        -- Organize imports via code action on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                vim.lsp.buf.code_action { context = { only = { "source.organizeImports" } }, apply = true }
            end,
            buffer = bufnr,
        })
    end,
})
---- rcarriga/nvim-notify
local notify = require 'notify'

notify.setup {
    render = 'default',
    stages = 'slide',
    on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 500 })
    end,
}

local ignored_messages = {
    'warning: multiple different client offset_encodings detected for buffer, this is not supported yet',
    'No code actions available',
}

vim.notify = function(msg, lvl, opts)
    lvl = lvl or vim.log.levels.INFO
    if vim.tbl_contains(ignored_messages, msg) then
        return
    end
    local lvls = vim.log.levels
    local keep = function()
        return true
    end
    local _opts = ({
        [lvls.TRACE] = { timeout = 500 },
        [lvls.DEBUG] = { timeout = 500 },
        [lvls.INFO] = { timeout = 1000 },
        [lvls.WARN] = { timeout = 10000 },
        [lvls.ERROR] = { timeout = 10000, keep = keep },
    })[lvl]
    opts = vim.tbl_extend('force', _opts or {}, opts or {})
    return notify.notify(msg, lvl, opts)
end

-- lua
require 'lspconfig'.lua_ls.setup {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc')) then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end,
    settings = {
        Lua = {}
    }
}

-- go
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
})
