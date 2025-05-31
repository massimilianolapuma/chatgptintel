//
//  ViewController.swift
//  ChatGPT Intel
//
//  Created on 30/05/2025.
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet var webView: WKWebView!
    private var progressIndicator: NSProgressIndicator?
    private var retryCount = 0
    private let maxRetries = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupProgressIndicator()
        loadChatGPT()
    }
    
    private func setupWebView() {
        if webView == nil {
            // Create WebView programmatically if not connected via storyboard
            let configuration = WKWebViewConfiguration()
            
            // Enable developer tools in debug builds
            #if DEBUG
            configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
            #endif
            
            // Configure preferences for better compatibility
            configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
            
            // Allow mixed content and improve compatibility
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
            
            // Configure user agent to avoid mobile version
            configuration.applicationNameForUserAgent = "Version/17.0 Safari/605.1.15"
            
            let newWebView = WKWebView(frame: view.bounds, configuration: configuration)
            newWebView.autoresizingMask = [.width, .height]
            view.addSubview(newWebView)
            webView = newWebView
        }
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsMagnification = true
        webView.allowsBackForwardNavigationGestures = true
        
        // Set up custom user agent to ensure desktop version - use a more standard Safari user agent
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
    }
    
    private func setupProgressIndicator() {
        progressIndicator = NSProgressIndicator()
        progressIndicator?.style = .spinning
        progressIndicator?.isDisplayedWhenStopped = false
        progressIndicator?.translatesAutoresizingMaskIntoConstraints = false
        
        if let indicator = progressIndicator {
            view.addSubview(indicator)
            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
    
    func loadChatGPT() {
        retryCount = 0
        performChatGPTLoad()
    }
    
    private func performChatGPTLoad() {
        guard let url = URL(string: "https://chat.openai.com") else {
            showError("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.setValue("en-US,en;q=0.5", forHTTPHeaderField: "Accept-Language")
        request.setValue("gzip, deflate, br", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("1", forHTTPHeaderField: "Upgrade-Insecure-Requests")
        
        print("Loading ChatGPT with URL: \(url) (attempt \(retryCount + 1))")
        webView.load(request)
    }
    
    private func showError(_ message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = message
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressIndicator?.startAnimation(nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressIndicator?.stopAnimation(nil)
        retryCount = 0 // Reset retry count on successful load
        
        // Inject CSS to improve the experience
        let css = """
        /* Hide mobile app promotion banners */
        .mobile-app-banner,
        .app-download-banner,
        [data-testid="mobile-app-banner"] {
            display: none !important;
        }
        
        /* Ensure proper desktop layout */
        body {
            overflow-x: hidden;
        }
        
        /* Custom scrollbar for better macOS integration */
        ::-webkit-scrollbar {
            width: 12px;
        }
        
        ::-webkit-scrollbar-track {
            background: transparent;
        }
        
        ::-webkit-scrollbar-thumb {
            background: rgba(0,0,0,0.3);
            border-radius: 6px;
        }
        
        ::-webkit-scrollbar-thumb:hover {
            background: rgba(0,0,0,0.5);
        }
        """
        
        let script = """
        var style = document.createElement('style');
        style.textContent = `\(css)`;
        document.head.appendChild(style);
        
        // Remove any mobile app prompts
        function removeMobilePrompts() {
            const selectors = [
                '.mobile-app-banner',
                '.app-download-banner',
                '[data-testid="mobile-app-banner"]',
                '.download-app-prompt'
            ];
            
            selectors.forEach(selector => {
                const elements = document.querySelectorAll(selector);
                elements.forEach(el => el.remove());
            });
        }
        
        // Run immediately and on DOM changes
        removeMobilePrompts();
        
        const observer = new MutationObserver(removeMobilePrompts);
        observer.observe(document.body, { childList: true, subtree: true });
        """
        
        webView.evaluateJavaScript(script) { _, error in
            if let error = error {
                print("JavaScript injection error: \(error)")
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressIndicator?.stopAnimation(nil)
        
        // Check if it's a frame load interrupted error and try to reload
        let nsError = error as NSError
        if nsError.code == NSURLErrorCancelled && retryCount < maxRetries {
            // Frame load interrupted - this is often due to redirects or security policies
            retryCount += 1
            print("Frame load interrupted, attempting reload (\(retryCount)/\(maxRetries))...")
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(retryCount)) {
                self.performChatGPTLoad()
            }
        } else if retryCount >= maxRetries {
            showError("Failed to load ChatGPT after \(maxRetries) attempts. Please check your internet connection.")
        } else {
            showError("Failed to load ChatGPT: \(error.localizedDescription)")
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        progressIndicator?.stopAnimation(nil)
        
        // Check if it's a frame load interrupted error and try to reload
        let nsError = error as NSError
        if nsError.code == NSURLErrorCancelled && retryCount < maxRetries {
            // Frame load interrupted - this is often due to redirects or security policies
            retryCount += 1
            print("Provisional navigation failed with frame load interrupted, attempting reload (\(retryCount)/\(maxRetries))...")
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(retryCount)) {
                self.performChatGPTLoad()
            }
        } else if retryCount >= maxRetries {
            showError("Failed to load ChatGPT after \(maxRetries) attempts. Please check your internet connection.")
        } else {
            showError("Failed to load ChatGPT: \(error.localizedDescription)")
        }
    }
    
    // MARK: - WKUIDelegate
    
    // Store popup windows to keep them alive
    private var popupWindows: [NSWindow] = []

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Create a new window for popups (e.g., Google login)
        let popupWebView = WKWebView(frame: NSRect(x: 0, y: 0, width: 600, height: 800), configuration: configuration)
        popupWebView.navigationDelegate = self
        popupWebView.uiDelegate = self
        popupWebView.customUserAgent = webView.customUserAgent
        
        let popupWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 600, height: 800),
                                   styleMask: [.titled, .closable, .resizable],
                                   backing: .buffered,
                                   defer: false)
        popupWindow.contentView = popupWebView
        popupWindow.title = "Authentication"
        popupWindow.makeKeyAndOrderFront(nil)
        popupWindows.append(popupWindow)
        return popupWebView
    }

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = NSAlert()
        alert.messageText = "ChatGPT"
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = NSAlert()
        alert.messageText = "ChatGPT"
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let response = alert.runModal()
        completionHandler(response == .alertFirstButtonReturn)
    }
    
    // MARK: - Public Methods
    
    func reloadChatGPT() {
        loadChatGPT()
    }
}
