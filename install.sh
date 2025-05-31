#!/bin/sh

set -euo pipefail

REPO="gigagrug/idk"
VERSION="${1:-latest}"
TMP_DIR="$(mktemp -d)"

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS" in
  linux*)   GOOS="linux" ;;
  darwin*)  GOOS="darwin" ;;
  msys*|mingw*|cygwin*) GOOS="windows" ;;
  *)        echo "❌ Unsupported OS: $OS" && exit 1 ;;
esac

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64)   GOARCH="amd64" ;;
  arm64|aarch64) GOARCH="arm64" ;;
  *)        echo "❌ Unsupported architecture: $ARCH" && exit 1 ;;
esac

EXT=""
if [ "$GOOS" = "windows" ]; then EXT=".exe"; fi
FILENAME="schema-${GOOS}-${GOARCH}${EXT}"
URL="https://github.com/${REPO}/releases/download/${VERSION}/${FILENAME}"
echo "🔽 Downloading $FILENAME from $URL..."
curl -sSL "$URL" -o "$TMP_DIR/schema${EXT}"
chmod +x "$TMP_DIR/schema${EXT}"

if [ "$GOOS" = "windows" ]; then
  INSTALL_DIR="$HOME/bin"
  INSTALL_PATH="${INSTALL_DIR}/schema.exe"
  echo "🚀 Installing to $INSTALL_PATH..."
  mkdir -p "$INSTALL_DIR"
  mv "$TMP_DIR/schema${EXT}" "$INSTALL_PATH"
  echo "✅ Installed schema.exe to $INSTALL_PATH"
else
  INSTALL_DIR="/usr/local/bin"
  INSTALL_PATH="${INSTALL_DIR}/schema"
  echo "🚀 Installing to $INSTALL_PATH..."
  sudo mv "$TMP_DIR/schema${EXT}" "$INSTALL_PATH"
  echo "✅ Installed schema to $INSTALL_PATH"
fi

rm -rf "$TMP_DIR"
