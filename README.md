# dotfiles

macOS dotfiles. One directory per tool; each owns its config, its install and verify
scripts, its Homebrew dependencies and its README.

Done means: on a new macOS account with only stock tools, `./bootstrap.sh` then
`./install.sh` exit 0, `./verify.sh` reports every package `ok`, and a second
`./install.sh` changes nothing. The procedure is `_gate/fresh-account.md`.

Out of scope, never a package: coding-agent configuration, product code, plugins,
trackers, secret values (a package that needs one reads it from the macOS Keychain at
runtime), launchd jobs.

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
lists the conflict; move the file aside and rerun. `install.sh` refuses to run while a
`~/.stowrc` exists, since an `--adopt` there would move files out of `$HOME`.

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
`brew bundle --file=_gate/Brewfile`. `make fmt` reformats scripts. If a check looks
impossible to satisfy, report it rather than loosening it.

Every script is Bash 3.2 (the stock `/bin/bash`), so the install path never depends on
a tool the repo installs: no bash-4 features, and no other runtime. Bootstrap installs
only managers (Homebrew, Stow, mise); a package's tools come from its `Brewfile` or mise.

## Rules

Violations print as `R<n> <path>: <reason>`.

| Rule | Requires |
|---|---|
| R1 | A package holds `README.md`, executable `install.sh` and `verify.sh`, optional `Brewfile` and `home/`, nothing else. |
| R2 | `packages` names exactly the top-level directories not starting with `_` or `.`, once each. |
| R3 | The root holds only the entrypoints, `packages`, `Makefile`, `README.md`, `.gitignore`, `.githooks/`, `.github/`, `_gate/` and packages. |
| R4 | Line 1 `#!/bin/bash`; line 2 a `# ` purpose comment; line 3 `# requires: <cmd> ...` or `# requires: none`. |
| R5 | `home/` is linked only by `stow --dir="$here" --target="$HOME" --no-folding --ignore='\.DS_Store' home`; no `--adopt`, `--override` or `ln -s`. |
| R6 | `bash -n`, shellcheck at style severity with no disable directives, and shfmt (`-i 2 -ci`) pass. |
| R7 | Nothing matches `_gate/forbidden.txt`: agent and tracker names, machine-tied paths, the earlier dotfiles checkout. |
| R8 | Scripts locate themselves with `here="$(cd "$(dirname "$0")" && pwd)"`; no `..` segment, no `--show-toplevel`. |
| R9 | gitleaks finds nothing. |
| R10 | Each structural rule has a mutation fixture in `_gate/fixtures/` that the gate catches. |
| R11 | `verify.sh` changes nothing: no installs, links, file writes or `defaults write`. |
| R12 | A package README is at most 60 lines with `##` What, Install, Customize, Verify, in order. |
| R15 | Every non-stock command is declared on the `# requires:` line and checked with `command -v <cmd> >/dev/null \|\| missing <cmd> "<hint>"` before first use, using the `missing()` function copied from an existing script. Commands a package installs go in `_gate/managed-commands.txt`. |
| R16 | The root entrypoints keep their output and exit codes (above) for conflicts, clean and repeat installs, a missing prerequisite and usage errors. |
| R17 | `brew bundle check` runs as `HOMEBREW_NO_AUTO_UPDATE=1 brew bundle check --no-upgrade`. |

Not machine-checked: an inline comment states a non-obvious why, never what the next
line does; a second `install.sh` changes nothing (proven by the fresh-account procedure).
