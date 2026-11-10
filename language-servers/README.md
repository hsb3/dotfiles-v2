# language-servers

## What

Language servers, formatters, linters and debug adapters, on `PATH` for any client that
speaks LSP or DAP: Helix (configured in the helix package) or a coding agent.

| Language | Server | Formatter / linter | Debugger |
|---|---|---|---|
| Python | ty, ruff | ruff | debugpy |
| TypeScript, JavaScript | `tsc --lsp` (TypeScript 7) | prettier, oxlint | js-debug |
| Go | gopls | goimports | delve |
| YAML, TOML, JSON, HTML, CSS, Markdown, Bash, Dockerfile, compose | yaml-language-server, taplo, vscode-langservers-extracted, marksman, bash-language-server, dockerfile-language-server, docker-compose-langserver | prettier, taplo, shfmt | |
| SQL (Postgres) | postgres-language-server | | |

## Why

Shared by every LSP/DAP client (Helix, Zed, coding agents), so each language is set up once. Each tool was chosen 2026-11-08; the reasons are below.

### Alternatives Considered

- TypeScript 7's built-in server over typescript-language-server: TS 7 is the native Go
  port and speaks LSP itself (reported 17.5s to 1.3s to first error on VS Code's own
  codebase); the old server only wraps the JS tsserver.
- oxlint as the JS/TS linter: stable 1.x, 50-100x faster than ESLint, has its own LSP.
- prettier over oxfmt: oxfmt is still 0.x beta and runs no Prettier plugins. Revisit at 1.0.
- Bun is the runtime and package manager only; it has no language server or formatter.
- ty + ruff for Python: ty is beta but nothing faster exists; ruff lints and formats.
- Go from Homebrew, not mise: goimports depends on Homebrew's Go, so mise would add a second.
- postgres-language-server over sqls: sqls has no formula and may be stale; SQL here is Postgres.
- js-debug and debugpy: still the standard DAP adapters; nothing has replaced them.

## Install

`./install.sh` installs the Brewfile (goimports brings Go itself), then declares and
installs the two adapters with no formula through mise: `pipx:debugpy` (its
`debugpy-adapter`) and `github:microsoft/vscode-js-debug`. It links
`~/.local/bin/js-debug-dap`, which starts js-debug's DAP server from mise's install
directory with Node, so clients need no machine-specific path.

## Customize

Add a server to the Brewfile, then name it in the client's config. Which server each
language uses is client config, not this package. TypeScript 7 cannot load compiler
plugins written in JS; a project that needs them keeps TypeScript 6 and
typescript-language-server locally.

## Verify

`./verify.sh` checks the Brewfile is satisfied, both mise tools are declared and
installed, and the launcher is linked. `hx --health <language>` shows what Helix finds.
