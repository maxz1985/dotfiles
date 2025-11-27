# dotfiles
## Repo structure
```
dotfiles/
  README.md

  scripts/
    install-windows.ps1
    install-macos.sh
    install-linux.sh

  windows/
    terminal/
      settings.json                  # Windows Terminal settings
    powershell/
      Microsoft.PowerShell_profile.ps1
      # optionally: profile for pwsh vs WindowsPowerShell separately

  macos/
    iterm2/
      profiles.json                  # or exported plist / color schemes
    zsh/
      .zshrc
      .zprofile

  linux/
    bash/
      .bashrc
      .bash_profile

  shared/
    shell/
      aliases.sh                     # shared between bash/zsh/etc.
      functions.sh
    oh-my-posh/
      devops.omp.json                # your main theme/config
      segments/                      # optional: custom segment configs
      themes/                        # optional: additional themes
```
## oh-my-posh windows
```PowerShell
cd $HOME
git clone https://github.com/maxz1985/dotfiles.git
```