# =============================================================================
# Brewfile - the full list of everything you might install
# =============================================================================
# This is just a flat menu. You do NOT manage groups here. At install time,
# setup_homebrew.zsh shows a checklist of every entry (pre-checked) and you
# untick whatever you don't want on this machine. Mac App Store apps are only
# offered when you're signed into the App Store.
#
# This is the shared "menu of everything" across all machines, so it's
# hand-curated and append-only: add new packages by dropping a line here. Do NOT
# auto-overwrite it - `bbd` snapshots a machine's installed set to Brewfile.local
# (gitignored) instead, which you diff and copy from. npm globals live in
# setup_node.zsh, and Node is managed by `n`, so there's no `node` formula here.
#
# The comment headers below are purely cosmetic grouping for human reading.

tap "eth-p/software"
tap "mongodb/brew"
tap "supabase/tap"

# --- Shell + prompt -------------------------------------------------------
brew "zsh"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "starship"
brew "carapace"

# --- Core CLI -------------------------------------------------------------
brew "bat"
brew "eth-p/software/bat-extras"
brew "eza"
brew "fastfetch"
brew "fd"
brew "fzf"
brew "gh"
brew "htop"
brew "httpie"
brew "jq"
brew "less"
brew "lftp"
brew "libgit2"
brew "mas"
brew "n"
brew "nano"
brew "neovim"
brew "ripgrep"
brew "thefuck"
brew "tmux"
brew "tree"
brew "unar"
brew "zoxide"

# --- Languages / data tooling ---------------------------------------------
brew "python@3.12"
brew "libomp"
brew "postgresql@17", restart_service: :changed
brew "mongodb/brew/mongodb-community@7.0"
brew "pgloader"
brew "supabase/tap/supabase"
brew "render"
brew "qemu"

# --- Document tooling -----------------------------------------------------
brew "ghostscript"
brew "pandoc"
brew "poppler"

# --- Networking / work ----------------------------------------------------
brew "googleworkspace-cli"
brew "tailscale"

# --- AI -------------------------------------------------------------------
brew "ollama"

# --- Casks: terminal + fonts ----------------------------------------------
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"

# --- Casks: development ---------------------------------------------------
cask "docker-desktop"
cask "ngrok"
cask "postman"
cask "db-browser-for-sqlite"
cask "mongodb-compass"
cask "utm"
cask "visual-studio-code"

# --- Casks: AI ------------------------------------------------------------
cask "chatgpt"
cask "codex"
cask "cursor-cli"
cask "antigravity"
cask "antigravity-cli"

# --- Casks: work / peripherals --------------------------------------------
cask "microsoft-office-businesspro"
cask "microsoft-auto-update"
cask "google-chrome"
cask "displaylink"
cask "logitech-options"
cask "teamviewer"

# --- Casks: personal ------------------------------------------------------
cask "spotify"
cask "discord"
cask "notion"
cask "obsidian"
cask "zoom"
cask "the-unarchiver"

# --- VS Code extensions ---------------------------------------------------
vscode "github.vscode-github-actions"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-python.vscode-python-envs"

# --- Mac App Store (offered only when signed in) --------------------------
mas "Dashlane", id: 517914548
mas "Hotspot Shield", id: 771076721
mas "Notability", id: 360593530
mas "Tailscale", id: 1475387142
mas "WhatsApp", id: 310633997
mas "Windows App", id: 1295203466
mas "Xcode", id: 497799835
