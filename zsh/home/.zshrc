# Interactive shells. Tool setup lives in ~/.config/zsh/conf.d/*.zsh, one file per package.
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space
setopt auto_cd interactive_comments
bindkey -e

# Here rather than .zprofile so nested non-login shells get them too: Homebrew's
# completions, and the ones packages generate into a real (unlinked) directory.
for d in "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions" \
  "$HOME/.local/share/zsh/site-functions"; do
  [[ -d $d ]] && (( ! ${fpath[(Ie)$d]} )) && fpath=("$d" $fpath)
done
unset d
autoload -Uz compinit && compinit

for f in "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/conf.d/*.zsh(N); do
  source "$f"
done
unset f
