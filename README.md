# dotfiles

macOS dotfiles. One directory per tool; each owns its config, its install and verify
scripts, its Homebrew dependencies and its README.

## Set up a Mac

```sh
./bootstrap.sh   # Command Line Tools, Homebrew, Stow, mise. Rerun if it asks.
./install.sh     # every package in `packages` order
./verify.sh      # read-only: is everything installed and linked?
```

Both `install.sh` and `verify.sh` take package names to run a subset:
`./install.sh git helix`. Output is one `ok <pkg>` or `FAIL <pkg>: <reason>` line per
package, then a count. Exit codes: 0 ok, 1 a package failed, 2 usage error, 3 a
prerequisite is missing.

Nothing in `$HOME` is overwritten. If a file is in the way, the package fails and Stow
lists the conflict; move the file aside and rerun.

## Layout

```
bootstrap.sh install.sh verify.sh   entrypoints
packages                             install order
<pkg>/README.md                      what, install, customize, verify
<pkg>/Brewfile                       the package's Homebrew deps (optional)
<pkg>/install.sh  <pkg>/verify.sh    the package's own scripts
<pkg>/home/                          mirrors $HOME; linked with Stow
_gate/                               the quality gate (make check)
```

Shell setup is per package: `zsh` sources `~/.config/zsh/conf.d/*.zsh`, and each package
that needs shell setup ships its own file there.

## Add a package

1. Create `<pkg>/` with the files above. Copy the shape of an existing package.
2. Add `<pkg>` to `packages`.
3. Add any new command it installs to `_gate/managed-commands.txt`.
4. `make check` until green.

## The gate

`make check` is the only gate. It runs as the pre-commit hook (`bootstrap.sh` sets
`core.hooksPath`) and in CI. Its tools come from `_gate/Brewfile`:
`brew bundle --file=_gate/Brewfile`. `make fmt` reformats scripts.
