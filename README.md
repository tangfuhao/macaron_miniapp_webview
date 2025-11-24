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

### 🎯 方式 1: 运行示例项目（推荐）

**最简单的验证方式**：

```bash
# 1. 进入示例项目
cd example

# 2. 安装依赖（会自动安装本地的 @macaron/miniapp）
npm install

# 3. 运行（iOS 或 Android）
npx expo run:ios
# 或
npx expo run:android
```

**详细说明**：查看 [`EXAMPLE_GUIDE.md`](./EXAMPLE_GUIDE.md) 或 [`example/README.md`](./example/README.md)

### 📦 方式 2: 在自己的项目中使用

#### 1. 安装 Capacitor 依赖

```bash
cd capacitor-native
npm install
```

#### 2. 在您的 Expo 项目中引用

```json
// 您的项目的 package.json
{
  "dependencies": {
    "@macaron/miniapp": "file:../macaron_webview/packages/miniapp"
  }
}
```

#### 3. 使用组件

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

#### 4. 运行

```bash
npx expo run:ios     # iOS
npx expo run:android # Android
```

**⚠️ 注意**：不能在 Expo Go 中使用，必须使用开发构建。

## 当前状态

**Phase 1d 完成** ✅ - Capacitor Bridge 集成完成：
- ✅ iOS: 独立的 Capacitor WebView 实现
- ✅ Android: 独立的 Capacitor WebView 实现
- ✅ 17+ Capacitor 插件支持
- ✅ 完整的生命周期管理
- ✅ 源码依赖模式（capacitor-native 提供依赖）

**可以使用了！** 现在可以在 Expo 应用中使用完整的 Capacitor 功能。

## 技术栈

- **Capacitor**: 7.x
- **Expo Modules**: 最新版本
- **iOS**: Swift 5+, iOS 14+
- **Android**: Kotlin, minSdk 24
- **TypeScript**: 5.x

## 许可证

MIT

