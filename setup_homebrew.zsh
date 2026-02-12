#!/usr/bin/env zsh

echo "\n<<< Starting Homebrew Setup >>>\n"

if exists brew; then
  echo "Brew exists, skipping install"
else
  echo "Brew doesn't exist, continuing with install"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> "$HOME/.zprofile"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "\n<<< Starting TMUX Plugin Manager >>>\n"

if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "TPM already installed, skipping"
else
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

brew bundle --verbose
