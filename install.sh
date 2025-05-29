#!/usr/bin/env bash

set -e

REPO="gigagrug/idk"  # ← your GitHub repo
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

# Detect Architecture
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
  INSTALL_PATH="/c/Program Files/Schema/schema.exe"
  echo "🚀 Installing to Windows path: $INSTALL_PATH"
  mkdir -p "/c/Program Files/Schema"
  mv "$TMP_DIR/schema${EXT}" "$INSTALL_PATH"
  echo "✅ Installed schema.exe to Program Files."
  echo "👉 Add 'C:\\Program Files\\Schema' to your Windows PATH if it's not already."
else
  INSTALL_DIR="/usr/local/bin"
  echo "🚀 Installing to $INSTALL_DIR..."
  sudo mv "$TMP_DIR/schema${EXT}" "$INSTALL_DIR/schema"
  echo "✅ Installed schema. Run it with: schema"
fi

rm -rf "$TMP_DIR"

