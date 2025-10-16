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
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- vim.print(client.name, client.server_capabilities)

    if not (client == nil) then
      if client.name == "ruff" then
        -- disable hover in favor of pyright
        client.server_capabilities.hoverProvider = false
      end
      -- Disable formatting except for python, we use conform
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    local function bufmap(mode, lhs, rhs, desc)
      vim.keymap.set(
        mode,
        lhs,
        rhs,
        { buffer = buf, noremap = true, silent = true, desc = desc }
      )
    end

    bufmap("n", "K", function()
      vim.lsp.buf.hover({ border = "rounded", max_height = 25 })
    end)
    bufmap("n", "<C-k>", vim.lsp.buf.signature_help)

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

local function detect_venv()
  local project_venv = os.getenv("VIRTUAL_ENV") -- Check if a virtualenv is already active
  if project_venv then
    local file_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file
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
  end
  if not project_venv then
    return
  end
  vim.g.python3_host_prog = project_venv .. "/bin/python"
  vim.env.VIRTUAL_ENV = project_venv
  vim.env.PATH = project_venv .. "/bin:" .. vim.env.PATH
end

detect_venv()

-- ===== Servers =====

-- Ruff (Python linter/formatter as LSP)
vim.lsp.config("ruff", {
  capabilities = capabilities,
})
vim.lsp.enable("ruff")

local new_capability = {
  -- this will remove some of the diagnostics that duplicates those from ruff, idea taken and adapted from
  -- here: https://github.com/astral-sh/ruff-lsp/issues/384#issuecomment-1989619482
  -- and in turn i took it from https://github.com/jdhao/nvim-config/blob/a8a1b929212c9d2a015a14215dd58d94bc7bdfe8/lua/config/lsp.lua#L32
  textDocument = {
    publishDiagnostics = {
      tagSupport = {
        valueSet = { 2 },
      },
    },
    hover = {
      contentFormat = { "plaintext" },
      dynamicRegistration = true,
    },
  },
}
local merged_capability =
  vim.tbl_deep_extend("force", capabilities, new_capability)
vim.lsp.config("basedpyright", {
  capabilities = merged_capability,
  settings = {
    pyright = {
      -- disable import sorting and use Ruff for this
      disableOrganizeImports = true,
      disableTaggedHints = false,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        typeCheckingMode = "standard",
        useLibraryCodeForTypes = true,
        -- we can this setting below to redefine some diagnostics
        diagnosticSeverityOverrides = {
          deprecateTypingAliases = false,
        },
        -- inlay hint settings are provided by pylance?
        inlayHints = {
          callArgumentNames = "partial",
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
        },
      },
    },
  },
})
vim.lsp.enable("basedpyright")

-- Go (gopls)
vim.lsp.config("gopls", {
  capabilities = capabilities,
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
