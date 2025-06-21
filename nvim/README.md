# 🚀 Neovim Config

This is a **modular, fast, and modern Neovim configuration**, tailored for:

- Python, Go, Rust development
- Web technologies (HTML, CSS, JS/TS, JSON, YAML)
- Excellent UX and performance
- Cross-platform (macOS/Linux)
- Neovide compatibility

---

## 🧰 Features

- ⚙️ **Plugin Manager**: [`lazy.nvim`](https://github.com/folke/lazy.nvim)
- 🎨 **Theme**: [bamboo.nvim](https://github.com/ribru17/bamboo.nvim)
- 🧠 **LSP Support**: `nvim-lspconfig`, `mason.nvim`
- 🧼 **Formatters & Linters**: `null-ls.nvim` (black, ruff, prettier, gofmt, rustfmt, etc.)
- 💬 **Autocompletion**: `nvim-cmp` + `LuaSnip`
- 🔍 **Fuzzy Finder**: `telescope.nvim` + `fzf-native`
- 🧾 **Bufferline**: `barbar.nvim`
- 📊 **Statusline**: `lualine.nvim`
- 🧠 **Treesitter**: fast and accurate syntax
- 🧪 **Auto sessions**: `auto-session`
- 🔔 **Notifications**: `nvim-notify`

---

## 📦 File Structure

```
~/.config/nvim/
├── init.lua
└── lua/
    └── config/
        ├── lsp.lua
        ├── cmp.lua
        ├── treesitter.lua
        ├── null-ls.lua
        ├── telescope.lua
        ├── lualine.lua
        ├── barbar.lua
        ├── autosession.lua
        ├── notify.lua
        └── neovide.lua
```

---

## ⌨️ Key Bindings

| Action              | Shortcut      |
|---------------------|---------------|
| Find files          | `<leader>ff`  |
| Live grep (args)    | `<leader>fg`  |
| Buffers             | `<leader>fb`  |
| Help tags           | `<leader>fh`  |
| Dismiss notifications | `<leader>un` |

---

## 🚀 Installation

```bash
git clone https://github.com/perrito666/vimconfig 
ln -s $(PWD)/vimconfig/nvim ~/.config/nvim
nvim
```

Plugins will install automatically on first launch.

---

## 🔧 Requirements

Make sure the following tools are installed:

```bash
brew install lua luarocks fd ripgrep fzf #TODO: Figure how to do this in linux
npm i -g prettier eslint_d markdownlint-cli
pip install black ruff
go install mvdan.cc/gofumpt@latest
```

---

## ✅ Recommended

- Terminal with truecolor support
- Neovide for GUI: [https://neovide.dev](https://neovide.dev)

---

## 📬 Feedback or Suggestions?

