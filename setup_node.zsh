#!/usr/bin/env zsh

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed with `n`, which is in the Brewfile.
# See zshenv for N_PREFIX variable and addition to $path array.

if exists node; then
  echo "Node $(node --version) & NPM $(npm --version) already installed"
else
  echo "Installing Node & NPM with n..."
  n latest
fi

# Enable corepack for modern package manager support (yarn, pnpm)
echo "Enabling corepack..."
corepack enable

# Install Global NPM Packages (only if not already installed)
echo "\n<<< Installing Global NPM Packages >>>\n"

global_packages=(firebase-tools trash-cli)

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