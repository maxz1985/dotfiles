# kitty on Rocky Linux 10

This directory stores the Rocky Linux 10 `kitty` terminal configuration.

## Install `kitty`

Install `kitty`:

```shell
sudo dnf install -y kitty
```

## Copy config

From the root of this dotfiles repo:

```shell
mkdir -p ~/.config/kitty
cp linux/kitty/kitty.conf ~/.config/kitty/kitty.conf
cp linux/kitty/current-theme.conf ~/.config/kitty/current-theme.conf
```

## Reload `kitty`

Reload the config in a running `kitty` window:

```shell
kitty @ load-config
```

If remote control is not enabled, close and reopen `kitty` instead.

## Update config later

After changing `linux/kitty/kitty.conf`, copy it again and reload or restart `kitty`:

```shell
cp linux/kitty/kitty.conf ~/.config/kitty/kitty.conf
kitty @ load-config
```
