# dotfiles — build contract and quality gate

This repo produces a configured macOS user environment: one command sequence takes a
stock Mac account to a working shell, editor, terminal and toolchain. This file is the
contract it is built against: what is being built, in what language, and which checks
are machine-enforced before anything lands.

The rig (`Makefile`, `_gate/`, `.githooks/`, `.github/workflows/`) is provided by the
contract, not by the author: **configuration files are read-only.** If a gate looks
impossible to satisfy, report it rather than loosening it.

---

## 1. What is being built

A set of self-contained **packages**, one per tool, plus three root entrypoints that
run them in a declared order.

| Part | Role |
|---|---|
| `bootstrap.sh` | Installs the managers the rest depends on: Xcode Command Line Tools, Homebrew, GNU Stow, mise. Sets `core.hooksPath`. Runs first, once per machine. |
| `install.sh` | Runs each listed package's `install.sh`, in `packages` order. |
| `verify.sh` | Runs each listed package's `verify.sh`, in `packages` order. Read-only. |
| `packages` | The ordered package list. One name per line; `#` comments allowed. |
| `<pkg>/` | One tool: its config, its install and verify scripts, its README, its brew deps. |
| `_gate/` | The gate's checker, its self-test fixtures, its tool Brewfile, and the fresh-account procedure. |

**Core packages (revision 1):** `zsh`, `git`, `ghostty`, `starship`, `mise`, `helix`.
Every other tool is ported later, one package per change, and lands only through the
gate. Nothing is copied in bulk from any earlier dotfiles repo.

**Not the artifact:** coding-agent configuration, product code, plugins, trackers,
secret values, launchd jobs. None of these get a package.

The success condition is not "every tool is configured". It is:
**on a new macOS user account with only stock tools, `./bootstrap.sh` then
`./install.sh` exit 0, `./verify.sh` reports every package `ok`, and a second
`./install.sh` run changes nothing.** The procedure is `_gate/fresh-account.md`.

## 2. Languages and runtimes

**Bash 3.2, the stock `/bin/bash`.** Every script in the repo, the rig included. Chosen
because it is present on a stock Mac before anything is installed, so the install path
never depends on a tool the repo installs. No bash-4 features (associative arrays,
`mapfile`, `${var,,}`, `|&`). No Python, Node, Ruby or other runtime in the install path.

**Config files** are in each tool's native format (zsh, TOML, gitconfig, etc.) and are
judged only by the tool that reads them.

**Make 3.81** (from Command Line Tools) runs the gate.

**Dependency policy:** bootstrap may install only managers (Homebrew, Stow, mise).
A package's tools come from its own `Brewfile` or mise. The gate's tools come from
`_gate/Brewfile` and are never needed by bootstrap, install or verify.

Gate tooling as measured: **shellcheck 0.11.0**, **shfmt 3.14.1**, **gitleaks 8.30.1**.
Homebrew cannot pin formula versions, so these are recorded, not pinned: `make check`
prints the versions it ran with, and CI installs whatever Homebrew currently ships. A
tool upgrade that turns the gate red is a finding to fix, not a reason to loosen it.

## 3. The gate

One command, run from the repo root:

```
make check
```

which enforces, in order, printing every violation rather than stopping at the first:

1. **Structure** — R1–R5, R11, R12, R15 (`_gate/check.sh structure`).
2. **Shell** — R6: `/bin/bash -n`, `shellcheck --shell=bash --severity=style`,
   `shfmt -d -i 2 -ci`, and a scan for bash-4 constructs, on every `*.sh` and every
   file with a bash or sh shebang.
3. **References** — R7, R8 (`_gate/check.sh references`).
4. **Secrets** — R9: `gitleaks dir --no-banner .`.
5. **Self-test** — R10: `_gate/fixtures/base/` is a minimal valid repo that must pass
   steps 1–4. Each `_gate/fixtures/R<n>-<slug>.sh` mutates a copy of it; steps 1–4 must
   then report rule R<n> and no other rule.

The rig's own scripts are inside every step: a checker that cannot pass the standard it
enforces is advice, not law.

**Limits.** Steps 1 and 3 are line-pattern checks over script text. They catch the
ordinary slip (the wrong flag, a forgotten declaration, a stray write in `verify.sh`),
not a determined workaround such as building a command name from variables. Review
still reads every script against section 6. The pre-commit hook runs on the working
tree, not only the staged files, so unstaged edits can block a commit.

`make check` runs as the pre-commit hook (`.githooks/pre-commit`) and in CI on every
push to every branch (`.github/workflows/check.yml`, macOS runner). It is a merge
requirement on `main`.

**Proven both ways on 2026-10-21:** green on the final tree (`check: 0 violation(s)`),
and red when sabotaged, one break per step, each reverted afterwards:

| Step | Sabotage | Caught as |
|---|---|---|
| structure | `touch notes.txt` at the root | `R3 notes.txt: not allowed at the repo root` |
| shell | `for f in $(ls)` appended to `git/install.sh` | `R6 git/install.sh: shellcheck` |
| references | an absolute home-directory path appended to `git/README.md` | `R7 git/README.md: line 28 matches _gate/forbidden.txt` |
| secrets | a token-shaped string in a file under `git/home/` | `R9 .: gitleaks found a secret` |
| selftest | the R12 fixture made a no-op | `R10 ...R12-readme-headings.sh: expected only R12, got: nothing` |

---

## 4. Rules

Machine-enforced rules first. Rule numbers are stable; the gate cites them.

**R1 — Package shape.** Each package directory contains `README.md`, `install.sh`
and `verify.sh`, both scripts executable, and optionally `Brewfile` and `home/`.
Nothing else at the package's top level.

**R2 — Package list.** Every name in `packages` is a directory; every top-level
directory not starting with `_` or `.` is in `packages`. No duplicates.

**R3 — Root allowlist.** The repo root contains only: `bootstrap.sh`, `install.sh`,
`verify.sh`, `packages`, `Makefile`, `README.md`, `RULES.md`, `.gitignore`,
`.githooks/`, `.github/`, `_gate/`, and package directories.

**R4 — Shebang and header.** A script is any `*.sh` file or any file starting with
`#!`, including executables under a package's `home/`. Every script's line 1 is exactly `#!/bin/bash`; line 2 is
a `# ` comment stating the script's purpose; line 3 is `# requires: <cmd> ...` (R15),
or `# requires: none`.

**R5 — Linking.** Config reaches `$HOME` only through this exact line in the
package's `install.sh`, present if and only if the package has `home/`:

```
stow --dir="$here" --target="$HOME" --no-folding --ignore='\.DS_Store' home
```

`--no-folding` keeps every directory in `$HOME` real, so tools that write next to
their config (and machine-local files such as `~/.config/zsh/conf.d/local.zsh`) never
write into the repo. `--adopt`, `--override` and `ln -s` never appear in a package
script.

**R6 — Shell quality.** Every script passes `/bin/bash -n`, shellcheck at style
severity with no `disable` directives, and shfmt.

**R7 — Forbidden references.** No file outside `_gate/forbidden.txt` and
`_gate/fixtures/` matches any pattern in `_gate/forbidden.txt` (case-insensitive). The
list holds coding-agent and tracker names, absolute home paths, and earlier dotfiles
locations. Adding a pattern is a contract revision.

**R8 — Package isolation.** A package's scripts locate themselves with the line
`here="$(cd "$(dirname "$0")" && pwd)"`, contain no `..` path segment, and never ask
git for the repo root (`--show-toplevel`). With no way to name the repo root, a
package cannot reach into another package.

**R9 — No secrets.** gitleaks finds nothing. Secret values never enter the repo; a
package that needs one reads it from the macOS Keychain at runtime.

**R10 — The rig fails when it should.** Each rule R1–R9, R11, R12, R15 has at least one
mutation fixture, and the gate fails if one is missing.

**R11 — Read-only verify.** No `verify.sh` (root or package) contains `brew install`, `brew bundle`
without `check`, `stow` without `--no`/`-n`, `mise install`, `rm `, `mv `, `cp `, `ln `,
`mkdir`, `touch`, `tee`, `mktemp`, `sed -i`, `find -delete`, `defaults write`, or a
`>` redirect to anything but `/dev/null`, `&1` or `&2`. Homebrew's own cache under
`~/Library/Caches` is the one accepted side effect of `brew bundle check`.

**R12 — README shape.** A package `README.md` is at most 60 lines and has exactly these
`##` headings in this order: `What`, `Install`, `Customize`, `Verify`. The root
`README.md` is at most 100 lines.

**R15 — Scripts check their own prerequisites.** Every command a script needs that is
not part of stock macOS is named on its `# requires:` line, and the script checks each
one before doing any work, in exactly this form:

```
missing() {
  echo "missing prerequisite: $1 ($2)" >&2
  exit 3
}
command -v brew >/dev/null || missing brew "run bootstrap.sh"
```

One `command -v` line per declared command, each with its own hint, and each before
the first line that runs that command. Each script
carries its own copy; there is no shared helper to source (R8). The gate also fails any
script that runs a command from the managed set (`_gate/managed-commands.txt`: the
managers, the gate tools, and every command a package installs) in command position
without declaring it. A package adding a command adds it to that list.
`bootstrap.sh` is exempt from the managed-set scan because it installs that set; it
declares `# requires: none`.

**R13 — Comments (prose).** Beyond the R4 header, an inline comment states a
non-obvious why, never what the next line does. Budget: at most one inline comment per
function, plus one per non-obvious external constraint (an OS quirk, a tool bug).

**R14 — Idempotency (procedure).** A second `install.sh` run changes nothing: no file
in `$HOME` modified, no package reinstalled. Proven by `_gate/fresh-account.md`, not by
`make check`, because it needs a stock account.

## 5. Behavioral spec

**Entrypoints.** `install.sh [pkg...]` and `verify.sh [pkg...]` take optional package
names; with none, they run every package in `packages` order. Named packages run in
`packages` order regardless of argument order.

**Output.** One line per package, to stdout: `ok <pkg>` or `FAIL <pkg>: <reason>`.
The reason is, in order of preference: `missing prerequisite: <cmd>`, `conflicts with
existing ~/<path>` (the first Stow conflict), or the package's last stderr line.
Package stdout and stderr go to stderr. A final line `<n> ok, <m> failed`.

**Exit codes.** `0` all ok; `1` any package failed; `2` usage error (unknown package
name, unknown flag), with the diagnostic on stderr and no package run; `3` a
prerequisite of the script itself is missing (R15), nothing run. A package script
exiting 3 makes that package `FAIL <pkg>: missing prerequisite: <cmd>`.

**Error paths.**

| Situation | Required behavior |
|---|---|
| A file in `$HOME` blocks a link | Stow refuses and lists every conflict; that package is `FAIL`, nothing in `$HOME` is moved or overwritten. |
| One package's install fails | Continue with the rest; exit 1 at the end. |
| Command Line Tools missing | `bootstrap.sh` starts their installer, prints `rerun bootstrap.sh after the installer finishes`, exits 1. |
| A manager missing when `install.sh` runs | Print `missing prerequisite: <manager> (run bootstrap.sh)`, exit 3, run no package. |
| `packages` empty or all comments | `0 ok, 0 failed`, exit 0. |
| Network unavailable | The failing package is `FAIL` with the underlying tool's message; no retries. |

**Environment inputs.** `HOME` and `PATH`. Nothing reads the clock, hostname or user
name to make a decision. Stow also reads `~/.stowrc`; `install.sh` refuses to run while
one exists, because an `--adopt` there would move files out of `$HOME`.

**Read-only guarantees.** `verify.sh` (root and per package) changes nothing (R11).
No tool writes through a link into the repo in normal use: directories in `$HOME` stay
real (R5), and git's global config is a real `~/.gitconfig` that only includes the
linked file. No script
writes outside `$HOME`, Homebrew's prefix, mise's data directory, and the repo.

## 6. Judging criteria

1. Can a reader learn a package from its README alone, without opening its scripts?
2. Does each `install.sh` do only what its README says it does?
3. Could a package be deleted by removing its directory and its `packages` line, with
   nothing else breaking?
4. Is anything in the repo there "for later"?

## 7. Baseline against this gate

Measured 2026-10-21 on the tree holding only this file and the first draft of the rig
(`Makefile`, `_gate/check.sh`, `_gate/forbidden.txt`, `_gate/managed-commands.txt`,
`_gate/Brewfile`, `.gitignore`), before any package or fixture existed:

| Rule | Status |
|---|---|
| R2 package list | **fail**: `packages` missing |
| R6 shell quality | **fail**: 2 findings in the rig itself. shellcheck SC2015 and SC2013 in `_gate/check.sh`, and the bash-4 scan matched its own `/dev/null\|&[12]` regex (a false positive, fixed by requiring whitespace around `\|&`) |
| R10 rig fails when it should | **fail**: 13 findings. No base fixture, and no mutation fixture for any of the 12 rules |
| all others | pass (vacuously: there were no packages or scripts besides the checker) |

`check: 16 violation(s)`. The rig failing its own gate on the first run is why it is
inside the gate. The tree as committed passes: `check: 0 violation(s)`.

The fresh-account proof (section 1, R14) has **not been run yet**. Install and
idempotency were tested only against a temporary `HOME` on a machine that already had
every Homebrew dependency, so the Homebrew download path and `bootstrap.sh` are unproven.

## 8. Revision history

**Revision 2 (2026-10-21)** — after an adversarial review that got 21 of 31 sabotages
past the first gate and found 3 behavior defects. Fixed: `git config --global` wrote
through the link into the repo (git now includes a linked file from a real
`~/.gitconfig`); package names were matched as regexes; root `verify.sh` used a temp
file and was outside R11. Tightened: command-position matching sees `command`, `env`,
`sudo`, quoted and path-qualified names; trailing comments are ignored; R15 checks the
exact `missing()` body and check-before-use order; R6 bans inline disable directives
and `.shellcheckrc`, and catches `${x^}` and negative subscripts; R4 covers every
shebang file; R7 checks paths as well as contents; R9 bans gitleaks allow-comments; R12
ignores headings inside code fences. Stated the gate's limits (section 3) and that tool
versions are recorded, not pinned.


**Revision 1 (2026-10-21)** — first contract, from the starting-conditions interview.
Fresh repo, no history carried. Core-first scope with helix as the editor. Stow kept as
the linker, installed by bootstrap. Bash 3.2 chosen so the install path runs on a stock
Mac. Every script declares and checks its own prerequisites (R15, exit 3).
Decided while building the rig: Stow runs with `--no-folding` (R5); shell setup is
owned per package through `~/.config/zsh/conf.d/<pkg>.zsh`; R8 is enforced through
the self-locating line rather than by guessing package names in paths.
