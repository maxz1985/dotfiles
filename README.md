# dotfiles

## Repo structure

> [!NOTE]
> In the repo structure below, the files/folders that HAVE A COMMENT exist in the repo and are used for stated purpose.

```text
dotfiles/
  README.md

  scripts/
    install-windows.ps1             # Windows - install Powershell Profile
    install-macos.sh
    install-linux.sh
    install-kubectl.sh              # Linux - install kubectl

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
    keyd/
      default.con                   # keyd key re-mapper configuration
      README>MD                     # keyd Documentation
    kitty/
      kitty.conf                    # kitty terminal configuration file

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

```powershell
. "$HOME\dotfiles\scripts\install-windows.ps1"
```

On `Windows`, put your local machine-specific settings `$HOME\PowerShellProfile.ps1`.

If `$HOME\PowerShellProfile.ps1` file exists, it will be read and applied after default `profile.ps1`

## macOS install the zsh config

Use tiny loader in your `.zshrc`

Replace the content of `.zshrc` with

```shell
source "$HOME/dotfiles/macos/zsh/.zshrc"
```

Put your local machine-specific settings `$HOME/.zshrc.local`.

If `$HOME/.zshrc.local` file exists, it will be read and applied after `$HOME/.zshrc`

## Linux prep

Install `unzip`

```shell
sudo dnf install unzip -y
```

Install `oh-my-posh`

```shell
curl -s https://ohmyposh.dev/install.sh | bash -s
```

## Linux install bash config

Use tiny loader in your `.bashrc`.

Add the following to the end of your default `.bashrc` file:

```shell
source "$HOME/dotfiles/linux/bash/.bashrc"
```

Put your local machine-specific settings `$HOME/.bashrc.local`.

If `$HOME/.bashrc.local` file exists, it will be read and applied after `$HOME/.bashrc`

## `oh-my-posh` font

Best font to use with `oh-my-posh` is `MesloLGM Nerd Font`.
