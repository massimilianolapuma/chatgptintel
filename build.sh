#!/bin/bash

# Build script for ChatGPT Intel macOS app
# This script builds the app for Intel Macs (x86_64 architecture)

set -e

PROJECT_NAME="ChatGPT Intel"
SCHEME="ChatGPT Intel"
CONFIGURATION="Release"
ARCH="x86_64"

echo "🔧 Building $PROJECT_NAME for Intel Macs..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
xcodebuild -project "$PROJECT_NAME.xcodeproj" -scheme "$SCHEME" clean

# Build the project
echo "🔨 Building project..."
xcodebuild -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration $CONFIGURATION \
    -arch $ARCH \
    build

echo "✅ Build completed successfully!"
echo "📱 App location: build/$CONFIGURATION/$PROJECT_NAME.app"

# Optional: Open the build folder
if command -v open &>/dev/null; then
    echo "📂 Opening build folder..."
    open "build/$CONFIGURATION/"
fi
