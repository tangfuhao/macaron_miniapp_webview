# 🎯 Macaron MiniApp Example

这是一个用于测试 `@macaron/miniapp` 模块的示例项目。

---

## 📦 项目结构

```
example/
├── App.js              # 主应用，包含三个测试场景
├── app.json            # Expo 配置（包含权限）
├── package.json        # 依赖配置（引用本地 @macaron/miniapp）
└── README.md           # 本文档
```

---

## 🚀 快速开始

### 1. 安装依赖

```bash
cd example
npm install
```

这会自动安装 `@macaron/miniapp` 从 `file:../packages/miniapp`。

### 2. 运行项目

#### iOS

```bash
# 首次运行需要生成原生项目
npx expo run:ios
```

**注意**：不要使用 `expo start` 然后在 Expo Go 中打开，因为 Expo Go 不支持自定义原生模块。必须使用 `expo run:ios` 或 `expo run:android` 构建开发版本。

#### Android

```bash
npx expo run:android
```

### 3. 如果遇到问题

#### iOS Pod 安装问题

```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
npx expo run:ios
```

#### Android Gradle 问题

```bash
cd android
./gradlew clean
cd ..
npx expo run:android
```

---

## 📱 测试功能

应用包含三个测试场景：

### 1. 🌐 加载 URL

- 加载 Capacitor 官网：`https://capacitorjs.com`
- 测试基础的 WebView 功能
- 验证 URL 加载是否正常

### 2. 📝 加载 HTML

- 直接加载 HTML 内容
- 测试 HTML 字符串渲染
- 验证样式和脚本执行

### 3. 🔌 测试 Capacitor

这是最重要的测试，包含：

#### ✅ Capacitor 状态检测
- 检查 Capacitor 是否可用
- 显示平台信息
- 显示是否为原生环境

#### 🔌 插件测试
- **设备信息**：获取设备型号、系统版本等
- **网络状态**：检查网络连接状态
- **剪贴板**：测试读写剪贴板

#### 📱 设备能力
- **震动反馈**：触发设备震动
- **Toast 提示**：显示原生 Toast

---

## 🎨 应用截图说明

### 主界面
- 顶部显示应用标题和说明
- 中间有三个切换按钮
- 下方是 WebView 显示区域
- 底部有提示信息

### Capacitor 测试页面
- 紫色渐变背景
- 半透明卡片设计
- 交互式按钮
- 实时结果显示

---

## 🔍 验证清单

运行应用后，请验证以下功能：

### ✅ 基础功能
- [ ] WebView 能正常显示
- [ ] URL 可以加载
- [ ] HTML 内容可以显示
- [ ] 页面样式正确渲染

### ✅ Capacitor 集成
- [ ] `window.Capacitor` 对象存在
- [ ] `Capacitor.isNative` 返回 `true`
- [ ] `Capacitor.getPlatform()` 返回正确的平台

### ✅ 插件功能
- [ ] Device.getInfo() 返回设备信息
- [ ] Network.getStatus() 返回网络状态
- [ ] Clipboard 读写功能正常
- [ ] Haptics 震动反馈工作
- [ ] Toast 提示显示

### ✅ 事件系统
- [ ] onLoadEnd 事件触发
- [ ] onError 事件正常（如果有错误）
- [ ] Console 日志正确输出

---

## 🐛 故障排查

### 问题 1: 找不到 @macaron/miniapp

**原因**：本地依赖未正确链接

**解决方案**：
```bash
# 确保在 example 目录
cd example
npm install
```

### 问题 2: iOS 编译错误

**原因**：Capacitor pods 未安装

**解决方案**：
```bash
cd ios
pod install
cd ..
npx expo run:ios
```

### 问题 3: Capacitor 不可用

**原因**：在 Expo Go 中运行

**解决方案**：
- ❌ 不要使用 `expo start` + Expo Go
- ✅ 使用 `npx expo run:ios` 或 `npx expo run:android`

### 问题 4: 插件调用失败

**原因**：权限未配置或插件未加载

**解决方案**：
1. 检查 `app.json` 中的权限配置
2. 重新构建应用
3. 检查设备是否授予权限

---

## 📂 项目配置

### package.json

```json
{
  "dependencies": {
    "@macaron/miniapp": "file:../packages/miniapp"
  }
}
```

使用 `file:` 协议引用本地包，无需发布到 npm。

### app.json

配置了必要的权限：
- iOS: Info.plist 权限描述
- Android: 权限列表

---

## 🔧 开发技巧

### 1. 实时重载

修改 `App.js` 后：
- 按 `r` 重新加载
- 按 `Shift + R` 完全重新加载

### 2. 调试

#### iOS
```bash
# 打开 Safari -> 开发 -> 选择设备 -> 选择 WebView
```

#### Android
```bash
# Chrome DevTools
chrome://inspect
```

### 3. 日志查看

```bash
# iOS
npx expo run:ios --device

# Android
npx expo run:android
adb logcat
```

### 4. 修改测试内容

编辑 `App.js` 中的 `testHTML` 变量来自定义测试页面内容。

---

## 📊 性能测试

### WebView 加载时间
- 观察 onLoadEnd 事件触发时间
- 检查 Console 日志中的时间戳

### 插件响应速度
- 点击测试按钮
- 观察结果显示的延迟

---

## 🎓 学习要点

### 1. 本地包引用

```json
"@macaron/miniapp": "file:../packages/miniapp"
```

这允许在不发布 npm 包的情况下测试本地模块。

### 2. Expo Native Module

- 必须使用 `expo run:ios/android`
- 不能在 Expo Go 中运行
- 需要原生构建环境

### 3. Capacitor WebView

- WebView 中可以直接访问 `window.Capacitor`
- 所有插件通过 `Capacitor.Plugins.*` 访问
- 异步 API 使用 Promise

---

## 📞 需要帮助？

如果遇到问题：

1. 查看 Console 输出
2. 检查 `../packages/miniapp/USAGE.md`
3. 确认 `capacitor-native` 的依赖已安装
4. 重新构建项目

---

## ✨ 下一步

测试成功后，您可以：

1. 修改 `App.js` 添加更多测试
2. 测试其他 Capacitor 插件
3. 集成到实际项目中
4. 发布 @macaron/miniapp 到 npm

---

**祝测试顺利！** 🚀

