# Interactive shells. Tool setup lives in ~/.config/zsh/conf.d/*.zsh, one file per package.
HISTSIZE=1000000
SAVEHIST=1000000
setopt share_history hist_ignore_all_dups hist_ignore_space hist_find_no_dups
setopt hist_reduce_blanks hist_verify extended_history hist_fcntl_lock
# Lines over 200 characters (mostly pasted or generated) stay in this session only.
zshaddhistory() { (( ${#${1%%$'\n'}} <= 200 )) || return 2 }
setopt auto_cd interactive_comments no_case_glob
bindkey -e

# Here rather than .zprofile so nested non-login shells get them too: Homebrew's
# completions, zsh-completions (zsh-plugins package), and the ones packages generate into
# a real (unlinked) directory. zsh-completions by its opt path: compaudit rejects share/,
# which Homebrew leaves group-writable.
for d in "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions" \
  "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/zsh-completions/share/zsh-completions" \
  "$HOME/.local/share/zsh/site-functions"; do
  [[ -d $d ]] && (( ! ${fpath[(Ie)$d]} )) && fpath=("$d" $fpath)
done
unset d
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

for f in "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/conf.d/*.zsh(N); do
  source "$f"
done
unset f
