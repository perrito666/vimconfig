-- lua/config/lsp.lua
local lspconfig = require("lspconfig")

-- ===== Capabilities (autocompletion) =====
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
if ok_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- ===== Keymaps via LspAttach (reeplaces on_attach for mappings) =====
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
  callback = function(args)
    -- args.buf = bufnr, args.data.client_id
    local buf = args.buf

    local function bufmap(mode, lhs, rhs, desc)
      vim.keymap.set(
        mode,
        lhs,
        rhs,
        { buffer = buf, noremap = true, silent = true, desc = desc }
      )
    end

    bufmap("n", "gd", function()
      vim.lsp.buf.definition()
    end, "Goto Definition")
    bufmap("n", "K", function()
      vim.lsp.buf.hover()
    end, "Hover")
    bufmap("n", "gr", function()
      vim.lsp.buf.references()
    end, "References")
    bufmap("n", "<leader>rn", function()
      vim.lsp.buf.rename()
    end, "Rename")
  end,
})

-- ===== Helper: disable lsp formatting, (Conform rules here) =====
local function disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

-- Wrapper on_attach only for server tweaks
local function server_on_attach(client, bufnr) -- luacheck: ignore 212
  -- Disable formatting where Conform is used (black, gofumpt, rustfmt, stylua)
  disable_formatting(client)
end

-- ===== Servers =====

-- Python (pyright)
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = server_on_attach,
})

-- Go (gopls)
lspconfig.gopls.setup({
  capabilities = capabilities,
  on_attach = server_on_attach,
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

-- Rust (rust_analyzer)
lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = server_on_attach,
})

-- Lua (nvim config, I have not the slightest idea about lua)
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_attach = server_on_attach,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
    },
  },
})
