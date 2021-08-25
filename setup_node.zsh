#!/usr/bin/env zsh

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed with `n`, which is in the Brewfile.
# See zshrc for N_PREFIX variable and addition to $path array.

if exists node; then
  echo "Node $(node --version) & $(npm --version) NPM already installed"
else 
  echo "Installing Node & NPM with n..."
  n lastest
fi

# Install Global NPM Pakcages

npm i -g firebase-tools
npm i -g trash-cli
npm i -g yarn

echo "Global NPM Packages Installed"
npm list -g --depth=0