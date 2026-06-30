# keyd on Rocky Linux 10

This directory stores the Rocky Linux 10 `keyd` keyboard remap configuration.

## Install `keyd`

Install the build tools:

```shell
sudo dnf install -y git gcc make
```

Build and install `keyd` from upstream:

```shell
git clone https://github.com/rvaiya/keyd.git
cd keyd
make
sudo make install
```

Enable the `keyd` service:

```shell
sudo systemctl enable keyd
```

## Copy config

From the root of this dotfiles repo:

```shell
sudo mkdir -p /etc/keyd
sudo cp ~/dotfiles/linux/keyd/default.conf /etc/keyd/default.conf
```

## Restart `keyd`

Restart the service after copying the config:

```shell
sudo systemctl restart keyd
```

Check that it is running:

```shell
sudo systemctl status keyd
```

## Update config later

After changing `linux/keyd/default.conf`, copy it again and restart `keyd`:

```shell
sudo cp linux/keyd/default.conf /etc/keyd/default.conf
sudo systemctl restart keyd
```
