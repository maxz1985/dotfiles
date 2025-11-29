# dotfiles
## Repo structure
```
dotfiles/
  README.md

  scripts/
    install-windows.ps1             # install Powershell Profile on Windows
    install-macos.sh
    install-linux.sh

  windows/
    terminal/
      settings.json                  # Windows Terminal settings
    powershell/
      Profile.ps1                    # PowerShell Profile
      # optionally: profile for pwsh vs WindowsPowerShell separately

  macos/
    iterm2/
      profiles.json                  # or exported plist / color schemes
    zsh/
      .zshrc                         # zsh config
      .zprofile

  linux/
    bash/
      .bashrc                       # bash config
      .bash_profile

  shared/
    shell/
      aliases.sh                     # shared between bash/zsh/etc.
      functions.sh
    oh-my-posh/
      devops.omp.json                # oh-my-posh config
      segments/                      # optional: custom segment configs
      themes/                        # optional: additional themes
```

## Clone the repo
```shell
cd $HOME
git clone https://github.com/maxz1985/dotfiles.git
```
## Install PowerShell profile on Windows
```shell
. "$HOME\dotfiles\scripts\install-windows.ps1"
```

## macOS install zsh config
Use tiny loader in your .zshrc

Replace the content of `.zshrc` with
```shell
source "$HOME/dotfiles/macos/zsh/.zshrc"
```

## Linux install bash config
Use tiny loader in your .bashrc

Replace the content of `.bashrc` with
```shell
source "$HOME/dotfiles/linux/bash/.bashrc"
```
