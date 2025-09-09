vim.g.mapleader = " "

-- Check if 'pylsp' is executable
if vim.fn.executable("pylsp") == 1 then
    require("lspconfig").pylsp.setup({
        cmd = { vim.g.python3_host_prog, "-m", "pylsp" },
        filetypes = { "python" },
        settings = {
            pylsp = {
                plugins = {
                    pylint = { enabled = true },
                    flake8 = { enabled = true },
                    isort = { enabled = true },
                },
            },
        },
    })
end



-- Function to configure LSP buffer settings
local function on_lsp_buffer_enabled()
    vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
    vim.wo.signcolumn = 'yes'
    if vim.fn.exists('+tagfunc') == 1 then
        vim.bo.tagfunc = 'v:lua.vim.lsp.tagfunc'
    end

    local bufopts = { noremap = true, silent = true, buffer = 0 }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.document_symbol, bufopts)
    vim.keymap.set('n', 'gS', vim.lsp.buf.workspace_symbol, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-f>', function() vim.lsp.util.scroll(4) end, bufopts)
    vim.keymap.set('n', '<C-d>', function() vim.lsp.util.scroll(-4) end, bufopts)

    vim.g.lsp_format_sync_timeout = 1000
end

-- Autocommand group for LSP setup
vim.api.nvim_create_augroup("lsp_install", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lsp_install",
    pattern = "lsp_buffer_enabled",
    callback = on_lsp_buffer_enabled,
})

-- Remove trailing whitespace on save for Python files
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    command = [[%s/\s\+$//e]],
})

-- ================= NeoMake ===================
-- Run linter on write
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    command = "Neomake",
})

-- Configure Neomake for Python
vim.g.neomake_python_python_maker = require('neomake.makers.ft.python').python()
vim.g.neomake_python_flake8_maker = require('neomake.makers.ft.python').flake8()
vim.g.neomake_python_python_maker.exe = 'python3 -m py_compile'
vim.g.neomake_python_flake8_maker.exe = 'python3 -m flake8'

-- Disable virtual text for current errors
vim.g.neomake_virtualtext_current_error = 0

-- Add Python breakpoints
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.keymap.set('n', '<leader>b', 'Oimport ipdb; ipdb.set_trace()<esc>', { noremap = true, silent = true, buffer = 0 })
    end,
})

