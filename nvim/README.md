# Neovim Config (perrito666)

A coding oriented (I mostly do go, python and bash) for neovim that works
both on **Linux** and **macOS**. I use this on alacritty most of the time but also with **Neovide**.

This setup has evolved to remove Telescope in favor of **fzf-lua** for performance reasons (I write this here to remember in case I ever am tempted to go back)

I try to have:

* Fuzzy finding of files by name and grep (fzf-lua)[https://github.com/ibhagwan/fzf-lua]
* Git management (Neogit)[https://github.com/NeogitOrg/neogit].
* Git utils:
  * I use (gitlinker)[https://github.com/ruifm/gitlinker.nvim] to obtain links to the code in git
* Keymap cheatsheets (very important this is something I loved from helix editor) with (which-key)[https://github.com/folke/which-key.nvim]
* (Mason)[https://github.com/mason-org/mason.nvim] is used to manage LSPs, linters and formatters

---

## Requirements

- **Neovim** ≥ 0.11 (I use this compiled from source on Debian, trixie at the time of writting this, and brew installed on macOS 26)
- System packages and dependencies:
  - `fzf` which is a requirement of fzf-lua
  - `git`
  - `python3` (I use it with `uv` but I am unsure if any of the plugins know how to make use of
  - `go` 
  - `node` (at some point one of the plugins wanted npm

---

## Installation

### Clone and link

I use it this way.

```bash
git clone https://github.com/perrito666/vimconfig.git ~/code/vimconfig

# Backup any previous setup
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak.$(date +%Y%m%d-%H%M)

# Symlink this config
ln -s ~/code/vimconfig/nvim ~/.config/nvim
```

### Dependencies

The repo includes a helper script but they are likely incomplete so I recommend going by the list above

```bash
# macOS
bash ~/code/vimconfig/nvim/reqs.bash
```
---

## Structure

- `init.lua` — core loader and entry point
- `lua/config/` — modular configuration per feature:
  - `autosession.lua`: Save current session and recover on reopen 
  - `lsp.lua`: Configure the various LSPs
  - `gitlinker.lua`: Copy links to the current code on github
  - `mason.lua`: Install and maintain up to date LSPs, Linters and Formatters
  - `cmp.lua`: Auto complete, takes from snippets, buffers and lsps
  - `gitsigns.lua`: Add useful symbols for git status (And Blame :p)
  - `barbar.lua`: A nicer way to handle tabs with icons and other modern features.
  - `conform.lua`: Powerful formatter
  - `notify.lua`: Pretty (and useful) notifications
  - `options.lua`: General nvim options
  - `lint.lua`: Configure linters
  - `lualine.lua`: This might need some unification with LSP
  - `mason-lspconfig.lua`: Configure the installed LSPs
  - `fzf.lua`: Configure fuzzyfinder
  - `treesitter.lua`: Configure (nvim-treesitter)[https://github.com/nvim-treesitter/nvim-treesitter] for (parsing)[https://github.com/tree-sitter/tree-sitter]
  - `diagnostics.lua`: Configure diagnostics, mostly style (diagnostics are the error/problem and so on messages from editors mostly coming from LSPs)
- `.stylua.toml` — formatter rules for the lua files

---


## Keymaps

Leader key: **Space**

| Action | Mapping |
|---------|----------|
| Find files | `<leader>ff` |
| Live grep | `<leader>fg` |
| Buffers | `<leader>fb` |
| Toggle file tree| `<F3>` |

---

## License (if one must be defined)

MIT — see repository root.
