# Interactive shells. Tool setup lives in ~/.config/zsh/conf.d/*.zsh, one file per package.
HISTSIZE=50000
SAVEHIST=50000
setopt share_history hist_ignore_all_dups hist_ignore_space
setopt auto_cd interactive_comments
bindkey -e

autoload -Uz compinit && compinit

for f in "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/conf.d/*.zsh(N); do
  source "$f"
done
unset f
