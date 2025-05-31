#!/bin/bash

# Setup script for ChatGPT Intel macOS app
# This script helps prepare the development environment

set -e

echo "🚀 ChatGPT Intel Setup Script"
echo "=============================="

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This script requires macOS"
    exit 1
fi

# Check if we're on Intel Mac
ARCH=$(uname -m)
if [[ "$ARCH" != "x86_64" ]]; then
    echo "⚠️  Warning: This app is designed for Intel Macs (x86_64)"
    echo "   Current architecture: $ARCH"
    echo "   The app may still work but is optimized for Intel"
fi

# Check for Xcode
echo "🔍 Checking for Xcode..."
if command -v xcodebuild &>/dev/null; then
    XCODE_PATH=$(xcode-select -p)
    echo "✅ Xcode found at: $XCODE_PATH"

    # Check if it's the command line tools only
    if [[ "$XCODE_PATH" == "/Library/Developer/CommandLineTools" ]]; then
        echo "⚠️  Warning: Only Command Line Tools detected"
        echo "   For best experience, install full Xcode from the Mac App Store"
        echo "   Then run: sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
    fi
else
    echo "❌ Xcode not found!"
    echo "   Please install Xcode from the Mac App Store"
    echo "   Or install Command Line Tools: xcode-select --install"
    exit 1
fi

# Check project structure
echo "🔍 Validating project structure..."
REQUIRED_FILES=(
    "ChatGPT Intel.xcodeproj/project.pbxproj"
    "ChatGPT Intel/AppDelegate.swift"
    "ChatGPT Intel/ViewController.swift"
    "ChatGPT Intel/Info.plist"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo "✅ Found: $file"
    else
        echo "❌ Missing: $file"
        exit 1
    fi
done

# Try to build the project
echo "🔨 Attempting to build the project..."
if xcodebuild -project "ChatGPT Intel.xcodeproj" -scheme "ChatGPT Intel" -configuration Release -arch x86_64 build &>/dev/null; then
    echo "✅ Build successful!"
    echo "📱 App built at: build/Release/ChatGPT Intel.app"

    # Ask if user wants to run the app
    read -p "🚀 Would you like to launch the app now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 Launching ChatGPT Intel..."
        open "build/Release/ChatGPT Intel.app"
    fi
else
    echo "❌ Build failed"
    echo "   Try opening the project in Xcode for detailed error information:"
    echo "   open 'ChatGPT Intel.xcodeproj'"
    exit 1
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo "• Open 'ChatGPT Intel.xcodeproj' in Xcode for development"
echo "• Use 'make build' or './build.sh' to build from command line"
echo "• Use VS Code tasks (Cmd+Shift+P → 'Tasks: Run Task') if using VS Code"
echo "• Read BUILD.md for detailed build instructions"
