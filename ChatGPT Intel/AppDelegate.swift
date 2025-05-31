//
//  AppDelegate.swift
//  ChatGPT Intel
//
//  Created on 30/05/2025.
//

import Cocoa
import WebKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Configure the app to show the main window on launch
        setupMenuBar()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    private func setupMenuBar() {
        // Create the main menu
        let mainMenu = NSMenu()
        
        // App menu
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        
        let appMenu = NSMenu()
        appMenuItem.submenu = appMenu
        
        appMenu.addItem(NSMenuItem(title: "About ChatGPT Intel", action: #selector(showAbout), keyEquivalent: ""))
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(NSMenuItem(title: "Hide ChatGPT Intel", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h"))
        let hideOthersItem = NSMenuItem(title: "Hide Others", action: #selector(NSApplication.hideOtherApplications(_:)), keyEquivalent: "h")
        hideOthersItem.keyEquivalentModifierMask = [.command, .option]
        appMenu.addItem(hideOthersItem)
        appMenu.addItem(NSMenuItem(title: "Show All", action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: ""))
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(NSMenuItem(title: "Quit ChatGPT Intel", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        // File menu
        let fileMenuItem = NSMenuItem()
        mainMenu.addItem(fileMenuItem)
        
        let fileMenu = NSMenu(title: "File")
        fileMenuItem.submenu = fileMenu
        
        fileMenu.addItem(NSMenuItem(title: "New Conversation", action: #selector(newConversation), keyEquivalent: "n"))
        fileMenu.addItem(NSMenuItem.separator())
        fileMenu.addItem(NSMenuItem(title: "Close Window", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w"))
        
        // Edit menu
        let editMenuItem = NSMenuItem()
        mainMenu.addItem(editMenuItem)
        
        let editMenu = NSMenu(title: "Edit")
        editMenuItem.submenu = editMenu
        
        let undoItem = NSMenuItem(title: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
        undoItem.target = nil
        editMenu.addItem(undoItem)
        
        let redoItem = NSMenuItem(title: "Redo", action: Selector(("redo:")), keyEquivalent: "Z")
        redoItem.target = nil
        editMenu.addItem(redoItem)
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(NSMenuItem(title: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x"))
        editMenu.addItem(NSMenuItem(title: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c"))
        editMenu.addItem(NSMenuItem(title: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v"))
        editMenu.addItem(NSMenuItem(title: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a"))
        
        // View menu
        let viewMenuItem = NSMenuItem()
        mainMenu.addItem(viewMenuItem)
        
        let viewMenu = NSMenu(title: "View")
        viewMenuItem.submenu = viewMenu
        
        viewMenu.addItem(NSMenuItem(title: "Reload", action: #selector(reloadPage), keyEquivalent: "r"))
        viewMenu.addItem(NSMenuItem(title: "Go Back", action: #selector(goBack), keyEquivalent: "["))
        viewMenu.addItem(NSMenuItem(title: "Go Forward", action: #selector(goForward), keyEquivalent: "]"))
        viewMenu.addItem(NSMenuItem.separator())
        viewMenu.addItem(NSMenuItem(title: "Actual Size", action: #selector(resetZoom), keyEquivalent: "0"))
        viewMenu.addItem(NSMenuItem(title: "Zoom In", action: #selector(zoomIn), keyEquivalent: "+"))
        viewMenu.addItem(NSMenuItem(title: "Zoom Out", action: #selector(zoomOut), keyEquivalent: "-"))
        
        // Window menu
        let windowMenuItem = NSMenuItem()
        mainMenu.addItem(windowMenuItem)
        
        let windowMenu = NSMenu(title: "Window")
        windowMenuItem.submenu = windowMenu
        
        windowMenu.addItem(NSMenuItem(title: "Minimize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m"))
        windowMenu.addItem(NSMenuItem(title: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: ""))
        windowMenu.addItem(NSMenuItem.separator())
        windowMenu.addItem(NSMenuItem(title: "Bring All to Front", action: #selector(NSApplication.arrangeInFront(_:)), keyEquivalent: ""))
        
        NSApplication.shared.mainMenu = mainMenu
    }
    
    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "ChatGPT Intel"
        alert.informativeText = "A macOS Intel wrapper for ChatGPT\nVersion 1.0\n\nThis unofficial app provides access to ChatGPT on Intel-based Macs."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc private func newConversation() {
        if let viewController = NSApplication.shared.mainWindow?.contentViewController,
           let webView = viewController.view.subviews.first(where: { $0 is WKWebView }) as? WKWebView {
            if let url = URL(string: "https://chat.openai.com") {
                var request = URLRequest(url: url)
                request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
                webView.load(request)
            }
        }
    }
    
    @objc private func reloadPage() {
        if let viewController = NSApplication.shared.mainWindow?.contentViewController,
           let webView = viewController.view.subviews.first(where: { $0 is WKWebView }) as? WKWebView {
            webView.reload()
        }
    }
    
    @objc private func goBack() {
        if let viewController = NSApplication.shared.mainWindow?.contentViewController,
           let webView = viewController.view.subviews.first(where: { $0 is WKWebView }) as? WKWebView {
            webView.goBack()
        }
    }
    
    @objc private func goForward() {
        if let viewController = NSApplication.shared.mainWindow?.contentViewController,
           let webView = viewController.view.subviews.first(where: { $0 is WKWebView }) as? WKWebView {
            webView.goForward()
        }
    }
    
    @objc private func resetZoom() {
        if let viewController = NSApplication.shared.mainWindow?.contentViewController,
           let webView = viewController.view.subviews.first(where: { $0 is WKWebView }) as? WKWebView {
            webView.magnification = 1.0
        }
    }
    
    @objc private func zoomIn() {
        if let viewController = NSApplication.shared.mainWindow?.contentViewController,
           let webView = viewController.view.subviews.first(where: { $0 is WKWebView }) as? WKWebView {
            webView.magnification += 0.1
        }
    }
    
    @objc private func zoomOut() {
        if let viewController = NSApplication.shared.mainWindow?.contentViewController,
           let webView = viewController.view.subviews.first(where: { $0 is WKWebView }) as? WKWebView {
            webView.magnification -= 0.1
        }
    }
}
