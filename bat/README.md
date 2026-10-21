# bat

## What

bat, a `cat` with syntax highlighting and git markers. Config in
`~/.config/bat/config`: the built-in `TwoDark` theme (the Atom One Dark port, closest
to the onedark used elsewhere), everything else bat's default.

## Install

`./install.sh` installs `bat` and links the config.

## Customize

Edit `home/.config/bat/config`: one command-line flag per line, `#` comments allowed.
`bat --list-themes` shows the built-in themes; `man bat` lists every flag. bat never
writes this file itself.

## Verify

`./verify.sh` checks the Brewfile is satisfied and the config is linked.
