# 快速开始指南

## 当前状态

✅ **Phase 1a-c 完成** - 基础结构已搭建完成  
🚧 **Phase 1d 待完成** - Capacitor Bridge 集成

---

## 目录结构

```
macaron_webview/
│
├── capacitor-native/          # Capacitor 原生项目
│   ├── ios/                   # iOS 原生代码
│   ├── android/               # Android 原生代码
│   ├── www/                   # Web 内容目录
│   ├── node_modules/          # Capacitor 依赖
│   ├── package.json
│   └── capacitor.config.json
│
└── packages/
    └── miniapp/               # @macaron/miniapp Expo Module
        ├── ios/               # iOS 原生桥接层
        ├── android/           # Android 原生桥接层
        ├── src/               # TypeScript 接口
        │   └── index.tsx
        ├── package.json
        ├── expo-module.config.json
        ├── README.md
        ├── INTEGRATION_GUIDE.md
        └── CHANGELOG.md
```

---

## 验证安装

### 1. 检查目录结构

```bash
# 在项目根目录
ls -la

# 应该看到：
# - capacitor-native/
# - packages/miniapp/
# - README.md
# - STATUS.md
# - QUICK_START.md
```

### 2. 查看 Capacitor 项目

```bash
cd capacitor-native
ls -la

# 应该看到：
# - ios/
# - android/
# - www/
# - node_modules/
# - package.json
# - capacitor.config.json
```

### 3. 查看 miniapp 模块

```bash
cd ../packages/miniapp
ls -la

# 应该看到：
# - ios/
# - android/
# - src/
# - package.json
# - expo-module.config.json
```

---

## 下一步：Phase 1d - Capacitor 集成

### 准备工作

1. **确认 Capacitor 依赖已安装**

```bash
cd capacitor-native
npm install  # 如果还没安装
```

2. **安装 miniapp 模块的依赖**

```bash
cd ../packages/miniapp
npm install
```

### iOS 集成步骤

详见 `packages/miniapp/INTEGRATION_GUIDE.md`

**概要**:
1. 更新 `ios/MacaronMiniapp.podspec` 添加 Capacitor 依赖
2. 修改 `ios/MacaronMiniappView.swift` 集成 Capacitor Bridge
3. 运行 `pod install`
4. 测试

### Android 集成步骤

详见 `packages/miniapp/INTEGRATION_GUIDE.md`

**概要**:
1. 更新 `android/build.gradle` 添加 Capacitor 依赖
2. 修改 `android/src/main/java/.../MacaronMiniappView.kt` 集成 Bridge
3. 同步 Gradle
4. 测试

---

## 在 Expo 项目中使用

### 安装（本地开发）

在您的 Expo 项目的 `package.json` 中：

```json
{
  "dependencies": {
    "@macaron/miniapp": "file:../macaron_webview/packages/miniapp"
  }
}
```

然后运行：
```bash
npm install
# 或
yarn install
```

### 使用示例

```tsx
import React from 'react';
import { StyleSheet, View } from 'react-native';
import { MacaronMiniappView } from '@macaron/miniapp';

export default function App() {
  return (
    <View style={styles.container}>
      <MacaronMiniappView
        url="https://example.com"
        style={styles.webview}
        onLoadEnd={() => {
          console.log('✅ 网页加载完成');
        }}
        onError={(event) => {
          console.error('❌ 加载错误:', event.error);
        }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  webview: {
    flex: 1,
  },
});
```

### 加载 HTML 内容

```tsx
<MacaronMiniappView
  html={`
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body>
        <h1>Hello Macaron!</h1>
        <button onclick="alert('Hello from WebView!')">
          Click Me
        </button>
      </body>
    </html>
  `}
  style={{ flex: 1 }}
/>
```

---

## 配置 Expo Dev Client

### 1. 安装 Expo Dev Client

```bash
npx expo install expo-dev-client
```

### 2. 构建开发版本

```bash
# iOS
npx expo run:ios

# Android
npx expo run:android
```

### 3. 启动开发服务器

```bash
npx expo start --dev-client
```

---

## 常见问题

### Q: 为什么现在还不能运行？

**A**: Phase 1c 只完成了基础结构，还需要完成 Phase 1d (Capacitor 集成) 才能实际运行。

### Q: 我可以现在就测试基础 WebView 吗？

**A**: 可以！当前的实现已经包含基础的 WebView 功能。但是 Capacitor 的插件功能要等 Phase 1d 完成后才能使用。

### Q: 如何知道 Capacitor 是否集成成功？

**A**: 在 WebView 中执行 JavaScript：
```javascript
if (window.Capacitor && window.Capacitor.isNative) {
  console.log('✅ Capacitor 已成功集成');
} else {
  console.log('❌ Capacitor 未集成或未初始化');
}
```

### Q: 支持哪些 Capacitor 插件？

**A**: 理论上支持所有 Capacitor 插件，但需要在 Phase 1d 后逐个测试。建议优先测试：
- @capacitor/device
- @capacitor/filesystem
- @capacitor/camera
- @capacitor/geolocation

---

## 项目文档

- 📖 [README.md](README.md) - 项目总览
- 📊 [STATUS.md](STATUS.md) - 详细状态报告
- 🔧 [packages/miniapp/INTEGRATION_GUIDE.md](packages/miniapp/INTEGRATION_GUIDE.md) - Capacitor 集成指南
- 📝 [packages/miniapp/README.md](packages/miniapp/README.md) - 模块使用文档
- 📋 [packages/miniapp/CHANGELOG.md](packages/miniapp/CHANGELOG.md) - 版本历史

---

## 技术支持

如遇到问题：

1. 查阅 `INTEGRATION_GUIDE.md` 了解集成步骤
2. 查阅 `STATUS.md` 了解当前状态和限制
3. 检查终端错误信息
4. 确认依赖已正确安装

---

**最后更新**: 2024-11-24  
**当前阶段**: Phase 1c 完成 ✅  
**下一步**: Phase 1d - Capacitor Bridge 集成 🚧

