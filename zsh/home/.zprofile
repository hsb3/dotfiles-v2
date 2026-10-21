# Login shells: put Homebrew on PATH.
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x $brew ]]; then
    eval "$($brew shellenv)"
    break
  fi
done
unset brew
# After /etc/zprofile's path_helper and Homebrew, so user binaries come first; -U drops
# the repeats a nested login shell would add.
typeset -U path
path=("$HOME/.local/bin" $path)
