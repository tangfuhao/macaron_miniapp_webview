package com.macaron.capacitor

import android.content.Context
import android.content.ContextWrapper
import android.view.ViewGroup
import android.webkit.WebView
import androidx.appcompat.app.AppCompatActivity
import com.getcapacitor.*

/**
 * MacaronCapacitorBridge - 封裝 Capacitor 能力的核心類
 * 
 * 這個類提供了完整的 Capacitor WebView 和 Bridge 功能，
 * 可以被任何 Android 應用或模組使用，無需依賴完整的 Capacitor 項目結構
 * 
 * Capacitor 7.x 兼容版本
 */
class MacaronCapacitorBridge(private val context: Context) {
    
    private lateinit var bridge: Bridge
    lateinit var webView: WebView
        private set
    
    private var activity: AppCompatActivity? = null
    
    /**
     * 初始化 Capacitor Bridge 和 WebView
     * @return 配置好的 WebView 實例
     */
    fun createWebView(): WebView {
        // 1. 獲取 Activity 引用
        activity = getActivityFromContext()
        
        if (activity == null) {
            throw IllegalStateException("❌ No Activity found for Capacitor initialization")
        }
        
        try {
            // 2. 創建 WebView 並設置 ID
            // Bridge.Builder 需要通過 findViewById(R.id.webview) 找到 WebView
            webView = WebView(activity!!).apply {
                id = activity!!.resources.getIdentifier("webview", "id", "com.getcapacitor.android")
                layoutParams = ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT
                )
            }
            
            // 3. 將 WebView 臨時添加到 Activity 的根視圖
            // 這樣 Bridge.Builder 可以找到它
            val rootView = activity!!.window.decorView.findViewById<ViewGroup>(android.R.id.content)
            rootView.addView(webView)
            
            // 4. 創建 PluginManager 並加載插件
            val pluginManager = PluginManager(activity!!.assets)
            val pluginClasses = try {
                pluginManager.loadPluginClasses()
            } catch (e: PluginLoadException) {
                Logger.error("Error loading plugins", e)
                emptyList()
            }
            
            // 5. 創建 CapConfig（使用默認配置或從 capacitor.config.json 讀取）
            val config = CapConfig.loadDefault(activity!!)
            
            // 6. 使用 Bridge.Builder 創建 Bridge（Capacitor 7.x 方式）
            bridge = Bridge.Builder(activity!!)
                .addPlugins(pluginClasses)
                .setConfig(config)
                .create()
            
            // 7. 從 Activity 的根視圖中移除 WebView
            // 現在使用者可以將它添加到任何需要的地方
            rootView.removeView(webView)
            
            println("✅ MacaronCapacitorBridge: WebView and Bridge created successfully")
            
        } catch (e: Exception) {
            println("❌ Error initializing Capacitor: ${e.message}")
            e.printStackTrace()
            throw e
        }
        
        return webView
    }
    
    private fun getActivityFromContext(): AppCompatActivity? {
        var ctx: Context? = context
        while (ctx is ContextWrapper) {
            if (ctx is AppCompatActivity) {
                return ctx
            }
            ctx = ctx.baseContext
        }
        return null
    }
    
    // MARK: - Public Methods
    
    /**
     * 獲取 Bridge 實例（高級用途）
     */
    fun getBridge(): Bridge {
        if (!::bridge.isInitialized) {
            throw IllegalStateException("Bridge not initialized. Call createWebView() first.")
        }
        return bridge
    }
    
    /**
     * 載入 URL
     */
    fun loadURL(url: String) {
        if (::webView.isInitialized) {
            webView.loadUrl(url)
        } else {
            println("⚠️ MacaronCapacitorBridge: WebView not initialized")
        }
    }
    
    /**
     * 載入 HTML 內容
     */
    fun loadHTML(html: String, baseURL: String = "capacitor://localhost") {
        if (::webView.isInitialized) {
            webView.loadDataWithBaseURL(
                baseURL,
                html,
                "text/html",
                "UTF-8",
                null
            )
        } else {
            println("⚠️ MacaronCapacitorBridge: WebView not initialized")
        }
    }
    
    /**
     * 執行 JavaScript
     */
    fun evaluateJavaScript(script: String, callback: ((String?) -> Unit)? = null) {
        if (::webView.isInitialized) {
            webView.evaluateJavascript(script) { result ->
                callback?.invoke(result)
            }
        } else {
            println("⚠️ MacaronCapacitorBridge: WebView not initialized")
            callback?.invoke(null)
        }
    }
    
    // MARK: - Lifecycle Management
    
    /**
     * Activity onStart
     * 轉發給 Bridge
     */
    fun onStart() {
        if (::bridge.isInitialized) {
            activity?.runOnUiThread {
                try {
                    bridge.onStart()
                    println("✅ Capacitor lifecycle: onStart")
                } catch (e: Exception) {
                    println("❌ Error in Capacitor lifecycle: ${e.message}")
                }
            }
        }
    }
    
    /**
     * Activity onResume
     * 轉發給 Bridge
     */
    fun onResume() {
        if (::bridge.isInitialized) {
            activity?.runOnUiThread {
                try {
                    bridge.onResume()
                    println("✅ Capacitor lifecycle: onResume")
                } catch (e: Exception) {
                    println("❌ Error in Capacitor lifecycle: ${e.message}")
                }
            }
        }
    }
    
    /**
     * Activity onPause
     * 轉發給 Bridge
     */
    fun onPause() {
        if (::bridge.isInitialized) {
            activity?.runOnUiThread {
                try {
                    bridge.onPause()
                    println("✅ Capacitor lifecycle: onPause")
                } catch (e: Exception) {
                    println("❌ Error in Capacitor lifecycle: ${e.message}")
                }
            }
        }
    }
    
    /**
     * Activity onStop
     * 轉發給 Bridge
     */
    fun onStop() {
        if (::bridge.isInitialized) {
            activity?.runOnUiThread {
                try {
                    bridge.onStop()
                    println("✅ Capacitor lifecycle: onStop")
                } catch (e: Exception) {
                    println("❌ Error in Capacitor lifecycle: ${e.message}")
                }
            }
        }
    }
    
    /**
     * 清理資源
     */
    fun cleanup() {
        if (::bridge.isInitialized) {
            try {
                bridge.onDestroy()
                println("✅ MacaronCapacitorBridge: Cleaned up")
            } catch (e: Exception) {
                println("❌ Error destroying Capacitor: ${e.message}")
            }
        }
    }
}

