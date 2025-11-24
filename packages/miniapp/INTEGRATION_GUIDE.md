# Capacitor 集成指南

## Phase 1d: Capacitor Bridge 集成

本文档描述如何将 Capacitor Bridge 集成到 @macaron/miniapp 模块中。

## 架构概览

```
MacaronMiniappView (RN Component)
    ↓
Native View (iOS/Android)
    ↓
Capacitor Bridge
    ↓
WebView + Capacitor Plugins
```

## iOS 集成步骤

### 1. 更新 Podspec

修改 `ios/MacaronMiniapp.podspec`，添加 Capacitor 依赖：

```ruby
s.dependency 'Capacitor', :path => '../../../capacitor-native/node_modules/@capacitor/ios'
s.dependency 'CapacitorCordova', :path => '../../../capacitor-native/node_modules/@capacitor/ios'
```

### 2. 修改 MacaronMiniappView.swift

替换简单的 WKWebView 为 Capacitor 的 WebView：

```swift
import Capacitor

class MacaronMiniappView: ExpoView {
  private var bridge: CAPBridge!
  private var bridgeViewController: CAPBridgeViewController!
  
  private func setupCapacitor() {
    // 1. 创建 Bridge 配置
    let config = InstanceDescriptorHolder.shared
      .getDescriptor()?
      .makeConfiguration() ?? InstanceConfiguration()
    
    // 2. 创建一个轻量级的 ViewController 作为 Bridge 的宿主
    bridgeViewController = CAPBridgeViewController()
    
    // 3. 初始化 Bridge
    bridge = CAPBridge(with: config, 
                      delegate: bridgeViewController,
                      cordovaConfiguration: config.cordovaConfiguration)
    
    // 4. 获取 WebView
    let webView = bridge.webView!
    
    // 5. 添加到视图层级
    addSubview(webView)
    // ... 设置约束
  }
}
```

### 3. 生命周期管理

需要手动转发生命周期事件：

```swift
override func willMove(toWindow newWindow: UIWindow?) {
  super.willMove(toWindow: newWindow)
  if newWindow != nil {
    bridge?.viewWillAppear()
  } else {
    bridge?.viewWillDisappear()
  }
}
```

## Android 集成步骤

### 1. 更新 build.gradle

添加 Capacitor 依赖：

```gradle
dependencies {
  implementation project(':capacitor-android')
}
```

在 settings.gradle 中引用：

```gradle
include ':capacitor-android'
project(':capacitor-android').projectDir = new File(
  '../../../capacitor-native/node_modules/@capacitor/android/capacitor'
)
```

### 2. 修改 MacaronMiniappView.kt

集成 Capacitor Bridge：

```kotlin
import com.getcapacitor.Bridge
import com.getcapacitor.BridgeWebView

class MacaronMiniappView(context: Context, appContext: AppContext) : ExpoView(context, appContext) {
  
  private lateinit var bridge: Bridge
  private lateinit var webView: BridgeWebView
  
  init {
    setupCapacitor()
  }
  
  private fun setupCapacitor() {
    // 1. 获取 Activity 上下文
    val activity = getActivityContext()
    
    // 2. 创建 Bridge
    bridge = Bridge.Builder(activity)
      .setInstanceState(null)
      .create()
    
    // 3. 获取 WebView
    webView = bridge.webView
    
    // 4. 添加到布局
    addView(webView, LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
  }
  
  private fun getActivityContext(): Activity {
    var context: Context = context
    while (context is ContextWrapper) {
      if (context is Activity) return context
      context = context.baseContext
    }
    throw IllegalStateException("No Activity found")
  }
}
```

### 3. 生命周期管理

```kotlin
override fun onAttachedToWindow() {
  super.onAttachedToWindow()
  bridge.onStart()
  bridge.onResume()
}

override fun onDetachedFromWindow() {
  bridge.onPause()
  bridge.onStop()
  super.onDetachedFromWindow()
}
```

## 关键挑战和解决方案

### 挑战 1: Activity/ViewController 上下文

**问题**: Capacitor 需要 Activity/ViewController 引用

**解决方案**:
- iOS: 创建一个轻量级的 `CAPBridgeViewController` 实例
- Android: 从 Context 链中查找 Activity

### 挑战 2: 生命周期同步

**问题**: RN 组件的生命周期与原生不同

**解决方案**:
- 监听 `willMove(toWindow:)` (iOS)
- 监听 `onAttachedToWindow` (Android)
- 手动转发生命周期事件给 Bridge

### 挑战 3: 权限请求

**问题**: Capacitor 插件可能需要请求权限

**解决方案**:
- iOS: 确保 Info.plist 包含必要的权限描述
- Android: 在 AndroidManifest.xml 中声明权限
- 考虑创建 Expo Config Plugin 自动注入权限

## 测试清单

- [ ] WebView 能正常显示网页
- [ ] JavaScript 可以执行
- [ ] Capacitor.isNative 返回 true
- [ ] 至少一个 Capacitor 插件可以调用（如 Device.getInfo()）
- [ ] 生命周期事件正常触发
- [ ] 在 RN 导航中切换页面时 WebView 状态正常
- [ ] 内存不泄漏

## 下一步

完成 Phase 1d 后，我们将有：
- ✅ 完整的 Capacitor Bridge 集成
- ✅ 基础的插件支持
- ✅ 生命周期管理

然后可以开始 Phase 2：
- 高级插件配置
- 消息传递优化
- 性能优化
- 完整的示例应用

