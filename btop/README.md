# btop

## What

The btop resource monitor. Config in `~/.config/btop/btop.conf`: the `onedark` theme
(bundled with btop) and `save_config_on_exit = false`, everything else btop's default.

## Why

Shows CPU, memory, disks, network and processes on one screen, with mouse support and themes.

### Alternatives Considered

- htop: processes only, no disk or network graphs.
- Activity Monitor: not in the terminal.

## Install

`./install.sh` installs `btop` and links the config.

## Customize

Edit `home/.config/btop/btop.conf`; `btop --default-config` prints every option with its
default. Changes made in btop's options menu last only for that session: saving on exit
is off because btop would rewrite the linked file inside this repo. Turning
`save_config_on_exit` off from the menu also writes the file once.

## Verify

`./verify.sh` checks the Brewfile is satisfied and the config is linked.
