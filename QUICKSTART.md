# Quick Start Guide

## 🚀 Get Started in 3 Steps

### 1. Install Xcode

Download and install Xcode from the Mac App Store (required for building).

### 2. Run Setup

```bash
./setup.sh
```

### 3. Open & Build

```bash
# Option A: Use Xcode (Recommended)
open "ChatGPT Intel.xcodeproj"

# Option B: Command Line
xcodebuild -project "ChatGPT Intel.xcodeproj" -scheme "ChatGPT Intel" -configuration Release build
open "build/Release/ChatGPT Intel.app"
```

## 📁 Project Structure

```
ChatGPT Intel/
├── AppDelegate.swift          # Main app controller & menu setup
├── ViewController.swift       # WebView controller for ChatGPT
├── Main.storyboard           # Interface layout
├── Info.plist               # App configuration
└── Assets.xcassets/         # App icons and colors
```

## 🔧 Development

- **Xcode**: Full IDE experience with debugging
- **VS Code**: Use tasks (Cmd+Shift+P → "Tasks: Run Task")
- **Command Line**: Use `make build` or `./build.sh`

## 📖 Documentation

- `README.md` - Complete documentation
- `BUILD.md` - Detailed build instructions
- `.github/copilot-instructions.md` - Coding guidelines

## 🎯 What This App Does

Creates a native macOS wrapper for ChatGPT that:

- ✅ Works on Intel Macs (where official app doesn't)
- ✅ Provides native macOS experience
- ✅ Uses WebKit for optimal performance
- ✅ Includes proper menu bar and keyboard shortcuts
- ✅ Runs in sandboxed environment for security

Happy coding! 🎉
