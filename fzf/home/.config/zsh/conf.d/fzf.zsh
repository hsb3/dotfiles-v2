# fd respects .gitignore, unlike fzf's built-in walker; without fd that walker stays.
if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
fi
command -v fzf >/dev/null && source <(fzf --zsh)
