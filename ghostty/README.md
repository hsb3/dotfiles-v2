# ghostty

## What

The Ghostty terminal and the JetBrains Mono Nerd Font (`font-jetbrains-mono-nerd-font`), with a minimal config in
`~/.config/ghostty/config`.

## Why

A fast, native macOS terminal with sensible defaults and a plain-text config.

### Alternatives Considered

- iTerm2: config lives in a plist, hard to keep in git.
- WezTerm, Kitty: capable, but not native macOS apps, and need more config for the same result.
- Terminal.app: no truecolor.

## Install

`./install.sh` installs both casks and links the config.

## Customize

Edit `home/.config/ghostty/config`. All options with docs: `ghostty +show-config --default --docs`.
Reload in Ghostty with cmd+shift+, .

## Verify

`./verify.sh` checks the casks are installed and the config is linked.
