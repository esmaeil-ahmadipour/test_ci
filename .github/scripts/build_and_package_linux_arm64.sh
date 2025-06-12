#!/usr/bin/env bash

set -euo pipefail

# --------------------------------------
# CONFIGURATION
# --------------------------------------

TAG_NAME="${1:-local}"  # Use first argument as tag or fallback to 'local'
OUTPUT_NAME="PactusGUI-${TAG_NAME}-linux-arm64.AppImage"
APPDIR="build/linux/arm64/release/bundle"
APPIMAGE_TOOL="appimagetool-aarch64.AppImage"
APPIMAGE_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/${APPIMAGE_TOOL}"

# --------------------------------------
# FUNCTIONS
# --------------------------------------

install_dependencies() {
  echo "🔧 Installing dependencies..."
  sudo apt-get update
  sudo apt-get install -y libgtk-3-dev libfuse2 cmake ninja-build wget appstream
}

build_flutter_linux() {
  echo "🔨 Building Flutter app for Linux ARM64..."
  flutter pub get
  flutter build linux --release --target-platform=linux-arm64
}

download_appimage_tool() {
  echo "⬇️ Downloading AppImage tool..."
  wget -q "$APPIMAGE_URL"
  chmod +x "$APPIMAGE_TOOL"
}

package_appimage() {
  echo "📦 Packaging AppImage as ${OUTPUT_NAME}..."
  cp linux/pactus_gui.desktop "$APPDIR/"
  cp linux/pactus_gui.png "$APPDIR/"
  ./"$APPIMAGE_TOOL" "$APPDIR" "$OUTPUT_NAME"

  mkdir -p artifacts
  mv "$OUTPUT_NAME" artifacts/
  echo "✅ AppImage saved to artifacts/${OUTPUT_NAME}"
}

# --------------------------------------
# MAIN EXECUTION
# --------------------------------------

install_dependencies
build_flutter_linux
download_appimage_tool
package_appimage
