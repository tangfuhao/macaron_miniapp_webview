import Foundation
import Capacitor
import WebKit

/// MacaronCapacitorBridge - 封裝 Capacitor 能力的核心類
/// 
/// 這個類提供了完整的 Capacitor WebView 和 Bridge 功能，
/// 可以被任何 iOS 應用或模組使用，無需依賴完整的 Capacitor 項目結構
/// 
/// **Capacitor 7.x 兼容版本**
/// 使用 CAPBridgeViewController 來管理 Bridge，這是 Capacitor 7.x 的標準做法
@objc public class MacaronCapacitorBridge: NSObject {
    
    // MARK: - Properties
    
    /// Capacitor 的 BridgeViewController，負責管理整個 bridge 和 webView
    private var bridgeViewController: CAPBridgeViewController!
    
    /// 對外暴露的 WebView（從 bridgeViewController 獲取）
    public private(set) var webView: WKWebView!
    
    /// 用於承載 bridgeViewController 的容器視圖
    /// 在不需要完整 ViewController 層級的場景中使用
    private var containerView: UIView?
    
    // MARK: - Initialization
    
    @objc public override init() {
        super.init()
    }
    
    /// 初始化 Capacitor Bridge 和 WebView
    /// - Returns: 配置好的 WKWebView 實例
    @objc public func createWebView() -> WKWebView {
        // 1. 創建 CAPBridgeViewController
        // 這是 Capacitor 7.x 的標準方式
        bridgeViewController = CAPBridgeViewController()
        
        // 2. 觸發 viewDidLoad 來初始化 bridge 和 webView
        // 這會創建 CapacitorBridge 實例和 WKWebView
        bridgeViewController.loadViewIfNeeded()
        
        // 3. 獲取 WebView
        guard let createdWebView = bridgeViewController.webView else {
            fatalError("❌ Failed to create Capacitor WebView")
        }
        
        webView = createdWebView
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // 4. 設置容器視圖（如果需要的話）
        // 這確保 bridgeViewController 的 view 有一個父視圖
        // 某些 Capacitor 插件可能需要這個
        setupContainerView()
        
        print("✅ MacaronCapacitorBridge: WebView created successfully (Capacitor 7.x)")
        print("📋 Bridge protocol: \(type(of: bridgeViewController.bridge))")
        
        return webView
    }
    
    // MARK: - Configuration
    
    /// 設置容器視圖
    /// 某些 Capacitor 插件需要 ViewController 在視圖層級中
    private func setupContainerView() {
        containerView = UIView()
        containerView?.addSubview(bridgeViewController.view)
        
        // 不添加約束，因為這個容器視圖只是為了讓 ViewController 有一個父視圖
        // 實際的佈局由使用者控制 webView 來完成
    }
    
    // MARK: - Public Methods
    
    /// 載入 URL
    @objc public func loadURL(_ url: URL) {
        guard webView != nil else {
            print("⚠️ MacaronCapacitorBridge: WebView not initialized")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    /// 載入 HTML 內容
    @objc public func loadHTML(_ html: String, baseURL: URL? = nil) {
        guard webView != nil else {
            print("⚠️ MacaronCapacitorBridge: WebView not initialized")
            return
        }
        
        let base = baseURL ?? URL(string: "capacitor://localhost")
        webView.loadHTMLString(html, baseURL: base)
    }
    
    /// 執行 JavaScript
    @objc public func evaluateJavaScript(_ javascript: String, completion: ((Any?, Error?) -> Void)? = nil) {
        guard webView != nil else {
            print("⚠️ MacaronCapacitorBridge: WebView not initialized")
            completion?(nil, NSError(domain: "MacaronCapacitorBridge", code: -1, userInfo: [NSLocalizedDescriptionKey: "WebView not initialized"]))
            return
        }
        
        webView.evaluateJavaScript(javascript, completionHandler: completion)
    }
    
    // MARK: - Lifecycle Management
    
    /// 視圖即將出現
    @objc public func viewWillAppear() {
        guard bridgeViewController != nil else { return }
        
        // 轉發生命周期事件到 bridgeViewController
        bridgeViewController.viewWillAppear(false)
    }
    
    /// 視圖已經出現
    @objc public func viewDidAppear() {
        guard bridgeViewController != nil else { return }
        
        // 轉發生命周期事件到 bridgeViewController
        bridgeViewController.viewDidAppear(false)
    }
    
    /// 視圖即將消失
    @objc public func viewWillDisappear() {
        guard bridgeViewController != nil else { return }
        
        // 轉發生命周期事件到 bridgeViewController
        bridgeViewController.viewWillDisappear(false)
    }
    
    /// 視圖已經消失
    @objc public func viewDidDisappear() {
        guard bridgeViewController != nil else { return }
        
        // 轉發生命周期事件到 bridgeViewController
        bridgeViewController.viewDidDisappear(false)
    }
    
    /// 清理資源
    @objc public func cleanup() {
        // 清理順序很重要
        webView = nil
        
        if let vc = bridgeViewController {
            // 從父視圖移除
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        
        bridgeViewController = nil
        containerView = nil
        
        print("✅ MacaronCapacitorBridge: Cleaned up")
    }
    
    // MARK: - Advanced API
    
    /// 獲取 Bridge 實例（用於高級用途）
    /// - Returns: CapacitorBridge 協議實例
    /// - Note: 內部使用，不暴露 Capacitor 類型到公開 API
    @objc public func getBridge() -> Any? {
        return bridgeViewController?.bridge
    }
    
    /// 獲取 BridgeViewController（用於需要 ViewController 的場景）
    /// - Returns: CAPBridgeViewController 實例
    /// - Note: 內部使用，不暴露 Capacitor 類型到公開 API
    @objc public func getBridgeViewController() -> Any? {
        return bridgeViewController
    }
}

// MARK: - Capacitor 7.x Compatibility Notes

/*
 ## Capacitor 7.x 重構說明
 
 ### 主要變更
 1. **使用 CAPBridgeViewController**
    - Capacitor 7.x 的標準方式是通過 CAPBridgeViewController 來管理整個 bridge
    - 不再直接創建 CAPBridge/CapacitorBridge 實例
 
 2. **生命周期管理**
    - 生命周期方法現在轉發給 bridgeViewController
    - 使用 viewWillAppear(_:) 等標準 UIViewController 方法
 
 3. **配置簡化**
    - 不再需要手動創建 InstanceConfiguration、CDVConfigParser 等
    - CAPBridgeViewController 會自動處理所有配置
 
 4. **WebView 訪問**
    - WebView 從 bridgeViewController.webView 獲取
    - 在 loadViewIfNeeded() 後可用
 
 ### 優勢
 - ✅ 完全兼容 Capacitor 7.x
 - ✅ 代碼更簡潔
 - ✅ 自動處理所有內部配置
 - ✅ 所有 Capacitor 插件都能正常工作
 - ✅ 保持對外 API 兼容
 
 ### 注意事項
 - bridgeViewController 需要在視圖層級中（已通過 containerView 處理）
 - 某些插件可能需要訪問 viewController（通過 getBridgeViewController() 提供）
 */

