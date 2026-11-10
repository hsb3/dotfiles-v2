# jq

## What

jq, the command-line JSON processor, with its default settings. jq has no config file,
so nothing is linked.

## Why

The standard command-line JSON tool; scripts and docs everywhere assume it.

### Alternatives Considered

- yq or gojq: compatible, but less commonly assumed.
- Python one-liners: slower and longer.

## Install

`./install.sh` installs `jq`. Nothing is linked into `$HOME`.

## Customize

Output colours come from the `JQ_COLORS` environment variable (`man jq`, COLORS); export
it from a hook file, `home/.config/zsh/conf.d/jq.zsh`, guarded by `command -v jq`, and
add the Stow line to `install.sh`. Reusable jq functions can live in
`~/.jq`, which jq loads on start.

## Verify

`./verify.sh` checks the Brewfile is satisfied.
