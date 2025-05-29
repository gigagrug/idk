#!/usr/bin/env bash

set -euo pipefail

REPO="gigagrug/idk"
VERSION="${1:-latest}"
TMP_DIR="$(mktemp -d)"

# Detect OS
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS" in
  linux*)   GOOS="linux" ;;
  darwin*)  GOOS="darwin" ;;
  msys*|mingw*|cygwin*) GOOS="windows" ;;
  *)        echo "❌ Unsupported OS: $OS" && exit 1 ;;
esac

# Detect Arch
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)   GOARCH="amd64" ;;
  arm64|aarch64) GOARCH="arm64" ;;
  *)        echo "❌ Unsupported architecture: $ARCH" && exit 1 ;;
esac

EXT=""
if [ "$GOOS" = "windows" ]; then EXT=".exe"; fi

FILENAME="schema-${VERSION}-${GOOS}-${GOARCH}${EXT}"
URL="https://github.com/${REPO}/releases/download/${VERSION}/${FILENAME}"

echo "🔽 Downloading $FILENAME from $URL..."
curl -sSL "$URL" -o "$TMP_DIR/schema${EXT}"

chmod +x "$TMP_DIR/schema${EXT}"

# Set install path
if [ "$GOOS" = "windows" ]; then
  INSTALL_DIR="/c/Program Files/Schema"
  INSTALL_PATH="${INSTALL_DIR}/schema.exe"
  echo "🚀 Installing to $INSTALL_PATH..."
  mkdir -p "'$INSTALL_DIR'"
  mv "$TMP_DIR/schema${EXT}" "$INSTALL_PATH"
  echo "✅ Installed to C:\\Program Files\\Schema\\schema.exe"
  echo "👉 Add 'C:\\Program Files\\Schema' to your Windows PATH if it's not already."
else
  INSTALL_DIR="/usr/local/bin"
  INSTALL_PATH="${INSTALL_DIR}/schema"
  echo "🚀 Installing to $INSTALL_PATH..."
  sudo mv "$TMP_DIR/schema${EXT}" "$INSTALL_PATH"
  echo "✅ Installed schema to $INSTALL_PATH"
fi

rm -rf "$TMP_DIR"


