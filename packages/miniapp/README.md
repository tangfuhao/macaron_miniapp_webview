# @macaron/miniapp

Macaron Mini App Loader - A powerful webview component for React Native with Capacitor integration.

## 特性

- 🚀 完整的 Capacitor bridge 支持
- 📱 原生 iOS (WKWebView) 和 Android (WebView) 實現
- 🔌 從 Web 內容訪問 Capacitor 插件
- ⚡ 構建為 Expo Module，無縫集成
- 🎯 專為加載小程序和 Web 應用設計

## 安裝

```bash
npm install @macaron/miniapp
# 或
yarn add @macaron/miniapp
```

## 快速開始

### 1. 基本使用

```tsx
import { MacaronMiniappView } from '@macaron/miniapp';

function App() {
  return (
    <MacaronMiniappView
      url="https://your-web-app.com"
      style={{ flex: 1 }}
      onLoadEnd={() => console.log('Web app loaded')}
      onError={(e) => console.error('Error loading:', e.error)}
    />
  );
}
```

### 2. 加載本地 HTML

```tsx
<MacaronMiniappView
  html={`
    <!DOCTYPE html>
    <html>
      <head>
        <script src="https://cdn.jsdelivr.net/npm/@capacitor/core"></script>
      </head>
      <body>
        <h1>Hello from Capacitor!</h1>
        <button onclick="testCapacitor()">Test Device Info</button>
        <script>
          async function testCapacitor() {
            const info = await Capacitor.Plugins.Device.getInfo();
            alert(JSON.stringify(info));
          }
        </script>
      </body>
    </html>
  `}
  style={{ flex: 1 }}
/>
```

### 3. 配置權限（重要！）

在你的 `app.json` 中添加必要的權限：

```json
{
  "expo": {
    "ios": {
      "infoPlist": {
        "NSCameraUsageDescription": "需要訪問相機",
        "NSPhotoLibraryUsageDescription": "需要訪問相冊",
        "NSMicrophoneUsageDescription": "需要訪問麥克風",
        "NSLocationWhenInUseUsageDescription": "需要訪問位置"
      }
    }
  }
}
```

詳細配置請參考 [PERMISSIONS.md](./PERMISSIONS.md)

## API

### Props

| Prop | Type | Description |
|------|------|-------------|
| `url` | `string` | 要加載的 URL |
| `html` | `string` | 直接加載 HTML 內容 |
| `onLoadEnd` | `() => void` | 加載完成時調用 |
| `onError` | `(event) => void` | 發生錯誤時調用 |
| `onMessage` | `(event) => void` | 接收來自 webview 的消息 |

### 可用的 Capacitor 插件

WebView 中的 JavaScript 可以訪問以下 Capacitor 插件：

- ✅ **Device** - 設備信息
- ✅ **Camera** - 相機和照片
- ✅ **Geolocation** - 地理位置
- ✅ **Filesystem** - 文件系統
- ✅ **Network** - 網絡狀態
- ✅ **Haptics** - 觸覺反饋
- ✅ **Toast** - 提示消息
- ✅ **Clipboard** - 剪貼板
- ✅ **Share** - 分享
- ✅ **Browser** - 瀏覽器
- ✅ **Keyboard** - 鍵盤控制
- ✅ **Preferences** - 本地存儲
- ✅ **Local Notifications** - 本地通知
- ✅ **Speech Recognition** - 語音識別
- ✅ **Text to Speech** - 文字轉語音

## 示例

查看 [example](../../example) 目錄獲取完整的示例應用。

## 開發

如果你想修改或貢獻代碼，請參考：
- [DEVELOPMENT.md](./DEVELOPMENT.md) - 開發指南
- [INTEGRATION_GUIDE.md](./INTEGRATION_GUIDE.md) - Capacitor 集成指南

## 常見問題

### Q: 如何與 WebView 中的 JS 通信？

A: 使用 `onMessage` prop 接收消息，使用 `postMessage` 發送消息（功能開發中）。

### Q: 支持哪些 Expo 版本？

A: Expo SDK 50+ (使用 Expo Modules API)

### Q: 可以在裸 React Native 項目中使用嗎？

A: 可以，但需要手動配置原生依賴。建議使用 Expo。

### Q: 為什麼包這麼大？

A: 因為包含了預編譯的 Capacitor 框架（iOS xcframework + Android AAR）。這樣做是為了簡化集成，避免複雜的原生配置。

## 許可證

MIT

## 鳴謝

本項目基於 [Capacitor](https://capacitorjs.com/) 構建。

