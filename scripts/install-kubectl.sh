#!/usr/bin/env bash

# Get the latest release version number
VER=$(curl -L -s https://dl.k8s.io/release/stable.txt)

# Download the binary
curl -LO "https://dl.k8s.io/release/${VER}/bin/linux/amd64/kubectl"

# Verify (optional but good practice)
curl -LO "https://dl.k8s.io/${VER}/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Install
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verify
kubectl version --client
