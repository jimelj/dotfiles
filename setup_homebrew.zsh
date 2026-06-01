#!/usr/bin/env zsh
# =============================================================================
# Homebrew setup: install brew, then interactively pick packages to install
# =============================================================================
# There is a single ./Brewfile. This script parses it and shows a checklist
# (every entry pre-selected); you untick what you don't want on this machine.
# Mac App Store apps are only offered when you're signed into the App Store.

# Shared helpers (guarantees brew is on PATH + provides exists()/confirm()).
source "${0:A:h}/lib.zsh"

BREWFILE="${0:A:h}/Brewfile"

echo "\n<<< Starting Homebrew Setup >>>\n"

# --- Install Homebrew if missing ------------------------------------------
if exists brew; then
  echo "Brew exists, skipping install"
else
  echo "Brew doesn't exist, continuing with install"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Persist brew for future LOGIN shells...
  if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
    echo >> "$HOME/.zprofile"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  fi
  # ...and load it for THIS process right now.
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- TMUX Plugin Manager ---------------------------------------------------
echo "\n<<< TMUX Plugin Manager >>>\n"
if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "TPM already installed, skipping"
else
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# --- Install gum up front (drives the interactive picker) ------------------
# Installed before any Brewfile work so the checklist is always available.
if exists gum; then
  echo "\ngum already installed, skipping"
else
  echo "\n<<< Installing gum (interactive picker) >>>\n"
  brew install gum
fi

# --- App Store note -------------------------------------------------------
# `mas account` is unreliable on recent macOS (Apple removed the private API
# it relied on), so it reports "not signed in" even when you are. We no longer
# gate on it: App Store apps are always offered. brew bundle runs `mas install`
# directly, which works when you're signed in; if you're not, only those
# specific installs fail and you can re-run after signing in.
if mas account >/dev/null 2>&1; then
  echo "\nApp Store: signed in as $(mas account)"
else
  echo "\nApp Store: sign-in status unknown (this check is unreliable on recent macOS)."
  echo "  App Store apps are still offered. If any fail, sign into the App Store app and re-run ./install."
fi

# --- Parse the Brewfile into taps + selectable items ----------------------
typeset -a TAP_LINES        # always applied (prerequisites)
typeset -a LABELS           # ordered display labels for the checklist
typeset -A ITEM_LINE        # label -> original Brewfile line

while IFS= read -r line; do
  if [[ "$line" =~ '^[[:space:]]*tap[[:space:]]+"([^"]+)"' ]]; then
    TAP_LINES+="$line"
  elif [[ "$line" =~ '^[[:space:]]*(brew|cask|mas|vscode)[[:space:]]+"([^"]+)"' ]]; then
    local kind="${match[1]}" name="${match[2]}"
    local label="${kind}: ${name}"
    LABELS+="$label"
    ITEM_LINE[$label]="$line"
  fi
done < "$BREWFILE"

# --- Let the user pick ----------------------------------------------------
typeset -a CHOSEN
if [[ -t 0 ]] && exists gum; then
  echo "\nPick what to install. Type / to filter, space to toggle, enter to confirm."
  CHOSEN=("${(@f)$(
    printf '%s\n' "${LABELS[@]}" |
      gum choose --no-limit --height=20 \
        --selected="${(j:,:)LABELS}" \
        --header='Packages (all pre-selected - untick what you do not want)'
  )}")
else
  echo "\n(non-interactive or gum unavailable) installing everything in the Brewfile"
  CHOSEN=("${LABELS[@]}")
fi

# --- Build a temporary Brewfile of taps + chosen items, then install -------
TMP_BF="$(mktemp -t Brewfile.XXXXXX)"
{
  for t in "${TAP_LINES[@]}"; do print -r -- "$t"; done
  for label in "${CHOSEN[@]}"; do
    [[ -n "$label" ]] && print -r -- "${ITEM_LINE[$label]}"
  done
} > "$TMP_BF"

# Count selected installable items (lines minus taps).
local n_taps=${#TAP_LINES}
local n_total=$(wc -l < "$TMP_BF" | tr -d ' ')
echo "\n>>> Installing $(( n_total - n_taps )) selected package(s)...\n"

if brew bundle --file="$TMP_BF" --verbose; then
  echo "\n<<< Homebrew Setup Complete - all selected packages installed. >>>\n"
else
  echo "\n<<< Some packages failed. Re-run ./install to retry the rest. >>>\n"
fi

rm -f "$TMP_BF"
