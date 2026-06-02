#!/usr/bin/env zsh
# =============================================================================
# focus-sync - sync a private work repo (code + Obsidian vault) across machines
# =============================================================================
# Syncs the git repo at $FOCUS_REPO (default ~/WebDev/Focus). Because you only
# use one machine at a time, the bare command does the full round-trip (commit
# local work, pull --rebase, push), so the SAME command works whether you just
# sat down or are about to leave.
#
# This file is tracked in the PUBLIC dotfiles repo, so it stays generic: the repo
# path and clone URL come from env vars ($FOCUS_REPO / $FOCUS_REMOTE) rather than
# being hardcoded. Set those per-machine (e.g. in a gitignored shell file) if the
# defaults don't match.
#
# NOTE: Claude's own project memory syncs separately via Syncthing (the ~/.claude
# folder), not through this script. This is only the work git repo.
#
# Usage:
#   focus-sync          # commit local changes, pull --rebase, push (arrive AND leave)
#   focus-sync pull     # just pull latest (--rebase --autostash)
#   focus-sync push     # just commit + push local changes
#   focus-sync status   # show working tree + ahead/behind
#   focus-sync --help

emulate -L zsh
setopt pipe_fail

REPO="${FOCUS_REPO:-$HOME/WebDev/Focus}"
STAMP="$(date '+%Y-%m-%d %H:%M') [$(hostname -s)]"

if [[ ! -d "$REPO/.git" ]]; then
  echo "focus-sync: no git repo at $REPO"
  if [[ -n "${FOCUS_REMOTE:-}" ]]; then
    echo "  Clone it first:  git clone \"$FOCUS_REMOTE\" \"$REPO\""
  else
    echo "  Clone your repo to \$FOCUS_REPO (or set FOCUS_REPO / FOCUS_REMOTE)."
  fi
  return 1 2>/dev/null || exit 1
fi

_fs_pull() {
  echo "Pulling latest..."
  git -C "$REPO" pull --rebase --autostash || {
    echo "focus-sync: pull/rebase hit a conflict. Resolve it in $REPO, then re-run."
    return 1
  }
}

_fs_commit_local() {
  [[ -n "$(git -C "$REPO" status --porcelain)" ]] || return 0
  git -C "$REPO" add -A
  git -C "$REPO" commit -q -m "focus-sync: $STAMP" && echo "Committed local changes."
}

case "${1:-sync}" in
  pull)
    _fs_pull
    ;;
  push)
    if _fs_commit_local && [[ -n "$(git -C "$REPO" log @{push}..HEAD 2>/dev/null)" ]]; then
      git -C "$REPO" push && echo "Pushed." || { echo "focus-sync: push failed - push manually from $REPO."; return 1 2>/dev/null || exit 1; }
    else
      echo "Nothing to push - already up to date."
    fi
    ;;
  status)
    git -C "$REPO" status -s
    br="$(git -C "$REPO" branch --show-current)"
    git -C "$REPO" rev-list --left-right --count "origin/$br...HEAD" 2>/dev/null \
      | awk -v b="$br" '{print "branch "b" | behind "$1", ahead "$2}'
    ;;
  sync)
    # Commit local work first so the rebase replays cleanly, then integrate + push.
    _fs_commit_local
    if _fs_pull; then
      git -C "$REPO" push && echo "Synced." || echo "focus-sync: push failed - push manually from $REPO."
    fi
    ;;
  -h|--help|help)
    echo "focus-sync          commit local changes, pull --rebase, push"
    echo "focus-sync pull     just pull latest"
    echo "focus-sync push     just commit + push local changes"
    echo "focus-sync status   show working tree + ahead/behind"
    ;;
  *)
    echo "focus-sync: unknown command '$1' (try: pull | push | status | --help)"
    return 1 2>/dev/null || exit 1
    ;;
esac
