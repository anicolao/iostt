import UIKit
import WebKit

class ViewController: UIViewController {

    private var webView: WKWebView!
    private var popupWebView: WKWebView?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        
        // Enable preferences for better web compatibility
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        webConfiguration.defaultWebpagePreferences = preferences
        
        // Enable JavaScript in preferences (for older iOS compatibility)
        webConfiguration.preferences.javaScriptEnabled = true
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://launcherui.web.app/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Navigation failed: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Provisional navigation failed: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Check if this is a redirect back from OAuth (often contains code, state, or other OAuth parameters)
        if let url = navigationAction.request.url,
           webView == popupWebView,
           (url.absoluteString.contains("launcherui.web.app") && 
            (url.absoluteString.contains("code=") || url.absoluteString.contains("state=") || url.fragment != nil)) {
            // Close popup and load the URL in the main webview
            if let popup = popupWebView {
                popup.removeFromSuperview()
                popupWebView = nil
            }
            self.webView.load(navigationAction.request)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}

extension ViewController: WKUIDelegate {
    // Handle popup windows (needed for OAuth flows)
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Create a popup webview for OAuth flows
        let popup = WKWebView(frame: view.bounds, configuration: configuration)
        popup.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popup.navigationDelegate = self
        popup.uiDelegate = self
        
        view.addSubview(popup)
        popupWebView = popup
        
        return popup
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        // Handle popup closure
        if webView == popupWebView {
            webView.removeFromSuperview()
            popupWebView = nil
        }
    }
    
    // Handle JavaScript alerts
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    // Handle JavaScript confirms
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        present(alertController, animated: true, completion: nil)
    }
}
