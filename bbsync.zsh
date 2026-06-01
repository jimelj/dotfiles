#!/usr/bin/env zsh
# =============================================================================
# bbsync - capture apps installed on THIS machine into the tracked Brewfile
# =============================================================================
# Finds packages that are installed but NOT yet in the master Brewfile, APPENDS
# them (never prunes - keeps the shared "menu of everything" intact across
# machines), then pulls --rebase, commits, and pushes.
#
# Usage:
#   bbsync            # detect new installs, append, commit, push
#   bbsync --dry-run  # just show what WOULD be added (no file/git changes)

emulate -L zsh
setopt no_unset pipe_fail

DOTS="$HOME/.dotfiles"
BREWFILE="$DOTS/Brewfile"
SNAPSHOT="$DOTS/Brewfile.local"

source "$DOTS/lib.zsh"   # ensure brew is on PATH

DRY=false
[[ "${1:-}" == "--dry-run" || "${1:-}" == "-n" ]] && DRY=true

# 1. Snapshot everything installed on this machine (gitignored file).
echo "Snapshotting installed packages..."
brew bundle dump --force --describe --file="$SNAPSHOT"

# 2. Build a set of identities already in the master Brewfile.
#    Key on the directive type + the LEAF name (basename after any tap path),
#    so "mongodb/brew/mongodb-community@7.0" and "mongodb-community@7.0" match.
typeset -A HAVE
while IFS= read -r line; do
  if [[ "$line" =~ '^[[:space:]]*(tap|brew|cask|mas|vscode)[[:space:]]+"([^"]+)"' ]]; then
    local key="${match[1]}:${match[2]:t}"   # bare-var subscript (quotes inside
    HAVE[$key]=1                            # a literal subscript become part
  fi                                        # of the key in zsh)
done < "$BREWFILE"

# Packages to never auto-add (managed elsewhere), matched by name. See
# .bbsyncignore in the repo root.
typeset -A IGNORE
if [[ -f "$DOTS/.bbsyncignore" ]]; then
  while IFS= read -r line; do
    [[ "$line" == \#* || -z "${line// }" ]] && continue
    local ig="${line## }"; ig="${ig%% }"
    IGNORE[$ig]=1
  done < "$DOTS/.bbsyncignore"
fi

# 3. Walk the snapshot; collect directive lines whose identity isn't in HAVE.
#    Carry the `# description` comment that `--describe` writes above each entry.
typeset -a NEW
local pending_comment=""
while IFS= read -r line; do
  if [[ "$line" == \#* ]]; then
    pending_comment="$line"
    continue
  fi
  if [[ "$line" =~ '^[[:space:]]*(tap|brew|cask|mas|vscode)[[:space:]]+"([^"]+)"' ]]; then
    local key="${match[1]}:${match[2]:t}" leaf="${match[2]:t}"
    if [[ -z "${HAVE[$key]:-}" && -z "${IGNORE[$leaf]:-}" ]]; then
      [[ -n "$pending_comment" ]] && NEW+="$pending_comment"
      NEW+="$line"
    fi
  fi
  pending_comment=""
done < "$SNAPSHOT"

if (( ${#NEW} == 0 )); then
  echo "Nothing new - the Brewfile already has everything installed here."
  return 0 2>/dev/null || exit 0
fi

echo "\nNew on this machine (not yet in Brewfile):"
printf '  %s\n' "${NEW[@]}"

if [[ "$DRY" == true ]]; then
  echo "\n(dry run) Not modifying the Brewfile or git."
  return 0 2>/dev/null || exit 0
fi

# 4. Pull latest first so we append on top of the newest master.
echo "\nPulling latest..."
git -C "$DOTS" pull --rebase --autostash || {
  echo "git pull failed - resolve, then re-run bbsync."; exit 1; }

# 5. Append the new entries under a dated section.
{
  echo ""
  echo "# --- Added by bbsync on $(date '+%Y-%m-%d') ---"
  for l in "${NEW[@]}"; do echo "$l"; done
} >> "$BREWFILE"

# 6. Commit just the Brewfile and push.
# Note: no machine name in the header or message - this repo is public and a
# work machine's hostname can encode an asset tag / username.
git -C "$DOTS" add Brewfile
git -C "$DOTS" commit -m "chore(brewfile): add $(( ${#NEW} )) entr$([[ ${#NEW} -eq 1 ]] && echo y || echo ies) via bbsync" || {
  echo "Nothing to commit."; exit 0; }
git -C "$DOTS" push || { echo "git push failed - push manually."; exit 1; }

echo "\nDone - appended and pushed."
