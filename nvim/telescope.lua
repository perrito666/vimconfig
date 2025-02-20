local telescope = require("telescope")
local lga_actions = require("telescope-live-grep-args.actions")

local defaults = {
    layout_strategy = "vertical",
    preview_title = "",
    dynamic_preview_title = false,

    layout_config = {
        prompt_position = "top",
        mirror = true,
        preview_height = 0.55,
        height = 0.95,
        width = 0.75,
    },

    sort_mru = true,
    sorting_strategy = "ascending",
    border = true,
    multi_icon = "",
    entry_prefix = "   ",
    prompt_prefix = "   ",
    selection_caret = "  ",
    hl_result_eol = true,
    results_title = "",
    winblend = 0,
    wrap_results = true,
    mappings = {
        i = {
            ["<Esc>"] = require("telescope.actions").close,
            ["<C-Esc>"] = require("telescope.actions").close,
        },
    },

    -- BUG: This causes too many issues.
    preview = { treesitter = false },
}

telescope.setup({
    defaults = defaults,
    extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              -- freeze the current list and start a fuzzy search in the frozen list
              ["<C-j>"] = lga_actions.to_fuzzy_refine,
            },
          },
           }
    },
    pickers = {
        diagnostics = { sort_by = "severity", preview_title = "" },
        live_grep = { preview_title = "", mappings = { -- extend mappings
                i = {
                  ["<C-k>"] = lga_actions.quote_prompt(),
                  ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                  -- freeze the current list and start a fuzzy search in the frozen list
                  ["<C-j>"] = lga_actions.to_fuzzy_refine,
                },
            } 
        },
        help_tags = {
            preview_title = "",
            mappings = { i = { ["<CR>"] = require("telescope.actions").select_vertical } },
        },
        oldfiles = { preview_title = "" },
        find_files = { preview_title = "" },
        lsp_document_symbols = { preview_title = "" },
        man_pages = {
            preview_title = "",
            mappings = { i = { ["<CR>"] = require("telescope.actions").select_vertical } },
        },
    },
})

vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function() vim.opt_local.number = true end,
})


-- don't forget to load the extension
telescope.load_extension("live_grep_args")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
--vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set("n", "<leader>fg", require('telescope').extensions.live_grep_args.live_grep_args)
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
