# Guarded on the directory, not `command -v bun`: mise puts bun on PATH in mise.zsh, which loads after this file.
[[ -d $HOME/.bun/bin ]] && { (( ${path[(Ie)$HOME/.bun/bin]} )) || path+=("$HOME/.bun/bin"); }
