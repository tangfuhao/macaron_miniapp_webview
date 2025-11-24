import ExpoModulesCore
import MacaronCapacitorBridge
import WebKit

/// MacaronMiniappView - Expo 模組的 View 層
/// 
/// 這是一個薄層封裝，直接使用 MacaronCapacitorBridge Framework 提供的能力
class MacaronMiniappView: ExpoView {
    
    // MARK: - Properties
    
    private var capacitorBridge: MacaronCapacitorBridge!
    private var webView: WKWebView!
    
    // Event dispatchers for React Native
    let onLoadEnd = EventDispatcher()
    let onError = EventDispatcher()
    let onMessage = EventDispatcher()
    
    // MARK: - Initialization
    
    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        setupBridge()
    }
    
    private func setupBridge() {
        // 使用 MacaronCapacitorBridge Framework
        capacitorBridge = MacaronCapacitorBridge()
        webView = capacitorBridge.createWebView()
        
        // 設置導航代理以處理事件
        webView.navigationDelegate = self
        
        // 添加到視圖層級
        addSubview(webView)
        setupConstraints()
        
        print("✅ MacaronMiniappView: Bridge initialized")
    }
    
    private func setupConstraints() {
        // 關閉自動調整大小掩碼轉換，以使用 Auto Layout
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods (供 React Native 調用)
    
    func loadURL(_ url: URL) {
        capacitorBridge.loadURL(url)
    }
    
    func loadHTML(_ html: String, baseURL: URL? = nil) {
        capacitorBridge.loadHTML(html, baseURL: baseURL)
    }
    
    func evaluateJavaScript(_ script: String, callback: @escaping (Any?, Error?) -> Void) {
        capacitorBridge.evaluateJavaScript(script, completion: callback)
    }
    
    // MARK: - Lifecycle Management
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow != nil {
            capacitorBridge.viewWillAppear()
        } else {
            capacitorBridge.viewWillDisappear()
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            capacitorBridge.viewDidAppear()
        } else {
            capacitorBridge.viewDidDisappear()
        }
    }
    
    deinit {
        capacitorBridge.cleanup()
    }
}

// MARK: - WKNavigationDelegate

extension MacaronMiniappView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onLoadEnd([String: Any]())
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onError([
            "error": error.localizedDescription
        ])
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onError([
            "error": error.localizedDescription
        ])
    }
}
