#!/usr/bin/env bash

(
  set -euo pipefail

  VER="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
  TMPDIR="$(mktemp -d)"

  # shellcheck disable=SC2329
  cleanup() {
    rm -rf "$TMPDIR"
  }
  trap cleanup EXIT

  cd "$TMPDIR"

  echo "Downloading kubectl ${VER}…"
  curl -LO "https://dl.k8s.io/release/${VER}/bin/linux/amd64/kubectl"

  echo "Downloading checksum…"
  curl -LO "https://dl.k8s.io/${VER}/bin/linux/amd64/kubectl.sha256"

  echo "Verifying checksum…"
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check --status

  echo "Installing to /usr/local/bin…"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  echo "kubectl ${VER} installed successfully."
)
