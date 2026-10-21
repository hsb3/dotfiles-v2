# Unconditional: pnpm comes from mise, which activates after this file, and pnpm refuses
# `add -g` until its bin directory is on PATH, so the entry cannot wait for the directory.
export PNPM_HOME="$HOME/Library/pnpm"
(( ${path[(Ie)$PNPM_HOME/bin]} )) || path+=("$PNPM_HOME/bin")
# Sourced, not autoloaded from fpath: the generated script ends with `compdef` rather than a
# call to _pnpm_completion, so autoloading it makes the first Tab in each shell only register it.
[[ -r $HOME/.local/share/zsh/site-functions/_pnpm ]] &&
  source "$HOME/.local/share/zsh/site-functions/_pnpm"
