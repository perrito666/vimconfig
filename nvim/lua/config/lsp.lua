-- lua/config/lsp.lua

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

-- Ruff (Python linter/formatter as LSP)
vim.lsp.config("ruff", {
  capabilities = capabilities,
})

-- Prefer Ruff on save for formatting python, just in case
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("RuffFormatOnSave", { clear = true }),
  pattern = "*.py",
  callback = function(args)
    vim.lsp.buf.format({
      bufnr = args.buf,
      async = false,
      timeout_ms = 1000,
      filter = function(client)
        return client.name == "ruff"
      end,
    })
  end,
})

-- Go (gopls)
vim.lsp.config("gopls", {
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
vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  on_attach = server_on_attach,
})

-- Lua (nvim config, I have not the slightest idea about lua)
vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (
          vim.uv.fs_stat(path .. "/.luarc.json")
          or vim.uv.fs_stat(path .. "/.luarc.jsonc")
        )
      then
        return
      end
    end

    client.config.settings.Lua =
      vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using (most
          -- likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Tell the language server how to find Lua modules same way as Neovim
          -- (see `:h lua-module-load`)
          path = {
            "lua/?.lua",
            "lua/?/init.lua",
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            -- Depending on the usage, you might want to add additional paths
            -- here.
            -- '${3rd}/luv/library'
            -- '${3rd}/busted/library'
          },
          -- Or pull in all of 'runtimepath'.
          -- NOTE: this is a lot slower and will cause issues when working on
          -- your own configuration.
          -- See https://github.com/neovim/nvim-lspconfig/issues/3189
          -- library = {
          --   vim.api.nvim_get_runtime_file('', true),
          -- }
        },
      })
  end,
  settings = {
    Lua = {},
  },
})
