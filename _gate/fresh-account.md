# Fresh-account proof

The success condition in RULES.md section 1, run by hand before declaring a milestone.
`make check` cannot run it: it needs a macOS account that has never seen this repo.

1. System Settings > Users & Groups > Add User. Make it an Administrator (Homebrew's
   installer needs sudo). Log in as that user.
2. Confirm the account is stock: `ls ~/.config ~/.zshrc 2>&1` reports nothing linked, and
   `command -v brew stow mise` prints nothing. Homebrew is per machine: if another
   account already installed it in `/opt/homebrew`, bootstrap's Homebrew step is not
   exercised, `brew install` fails on directory ownership, and zsh's `compinit` may stop
   at an "insecure directories" prompt. Record that as a deviation; it is a property of
   shared Homebrew, not of this repo.
3. Get the repo without git: download the archive from the hosting service and unpack it
   to `~/dotfiles-check`. (`git` itself triggers the Command Line Tools prompt.)
4. `cd ~/dotfiles-check && ./bootstrap.sh`. If it exits 1 asking for a rerun, finish the
   Command Line Tools installer and run it again. Expect exit 0 and `next: ./install.sh`.
5. `./install.sh`. Expect one `ok <pkg>` per line of `packages`, then `6 ok, 0 failed`,
   exit 0.
6. `./verify.sh`. Expect the same `ok` lines and exit 0.
7. Idempotency (R14): mark the time, rerun, look for changes.
   ```
   touch /tmp/marker && sleep 1 && ./install.sh
   find ~ -newer /tmp/marker -not -path '*/Library/*'
   ```
   The `find` must print nothing, and the rerun must print no Homebrew install or
   upgrade lines.
8. Open a new Ghostty window: the Starship prompt shows, `echo $EDITOR` prints `hx`,
   `mise --version` works.
9. Record the date, macOS version and any deviation in RULES.md section 7. Delete the
   test account (System Settings > Users & Groups) when done.
