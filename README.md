# Macaron WebView Workspace

这是 Macaron Mini App 加载器的开发工作区，包含 Capacitor 原生项目和 React Native Expo Module。

## 项目结构

```
macaron_webview/
├── capacitor-native/       # Capacitor 原生项目
│   ├── ios/               # iOS 原生代码和资源
│   ├── android/           # Android 原生代码和资源
│   ├── www/               # Web 内容目录
│   ├── package.json       # Capacitor 依赖
│   └── capacitor.config.json
│
└── packages/
    └── miniapp/           # @macaron/miniapp Expo Module
        ├── ios/           # iOS 原生桥接层
        ├── android/       # Android 原生桥接层
        ├── src/           # TypeScript/React Native 接口
        └── package.json
```

## 开发阶段

### ✅ Phase 1a-c: 基础结构（已完成）
- ✅ 目录重组
- ✅ Expo Module 基础结构
- ✅ iOS 基础 WebView 实现
- ✅ Android 基础 WebView 实现
- ✅ TypeScript 接口层

### 🚧 Phase 1d: Capacitor 集成（下一步）
- [ ] 配置 iOS Podspec 引用 Capacitor
- [ ] 配置 Android Gradle 引用 Capacitor
- [ ] 集成 Capacitor Bridge
- [ ] 测试基础功能

### 📋 Phase 2: 插件和功能
- [ ] 生命周期管理
- [ ] Capacitor 插件支持
- [ ] 消息传递优化
- [ ] 错误处理增强

## 快速开始

### 1. 安装 Capacitor 依赖

```bash
cd capacitor-native
npm install
```

### 2. 安装 Expo Module 依赖

```bash
cd packages/miniapp
npm install
```

### 3. 构建 Expo Module

```bash
cd packages/miniapp
npm run build
```

### 4. 在 Expo 项目中使用

```tsx
import { MacaronMiniappView } from '@macaron/miniapp';

function App() {
  return (
    <MacaronMiniappView
      url="https://example.com"
      style={{ flex: 1 }}
      onLoadEnd={() => console.log('加载完成')}
    />
  );
}
```

## 当前状态

**Phase 1c 完成** - 基础 WebView 功能已实现：
- ✅ iOS: WKWebView 封装
- ✅ Android: WebView 封装
- ✅ TypeScript 接口定义
- ✅ 事件系统（onLoadEnd, onError）

**下一步**：集成 Capacitor Bridge，实现完整的原生能力支持。

## 技术栈

- **Capacitor**: 7.x
- **Expo Modules**: 最新版本
- **iOS**: Swift 5+, iOS 14+
- **Android**: Kotlin, minSdk 24
- **TypeScript**: 5.x

## 许可证

MIT

