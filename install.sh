#!/usr/bin/env bash

set -e

REPO="gigagrug/idk"  # 👈 change this
VERSION="${1:-latest}"        # Use passed version or latest
INSTALL_DIR="/usr/local/bin"  # Can change to "$HOME/.local/bin" if preferred
TMP_DIR="$(mktemp -d)"

# Detect OS
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS" in
  linux*)   GOOS="linux" ;;
  darwin*)  GOOS="darwin" ;;
  msys*|mingw*|cygwin*) GOOS="windows" ;;
  *)        echo "Unsupported OS: $OS" && exit 1 ;;
esac

# Detect Arch
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)   GOARCH="amd64" ;;
  arm64|aarch64) GOARCH="arm64" ;;
  *)        echo "Unsupported architecture: $ARCH" && exit 1 ;;
esac

EXT=""
if [ "$GOOS" = "windows" ]; then EXT=".exe"; fi

FILENAME="schema-${VERSION}-${GOOS}-${GOARCH}${EXT}"
URL="https://github.com/${REPO}/releases/download/${VERSION}/${FILENAME}"

echo "🔽 Downloading $FILENAME from $URL..."
curl -sSL "$URL" -o "$TMP_DIR/schema${EXT}"

chmod +x "$TMP_DIR/schema${EXT}"

echo "🚀 Installing to $INSTALL_DIR..."
sudo mv "$TMP_DIR/schema${EXT}" "$INSTALL_DIR/schema${EXT}"

if [ "$GOOS" = "windows" ]; then
  echo "✅ Installed schema${EXT}. Add it to your PATH manually if needed."
else
  echo "✅ Installed schema. Run it with: schema"
fi

rm -rf "$TMP_DIR"

