class UserAgentManager {
    static let shared = UserAgentManager()
    private var userAgent: String?
    
    func getUserAgent(completion: @escaping (String) -> Void) {
        if let cached = userAgent {
            completion(cached)
            return
        }
        
        DispatchQueue.main.async {
            let webView = WKWebView(frame: .zero)
            webView.evaluateJavaScript("navigator.userAgent") { [weak self] result, error in
                if let agent = result as? String {
                    self?.userAgent = agent
                    completion(agent)
                } else {
                    // Fallback user agent if JavaScript fails
                    let fallback = "Mozilla/5.0 (iPhone; CPU iPhone OS \(UIDevice.current.systemVersion) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
                    self?.userAgent = fallback
                    completion(fallback)
                }
            }
        }
    }
}