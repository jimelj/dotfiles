# dotfiles

My macOS dotfiles, managed with [dotbot](https://github.com/anishathalye/dotbot).
One command (`./install`) sets up the shell, terminal, CLI tools, and apps on a
fresh Mac. The Homebrew install is **interactive**: there's a single `Brewfile`,
and at install time you get a checklist of every package (all pre-selected) and
untick whatever you don't want on this machine. Mac App Store apps are only
offered when you're signed into the App Store.

## What's in here

| Path | Purpose |
| --- | --- |
| `install` / `install.conf.yaml` | dotbot entrypoint: symlinks + setup scripts |
| `zshrc`, `zshenv` | shell config (interactive vs all-sessions) |
| `gitconfig` | git identity |
| `config/` | app configs (ghostty, starship, tmux, bat) symlinked to `~/.config` |
| `Brewfile` | full list of packages (you pick from it at install time) |
| `setup_*.zsh` | homebrew / zsh / node / macos setup steps |
| `lib.zsh` | shared helpers (puts Homebrew on PATH, prompts) |
| `bbsync.zsh` | append newly-installed apps to the Brewfile and push (`bbsync`) |
| `.bbsyncignore` | packages `bbsync` should never auto-add (e.g. `node`) |

## Restore on a new Mac

1. Install Command Line Tools (required for git + Homebrew):

   ```zsh
   xcode-select --install
   ```

2. Clone the repo (start with HTTPS; switch to SSH after setup):

   ```zsh
   git clone https://github.com/jimelj/dotfiles ~/.dotfiles
   cd ~/.dotfiles
   ```

3. (Optional) sign into the **App Store** app now if you want `mas` apps
   (WhatsApp, Xcode, etc.) installed during setup. The installer skips them
   automatically if you're not signed in.

4. Run the installer. It symlinks the dotfiles, installs Homebrew, then shows a
   checklist of every package in the `Brewfile`:

   ```zsh
   ./install
   ```

   - Every entry is pre-selected; untick what you don't want (type `/` to
     filter in the `gum` picker, space to toggle, enter to confirm).
   - App Store apps appear in the list only if you're signed in.
   - If `gum` isn't available or it's a non-interactive run, everything in the
     Brewfile is installed.

5. Restart, or at least open a new terminal so the login shell picks up
   Homebrew and the new default shell.

6. Set up SSH and switch the remote to SSH:

   ```zsh
   # Generate an SSH key
   ssh-keygen -t ed25519 -C "3507684+jimelj@users.noreply.github.com"

   # Start ssh-agent and configure it
   eval "$(ssh-agent -s)"
   cat >> ~/.ssh/config <<'EOF'
   Host *
     AddKeysToAgent yes
     UseKeychain yes
     IdentityFile ~/.ssh/id_ed25519
   EOF

   ssh-add --apple-use-keychain ~/.ssh/id_ed25519

   # Copy the public key, add it at github.com > Settings > SSH and GPG keys
   pbcopy < ~/.ssh/id_ed25519.pub

   # Test, then switch the remote to SSH
   ssh -T git@github.com
   git remote set-url origin git@github.com:jimelj/dotfiles.git
   ```

## Re-running

`./install` is safe to re-run. dotbot relinks dotfiles and cleans broken
symlinks; the setup scripts skip work that's already done. Re-running brings up
the package checklist again, so it's also how you add packages you skipped
earlier (or just `brew bundle` the whole list):

```zsh
brew bundle --file=Brewfile      # install everything, no prompt
```

## Adding packages

The `Brewfile` is the shared "menu of everything" across all your machines, so
it's **append-only** — new packages are added, never pruned. Auto-overwriting it
would prune the menu to one machine's installed set and cause merge conflicts.

Installed something new and want it in the repo? Run:

```zsh
bbsync              # append new installs to Brewfile, then commit + push
bbsync --dry-run    # preview what it would add, no changes
```

`bbsync` finds packages installed on this machine that aren't in the `Brewfile`
yet, appends them under a dated section, then `pull --rebase` + `commit` + `push`.
Packages listed in `.bbsyncignore` (e.g. `node`, managed by `n`) are skipped.

For a quick manual look without committing, `bbd` snapshots everything installed
to `Brewfile.local` (gitignored) and prints a `diff` command.

## Decommission an old Mac

- Commit and push everything; back up files (Time Machine / cloud).
- Export VS Code extensions: `code --list-extensions` (they're already tracked
  in the `Brewfile` as `vscode` entries; `bbsync` keeps them current).
- Deactivate any licensed apps and sign out of the App Store.
