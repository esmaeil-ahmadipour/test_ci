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

PACTUS_CLI_URL="https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_linux_arm64.tar.gz"
PACTUS_CLI_DEST="lib/src/core/native_resources/linux/"

# --------------------------------------
# FUNCTIONS
# --------------------------------------

install_dependencies() {
  echo "🔧 Installing dependencies..."
  sudo apt-get update
  sudo apt-get install -y libgtk-3-dev libfuse2 cmake ninja-build wget appstream tar tree
}

download_and_extract_pactus_cli() {
  echo "⬇️ Downloading Pactus CLI..."
  mkdir -p "$PACTUS_CLI_DEST"
  wget -q "$PACTUS_CLI_URL" -O /tmp/pactus-cli.tar.gz

  echo "📦 Extracting Pactus CLI to $PACTUS_CLI_DEST"
  tar -xzf /tmp/pactus-cli.tar.gz -C "$PACTUS_CLI_DEST"

  echo "✅ Extracted files:"
  ls -lh "$PACTUS_CLI_DEST"
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

inspect_appimage_contents() {
  echo "🔍 Extracting and inspecting AppImage contents..."
  mkdir -p extracted_appimage
  ./artifacts/"$OUTPUT_NAME" --appimage-extract > /dev/null
  mv squashfs-root extracted_appimage/
  echo "📁 Contents of AppImage:"
  tree extracted_appimage/squashfs-root
}

# --------------------------------------
# MAIN EXECUTION
# --------------------------------------

install_dependencies
download_and_extract_pactus_cli
build_flutter_linux
download_appimage_tool
package_appimage
inspect_appimage_contents

##!/usr/bin/env bash
#
#set -euo pipefail
#
## --------------------------------------
## CONFIGURATION
## --------------------------------------
#
#TAG_NAME="${1:-local}"  # Use first argument as tag or fallback to 'local'
#OUTPUT_NAME="PactusGUI-${TAG_NAME}-linux-arm64.AppImage"
#APPDIR="build/linux/arm64/release/bundle"
#APPIMAGE_TOOL="appimagetool-aarch64.AppImage"
#APPIMAGE_URL="https://github.com/AppImage/AppImageKit/releases/download/continuous/${APPIMAGE_TOOL}"
#
#PACTUS_CLI_URL="https://github.com/pactus-project/pactus/releases/download/v1.7.1/pactus-cli_1.7.1_linux_arm64.tar.gz"
#PACTUS_CLI_DEST="lib/src/core/native_resources/linux/"
#
## --------------------------------------
## FUNCTIONS
## --------------------------------------
#
#install_dependencies() {
#  echo "🔧 Installing dependencies..."
#  sudo apt-get update
#  sudo apt-get install -y libgtk-3-dev libfuse2 cmake ninja-build wget appstream tar
#}
#
#download_and_extract_pactus_cli() {
#  echo "⬇️ Downloading Pactus CLI..."
#  mkdir -p "$PACTUS_CLI_DEST"
#  wget -q "$PACTUS_CLI_URL" -O /tmp/pactus-cli.tar.gz
#
#  echo "📦 Extracting Pactus CLI to $PACTUS_CLI_DEST"
#  tar -xzf /tmp/pactus-cli.tar.gz -C "$PACTUS_CLI_DEST"
#
#  echo "✅ Extracted files:"
#  ls -lh "$PACTUS_CLI_DEST"
#}
#
#build_flutter_linux() {
#  echo "🔨 Building Flutter app for Linux ARM64..."
#  flutter pub get
#  flutter build linux --release --target-platform=linux-arm64
#}
#
#download_appimage_tool() {
#  echo "⬇️ Downloading AppImage tool..."
#  wget -q "$APPIMAGE_URL"
#  chmod +x "$APPIMAGE_TOOL"
#}
#
#package_appimage() {
#  echo "📦 Packaging AppImage as ${OUTPUT_NAME}..."
#  cp linux/pactus_gui.desktop "$APPDIR/"
#  cp linux/pactus_gui.png "$APPDIR/"
#  ./"$APPIMAGE_TOOL" "$APPDIR" "$OUTPUT_NAME"
#
#  mkdir -p artifacts
#  mv "$OUTPUT_NAME" artifacts/
#  echo "✅ AppImage saved to artifacts/${OUTPUT_NAME}"
#}
#
## --------------------------------------
## MAIN EXECUTION
## --------------------------------------
#
#install_dependencies
#download_and_extract_pactus_cli
#build_flutter_linux
#download_appimage_tool
#package_appimage
