#!/usr/bin/env zsh
# =============================================================================
# Node setup: install Node via `n`, enable corepack, install global npm pkgs
# =============================================================================

# Shared helpers (guarantees brew + `n` are on PATH, even on the first run).
source "${0:A:h}/lib.zsh"

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed with `n` (installed by the core Brewfile).
# See zshenv for the N_PREFIX variable and its addition to the $path array.
if exists node; then
  echo "Node $(node --version) & NPM $(npm --version) already installed"
else
  echo "Installing Node & NPM with n..."
  n latest
fi

# Enable corepack for modern package manager support (yarn, pnpm shims).
echo "Enabling corepack..."
corepack enable

# --- Global npm packages (single source of truth; was split with Brewfile) -
echo "\n<<< Installing Global NPM Packages >>>\n"

global_packages=(
  @anthropic-ai/claude-code
  @mermaid-js/mermaid-cli
  @railway/cli
  firebase-tools
  pnpm
  tailwindcss
  trash-cli
  yarn
)

for pkg in "${global_packages[@]}"; do
  if npm list -g "$pkg" &>/dev/null; then
    echo "$pkg already installed, skipping"
  else
    echo "Installing $pkg..."
    npm i -g "$pkg"
  fi
done

echo "\nGlobal NPM Packages Installed:"
npm list -g --depth=0
