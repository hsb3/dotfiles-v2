# Fresh-machine proof

The success condition in RULES.md section 1, run by hand before declaring a milestone.
`make check` cannot run it: it needs a macOS account that has never seen this repo.

Pick a venue (A or B), then run the checklist from step 4. Record which venue was used.

## Venue A (recommended): a throwaway macOS VM with Tart

**Unverified:** these steps come from Tart's documentation and have not been run yet.
A VM gives a whole machine that has never seen Homebrew, so bootstrap's Homebrew step
is exercised, and discarding it leaves this Mac as it was. Tart needs Apple silicon and
macOS 13 or later; one image takes about 25 GB of disk. Tart's licence is FSL-1.1-ALv2;
the images come from Cirrus Labs.

1. On this Mac, install Tart with the Homebrew command on tart.run (Quick Start). Its
   tap has moved before, so take the command from there. Then pull a vanilla image
   (stock macOS plus auto-login, no Homebrew) and make a disposable copy:
   ```
   tart clone ghcr.io/cirruslabs/macos-golden-gate-vanilla:latest v2-fresh
   ```
   `golden-gate` is the newest family in cirruslabs/macos-image-templates, presumably
   macOS 27 like this Mac; check About This Mac in the VM, and use
   `macos-tahoe-vanilla` (macOS 26) if it is not available.
2. Export the repo and boot the VM with it shared read-only (a private repo cannot be
   downloaded inside the VM without signing in):
   ```
   mkdir -p /tmp/v2-share && git -C <repo> archive -o /tmp/v2-share/v2.tar.gz main
   tart run --dir=v2:/tmp/v2-share:ro v2-fresh
   ```
   The VM logs in automatically as `admin` (password `admin`). That user has
   passwordless sudo, unlike a stock account; record it as a deviation.
3. In the VM's Terminal, copy the repo out of the share so links never point into it:
   `mkdir ~/dotfiles-check && tar -xzf "/Volumes/My Shared Files/v2/v2.tar.gz" -C ~/dotfiles-check`.
   Then continue at step 4.

When done (after step 9): shut the VM down, then on this Mac run `tart delete v2-fresh`
and `rm -r /tmp/v2-share`. The pulled image stays in Tart's cache for the next run;
`tart prune` (see `tart prune --help`) frees it.

## Venue B (fallback): a new account on this Mac

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

## Checklist

4. `cd ~/dotfiles-check && ./bootstrap.sh`. If it exits 1 asking for a rerun, finish the
   Command Line Tools installer and run it again. Expect exit 0 and `next: ./install.sh`.
5. `./install.sh`. Expect one `ok <pkg>` line per package in `packages`, then
   `<n> ok, 0 failed`, exit 0. The mise-managed tools (uv, bun, pnpm, fnox) download on this
   run, so it needs network.
6. `./verify.sh`. Expect the same `ok` lines and exit 0.
7. Idempotency (R14): mark the time, rerun, look for changes.
   ```
   touch /tmp/marker && sleep 1 && ./install.sh
   find ~ -newer /tmp/marker -not -path '*/Library/*'
   ```
   The `find` must print nothing, and the rerun must print no Homebrew install or
   upgrade lines.
8. Open a new Ghostty window and check:
   - the Starship prompt shows; `echo $EDITOR` prints `hx`; `mise --version` works;
   - `print -l $path` starts with `~/.local/bin`;
   - `Ctrl-R` opens fzf; `z` is defined (`whence -w z`);
   - `git config --get-all include.path` lists `dotfiles.gitconfig` and
     `delta.gitconfig`, and `git diff` pages through delta;
   - `mise which uv`, `mise which bun`, `mise which pnpm` and `mise which fnox` each print
     a path, and `uv <Tab>` and `fnox <Tab>` complete;
   - `fnox provider list` prints `keychain`;
   - `gh config get git_protocol` prints `ssh`;
   - btop, lazygit and tmux each start and quit cleanly;
   - `pnpm add -g cowsay && command -v cowsay` works;
   - in a VM only (its Keychain is disposable): `fnox set V2_CHECK --provider keychain
     --global` with any value, then `fnox exec -- printenv V2_CHECK` prints it after
     macOS's access prompt, and `printenv V2_CHECK` in the shell prints nothing.
9. Record the date, venue, macOS version and any deviation in RULES.md section 7. Then
   discard the venue: delete the VM (venue A) or the test account (venue B, System
   Settings > Users & Groups).
