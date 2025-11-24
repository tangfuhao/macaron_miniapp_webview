package com.macaron.miniapp

import android.content.Context
import android.webkit.WebView
import com.macaron.capacitor.MacaronCapacitorBridge
import expo.modules.kotlin.AppContext
import expo.modules.kotlin.views.ExpoView

/**
 * MacaronMiniappView - Expo 模組的 View 層
 * 
 * 這是一個薄層封裝，直接使用 MacaronCapacitorBridge Library 提供的能力
 */
class MacaronMiniappView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {
    
    private val capacitorBridge: MacaronCapacitorBridge
    private val webView: WebView
    
    init {
        // 使用 MacaronCapacitorBridge Library
        capacitorBridge = MacaronCapacitorBridge(context)
        webView = capacitorBridge.createWebView()
        
        // 添加到視圖
        addView(webView)
        
        println("✅ MacaronMiniappView: Bridge initialized")
    }
    
    // MARK: - Public Methods (供 React Native 調用)
    
    fun loadURL(url: String) {
        capacitorBridge.loadURL(url)
    }
    
    fun loadHTML(html: String, baseURL: String = "capacitor://localhost") {
        capacitorBridge.loadHTML(html, baseURL)
    }
    
    fun evaluateJavaScript(script: String, callback: ((String?) -> Unit)? = null) {
        capacitorBridge.evaluateJavaScript(script) { result ->
            callback?.invoke(result)
        }
    }
    
    // MARK: - Lifecycle Management
    
    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        capacitorBridge.onStart()
        capacitorBridge.onResume()
    }
    
    override fun onDetachedFromWindow() {
        capacitorBridge.onPause()
        capacitorBridge.onStop()
        super.onDetachedFromWindow()
    }
    
    /**
     * 清理資源
     */
    fun cleanup() {
        capacitorBridge.cleanup()
    }
}
