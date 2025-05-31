# ChatGPT Intel - macOS Intel Wrapper

A native macOS application that wraps the ChatGPT website for Intel-based Macs. Since the official ChatGPT app is only available for Apple Silicon, this app provides Intel Mac users with a native desktop experience for ChatGPT.

## Features

- **Native macOS Experience**: Full integration with macOS including menu bar, keyboard shortcuts, and window management
- **Intel Mac Optimized**: Specifically built and configured for Intel-based Macs
- **WebKit Integration**: Uses macOS's native WebKit framework for optimal performance and security
- **Desktop UI**: Forces desktop version of ChatGPT interface (no mobile redirects)
- **Privacy Focused**: Runs in sandboxed environment with minimal permissions
- **Keyboard Shortcuts**: Standard macOS shortcuts for navigation, zoom, and app management

## System Requirements

- macOS 11.0 (Big Sur) or later
- Intel-based Mac (x86_64 architecture)
- Internet connection for accessing ChatGPT

## Installation

### Prerequisites

**Important**: This project requires Xcode (not just Command Line Tools) to build the macOS application.

1. **Install Xcode**: Download and install Xcode from the Mac App Store
2. **Accept License**: Launch Xcode and accept the license agreement
3. **Command Line Tools**: Run `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`

### Option 1: Build with Xcode (Recommended)

1. **Open Project**:

   ```bash
   open "ChatGPT Intel.xcodeproj"
   ```

2. **Build in Xcode**:
   - Select your Intel Mac as the target
   - Choose Product → Build (⌘+B)
   - Choose Product → Run (⌘+R) to launch

### Option 2: Build with Command Line

```bash
# Ensure Xcode is properly configured
xcode-select --install  # If needed
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# Build the project
xcodebuild -project "ChatGPT Intel.xcodeproj" \
           -scheme "ChatGPT Intel" \
           -configuration Release \
           -arch x86_64 \
           build

# Run the built app
open "build/Release/ChatGPT Intel.app"
```

### Option 3: Using VS Code Tasks

If you're using VS Code:

1. Open the project folder in VS Code
2. Press `Cmd+Shift+P` → "Tasks: Run Task"
3. Select "Build and Run" (requires Xcode installed)

## Usage

1. **Launch the App**: Double-click the built `ChatGPT Intel.app`
2. **Login**: The app will load ChatGPT's login page where you can sign in with your OpenAI account
3. **Navigation**: Use standard browser-like navigation:
   - `⌘+R` to reload
   - `⌘+[` and `⌘+]` for back/forward
   - `⌘+0` to reset zoom
   - `⌘++` and `⌘+-` to zoom in/out

## Menu Options

- **File Menu**: New Conversation, Close Window
- **Edit Menu**: Standard text editing commands (Copy, Paste, etc.)
- **View Menu**: Reload, Navigation, Zoom controls
- **Window Menu**: Minimize, Zoom, window management

## Security & Privacy

- The app uses macOS's App Sandbox for security
- Network access is limited to ChatGPT and related OpenAI domains
- No data is stored locally beyond standard web caching
- JavaScript execution is sandboxed within WebKit

## Architecture

- **Language**: Swift 5.0+
- **Framework**: AppKit (native macOS)
- **Web Engine**: WebKit (WKWebView)
- **Target**: Intel Macs (x86_64)
- **Minimum macOS**: 11.0 (Big Sur)

## Key Files

- `AppDelegate.swift`: Main app delegate with menu setup
- `ViewController.swift`: WebView controller with ChatGPT integration
- `Main.storyboard`: Interface Builder storyboard
- `Info.plist`: App configuration and permissions
- `ChatGPT_Intel.entitlements`: Sandbox and security settings

## Customization

### Changing the URL

To point to a different ChatGPT instance or URL, modify the `loadChatGPT()` function in `ViewController.swift`:

```swift
guard let url = URL(string: "https://your-custom-chatgpt-url.com") else {
    showError("Invalid URL")
    return
}
```

### Custom User Agent

The app uses a custom user agent to ensure desktop experience. Modify it in `setupWebView()`:

```swift
webView.customUserAgent = "Your Custom User Agent String"
```

## Troubleshooting

### Common Issues

1. **App won't launch**: Ensure you're running on an Intel Mac with macOS 11.0+
2. **WebView appears blank**: Check your internet connection and try reloading (⌘+R)
3. **Mobile version loads**: The app should automatically force desktop version, but you can reload if needed

### Debug Mode

In debug builds, the app enables WebKit developer tools. Right-click in the web view and select "Inspect Element" to debug web content.

## Building for Distribution

To create a distributable version:

1. **Archive the App**:

   ```bash
   xcodebuild -project "ChatGPT Intel.xcodeproj" -scheme "ChatGPT Intel" -configuration Release ARCHS=x86_64 archive -archivePath "ChatGPT Intel.xcarchive"
   ```

2. **Export for Distribution**:
   - Open Xcode Organizer
   - Select the archive
   - Choose "Distribute App"
   - Select appropriate distribution method

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on Intel Mac
5. Submit a pull request

## License

This project is provided as-is for educational and personal use. OpenAI and ChatGPT are trademarks of OpenAI Inc.

## Disclaimer

This is an unofficial wrapper application. It is not affiliated with, endorsed by, or connected to OpenAI Inc. Use of ChatGPT through this app is subject to OpenAI's Terms of Service and Privacy Policy.

## Support

For issues with the wrapper app itself, please open an issue in this repository. For ChatGPT-related issues, please contact OpenAI support directly.
