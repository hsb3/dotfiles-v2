# Guarded on the directory, not `command -v bun`: mise puts bun on PATH in mise.zsh, which loads after this file.
[[ -d $HOME/.bun/bin ]] && { (( ${path[(Ie)$HOME/.bun/bin]} )) || path+=("$HOME/.bun/bin"); }
# Sourced, not autoloaded from fpath: the generated script ends with `compdef` rather than a
# call to _bun, so autoloading it makes the first Tab in each shell only register it.
[[ -r $HOME/.local/share/zsh/site-functions/_bun ]] &&
  source "$HOME/.local/share/zsh/site-functions/_bun"
