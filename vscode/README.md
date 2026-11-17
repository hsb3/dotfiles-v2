# vscode

## What

Visual Studio Code (Homebrew cask `visual-studio-code`, which also installs the `code`
launcher) with a baseline of 13 extensions and their pack members, listed in the
`Brewfile`: Python (the Python pack, ruff, ty, Jupyter), JavaScript and Go (oxc, Prettier, Go), config and docs (YAML,
TOML, Markdown), remote and Git (Dev Containers, Remote SSH, GitHub Pull Requests).
Helix stays the editor in `EDITOR`. No settings are linked: VS Code rewrites its own
`~/Library/Application Support/Code/User/settings.json`, so a linked file would be
edited inside this repo.

## Why

For work that depends on its extensions: notebooks, dev containers and remote sessions.
The baseline uses the linters and formatters the language-servers package installs, so
the editor and the command line agree.

### Alternatives Considered

- Zed: installed alongside and lighter, but without those extensions.
- VSCodium: the same editor without Microsoft's marketplace, so the Remote extensions are unavailable.
- Pylance as the Python language server: turned off below so ty is the only type checker.

## Install

`./install.sh` installs the cask, then the `Brewfile` extensions. Extensions already
installed are kept, including ones outside the baseline. Nothing is linked into `$HOME`.

## Customize

VS Code has no command-line setter for settings. Paste the baseline once per machine
(`Cmd+Shift+P`, "Open User Settings (JSON)"):

```jsonc
{
  "editor.fontFamily": "JetBrainsMono Nerd Font, monospace", "editor.fontSize": 16,
  "editor.formatOnSave": true, "editor.minimap.enabled": false, "editor.wordWrap": "on",
  "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font Mono",
  "terminal.integrated.defaultProfile.osx": "zsh", "window.restoreWindows": "none",
  "git.autofetch": true, "git.confirmSync": false, "git.openRepositoryInParentFolders": "never",
  "explorer.confirmDelete": false, "explorer.confirmDragAndDrop": false,
  "extensions.ignoreRecommendations": true,
  "python.languageServer": "None", "python.terminal.activateEnvironment": false,
  "python-envs.alwaysUseUv": true, "[python]": { "editor.defaultFormatter": "charliermarsh.ruff" }
}
```

To return to the baseline, list the extra extensions with `brew bundle cleanup --vscode
--file=Brewfile` and add `--force` to uninstall them. Project-specific extensions belong
in that project's `.vscode/extensions.json`. The cleanup also removes Pylance, which the
Python pack installs. Settings Sync can reinstall removed extensions.

## Verify

`./verify.sh` checks the cask and every `Brewfile` extension are installed.
