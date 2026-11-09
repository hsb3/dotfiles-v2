# The name sorts after every other conf.d file: syntax highlighting must load last, after
# compinit (.zshrc) and after other packages define their widgets. fzf-tab goes first.
() {
  local p=${HOMEBREW_PREFIX:-/opt/homebrew}
  if [[ -r $p/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh ]]; then
    source $p/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh
    zstyle ':completion:*' menu no # let fzf-tab own the menu
    command -v eza >/dev/null &&
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always -- "$realpath"'
  fi
  [[ -r $p/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
    source $p/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  [[ -r $p/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
    source $p/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
}
