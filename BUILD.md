# Build Instructions for ChatGPT Intel

## Prerequisites

To build this macOS application, you need one of the following:

### Option 1: Full Xcode (Recommended)

1. Install Xcode from the Mac App Store
2. Launch Xcode and accept the license agreement
3. Install additional components when prompted

### Option 2: Command Line Tools Only (Limited)

If you only have command line tools installed, you can:

1. Open the project files in any text editor
2. Use the Swift files as reference for creating your own build
3. Install Xcode for full compilation support

## Building the Application

### Using Xcode (GUI)

1. Open `ChatGPT Intel.xcodeproj` in Xcode
2. Select your Intel Mac as the target device
3. Choose Product → Build (⌘+B) to build
4. Choose Product → Run (⌘+R) to build and run

### Using Command Line

```bash
# Build the project
xcodebuild -project "ChatGPT Intel.xcodeproj" \
           -scheme "ChatGPT Intel" \
           -configuration Release \
           -arch x86_64 \
           build

# Run the built application
open "build/Release/ChatGPT Intel.app"
```

### Using Make

```bash
# Build
make build

# Build and run
make run

# Clean build artifacts
make clean

# Install to Applications folder
sudo make install
```

## VS Code Integration

The project includes VS Code tasks for development:

1. **Build ChatGPT Intel**: Compiles the application
2. **Run ChatGPT Intel**: Runs the built application
3. **Clean Build**: Cleans build artifacts
4. **Build and Run**: Default task that builds and runs

Use `Cmd+Shift+P` → "Tasks: Run Task" to access these tasks.

## Troubleshooting

### "xcode-select: error: tool 'xcodebuild' requires Xcode"

This means you only have Command Line Tools installed. You need the full Xcode application:

1. Install Xcode from the Mac App Store
2. Run: `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`

### Build Errors

- Ensure you're targeting an Intel Mac (x86_64 architecture)
- Check that macOS deployment target is set to 11.0 or later
- Verify all source files are included in the Xcode project

### Runtime Issues

- Make sure you have an active internet connection
- Check that the app has necessary permissions in System Preferences → Security & Privacy
