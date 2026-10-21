# Login shells: put Homebrew on PATH.
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [[ -x $brew ]]; then
    eval "$($brew shellenv)"
    break
  fi
done
unset brew
