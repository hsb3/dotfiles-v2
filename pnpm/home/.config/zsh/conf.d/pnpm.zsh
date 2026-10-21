# Unconditional: pnpm comes from mise, which activates after this file, and pnpm refuses
# `add -g` until its bin directory is on PATH, so the entry cannot wait for the directory.
export PNPM_HOME="$HOME/Library/pnpm"
(( ${path[(Ie)$PNPM_HOME/bin]} )) || path+=("$PNPM_HOME/bin")
