# Unconditional: `bun add -g` creates ~/.bun/bin on first use, and a shell started before
# then would otherwise never see the packages it links there.
(( ${path[(Ie)$HOME/.bun/bin]} )) || path+=("$HOME/.bun/bin")
# Sourced, not autoloaded from fpath: the generated script ends with `compdef` rather than a
# call to _bun, so autoloading it makes the first Tab in each shell only register it.
[[ -r $HOME/.local/share/zsh/site-functions/_bun ]] &&
  source "$HOME/.local/share/zsh/site-functions/_bun"
