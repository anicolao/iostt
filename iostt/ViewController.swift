import UIKit
import WebKit

class ViewController: UIViewController {

    private var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
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
