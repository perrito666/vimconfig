#!/usr/bin/env bash
# install-shell-tools.sh
# Installs: fzf, zoxide, bat, eza, zsh-autosuggestions, zsh-syntax-highlighting
# Supports: macOS (Homebrew) and Debian/Ubuntu Linux

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok() { echo -e "${GREEN}✓ $*${NC}"; }
info() { echo -e "${YELLOW}→ $*${NC}"; }

# ── Detect OS ────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
	OS="macos"
elif [[ -f /etc/debian_version ]]; then
	OS="debian"
else
	echo "Unsupported OS. This script supports macOS and Debian/Ubuntu."
	exit 1
fi

info "Detected OS: $OS"

# ── macOS ────────────────────────────────────────────────────────────────────
if [[ "$OS" == "macos" ]]; then
	if ! command -v brew &>/dev/null; then
		echo "Homebrew not found. Install it first: https://brew.sh"
		exit 1
	fi

	info "Installing tools via Homebrew..."
	brew install \
		fzf \
		zoxide \
		bat \
		eza \
		zsh-autosuggestions \
		zsh-syntax-highlighting

	ok "All tools installed."
fi

# ── Debian / Ubuntu ──────────────────────────────────────────────────────────
if [[ "$OS" == "debian" ]]; then
	info "Updating apt..."
	sudo apt-get update -qq

	# fzf
	info "Installing fzf..."
	sudo apt-get install -y fzf
	ok "fzf installed."

	# bat (Ubuntu names the binary 'batcat' to avoid a name conflict)
	info "Installing bat..."
	sudo apt-get install -y bat
	# Create a 'bat' alias shim if only 'batcat' exists
	if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
		mkdir -p "$HOME/.local/bin"
		ln -sf "$(which batcat)" "$HOME/.local/bin/bat"
		ok "bat installed (symlinked from batcat → ~/.local/bin/bat)."
	else
		ok "bat installed."
	fi

	# eza – available in Ubuntu 23.04+; fall back to cargo otherwise
	info "Installing eza..."
	if apt-cache show eza &>/dev/null 2>&1; then
		sudo apt-get install -y eza
		ok "eza installed via apt."
	elif command -v cargo &>/dev/null; then
		cargo install eza
		ok "eza installed via cargo."
	else
		echo "⚠ eza not available via apt and cargo not found. Install Rust first:"
		echo "  curl https://sh.rustup.rs -sSf | sh"
		echo "  Then re-run this script."
	fi

	# zoxide
	info "Installing zoxide..."
	if apt-cache show zoxide &>/dev/null 2>&1; then
		sudo apt-get install -y zoxide
		ok "zoxide installed via apt."
	else
		# Official installer, puts binary in ~/.local/bin
		curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
		ok "zoxide installed via official installer."
	fi

	# zsh-autosuggestions
	info "Installing zsh-autosuggestions..."
	if apt-cache show zsh-autosuggestions &>/dev/null 2>&1; then
		sudo apt-get install -y zsh-autosuggestions
		ok "zsh-autosuggestions installed via apt."
	else
		mkdir -p "$HOME/.zsh"
		if [[ -d "$HOME/.zsh/zsh-autosuggestions" ]]; then
			git -C "$HOME/.zsh/zsh-autosuggestions" pull --quiet
		else
			git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
				"$HOME/.zsh/zsh-autosuggestions"
		fi
		ok "zsh-autosuggestions installed to ~/.zsh/zsh-autosuggestions."
	fi

	# zsh-syntax-highlighting
	info "Installing zsh-syntax-highlighting..."
	if apt-cache show zsh-syntax-highlighting &>/dev/null 2>&1; then
		sudo apt-get install -y zsh-syntax-highlighting
		ok "zsh-syntax-highlighting installed via apt."
	else
		mkdir -p "$HOME/.zsh"
		if [[ -d "$HOME/.zsh/zsh-syntax-highlighting" ]]; then
			git -C "$HOME/.zsh/zsh-syntax-highlighting" pull --quiet
		else
			git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
				"$HOME/.zsh/zsh-syntax-highlighting"
		fi
		ok "zsh-syntax-highlighting installed to ~/.zsh/zsh-syntax-highlighting."
	fi
fi

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
ok "All done! Reload your shell:"
echo "  source ~/.zshrc"
