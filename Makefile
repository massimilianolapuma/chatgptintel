# Makefile for ChatGPT Intel macOS App
# Provides simple commands for building and running the app

PROJECT_NAME = ChatGPT Intel
SCHEME = ChatGPT Intel
CONFIGURATION = Release
ARCH = x86_64
BUILD_DIR = build/$(CONFIGURATION)
APP_NAME = $(PROJECT_NAME).app

.PHONY: all build clean run install help

# Default target
all: build

# Build the application
build:
	@echo "🔧 Building $(PROJECT_NAME) for Intel Macs..."
	xcodebuild -project "$(PROJECT_NAME).xcodeproj" \
	           -scheme "$(SCHEME)" \
	           -configuration $(CONFIGURATION) \
	           -arch $(ARCH) \
	           build

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	xcodebuild -project "$(PROJECT_NAME).xcodeproj" \
	           -scheme "$(SCHEME)" \
	           clean
	rm -rf build/

# Run the application
run: build
	@echo "🚀 Launching $(PROJECT_NAME)..."
	open "$(BUILD_DIR)/$(APP_NAME)"

# Install to Applications folder (requires sudo)
install: build
	@echo "📱 Installing $(PROJECT_NAME) to Applications..."
	sudo cp -R "$(BUILD_DIR)/$(APP_NAME)" /Applications/

# Show help
help:
	@echo "Available targets:"
	@echo "  build    - Build the application"
	@echo "  clean    - Clean build artifacts"
	@echo "  run      - Build and run the application"
	@echo "  install  - Install to /Applications (requires sudo)"
	@echo "  help     - Show this help message"
