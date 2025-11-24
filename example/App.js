import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View, SafeAreaView, Button, Alert, ScrollView } from 'react-native';
import { useState } from 'react';
import { MacaronMiniappView } from '@macaron/miniapp';

export default function App() {
  const [currentTest, setCurrentTest] = useState('url'); // 'url', 'html', 'capacitor'

  const testHTML = `
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            padding: 20px;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
          }
          .card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 20px;
            margin: 10px 0;
            border: 1px solid rgba(255, 255, 255, 0.2);
          }
          h1 { margin-top: 0; }
          button {
            background: white;
            color: #667eea;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin: 5px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
          }
          button:active {
            transform: scale(0.95);
          }
          .result {
            background: rgba(0, 0, 0, 0.2);
            padding: 10px;
            border-radius: 8px;
            margin-top: 10px;
            font-family: monospace;
            font-size: 12px;
          }
        </style>
      </head>
      <body>
        <h1>🎉 Macaron MiniApp 测试</h1>
        
        <div class="card">
          <h2>✅ Capacitor 状态</h2>
          <div id="status">检测中...</div>
        </div>

        <div class="card">
          <h2>🔌 测试插件</h2>
          <button onclick="testDevice()">设备信息</button>
          <button onclick="testNetwork()">网络状态</button>
          <button onclick="testClipboard()">剪贴板</button>
          <div id="result" class="result">点击按钮测试插件...</div>
        </div>

        <div class="card">
          <h2>📱 设备能力</h2>
          <button onclick="testHaptics()">震动反馈</button>
          <button onclick="testToast()">显示 Toast</button>
          <div id="capability-result" class="result">测试设备能力...</div>
        </div>

        <script>
          // 检查 Capacitor 状态
          function checkCapacitor() {
            const statusDiv = document.getElementById('status');
            if (window.Capacitor) {
              statusDiv.innerHTML = \`
                <strong>✅ Capacitor 可用！</strong><br>
                平台: \${Capacitor.getPlatform()}<br>
                是否原生: \${Capacitor.isNative ? '是' : '否'}<br>
                原生版本: \${Capacitor.isPluginAvailable ? '新版' : '旧版'}
              \`;
            } else {
              statusDiv.innerHTML = '❌ Capacitor 不可用';
            }
          }

          // 测试设备信息
          async function testDevice() {
            const resultDiv = document.getElementById('result');
            try {
              const info = await Capacitor.Plugins.Device.getInfo();
              resultDiv.innerHTML = \`
                <strong>📱 设备信息：</strong><br>
                型号: \${info.model}<br>
                平台: \${info.platform}<br>
                系统: \${info.operatingSystem}<br>
                版本: \${info.osVersion}<br>
                制造商: \${info.manufacturer}
              \`;
            } catch (err) {
              resultDiv.innerHTML = '❌ 错误: ' + err.message;
            }
          }

          // 测试网络状态
          async function testNetwork() {
            const resultDiv = document.getElementById('result');
            try {
              const status = await Capacitor.Plugins.Network.getStatus();
              resultDiv.innerHTML = \`
                <strong>🌐 网络状态：</strong><br>
                已连接: \${status.connected ? '是' : '否'}<br>
                连接类型: \${status.connectionType}
              \`;
            } catch (err) {
              resultDiv.innerHTML = '❌ 错误: ' + err.message;
            }
          }

          // 测试剪贴板
          async function testClipboard() {
            const resultDiv = document.getElementById('result');
            try {
              const testString = 'Hello from Macaron MiniApp! ' + new Date().toLocaleTimeString();
              await Capacitor.Plugins.Clipboard.write({ string: testString });
              const result = await Capacitor.Plugins.Clipboard.read();
              resultDiv.innerHTML = \`
                <strong>📋 剪贴板测试：</strong><br>
                ✅ 写入成功<br>
                读取内容: \${result.value}
              \`;
            } catch (err) {
              resultDiv.innerHTML = '❌ 错误: ' + err.message;
            }
          }

          // 测试震动
          async function testHaptics() {
            const resultDiv = document.getElementById('capability-result');
            try {
              await Capacitor.Plugins.Haptics.impact({ style: 'medium' });
              resultDiv.innerHTML = '✅ 震动反馈已触发';
              setTimeout(() => {
                resultDiv.innerHTML = '测试设备能力...';
              }, 2000);
            } catch (err) {
              resultDiv.innerHTML = '❌ 错误: ' + err.message;
            }
          }

          // 测试 Toast
          async function testToast() {
            const resultDiv = document.getElementById('capability-result');
            try {
              await Capacitor.Plugins.Toast.show({
                text: 'Hello from Capacitor! 🎉',
                duration: 'short',
                position: 'bottom'
              });
              resultDiv.innerHTML = '✅ Toast 已显示';
              setTimeout(() => {
                resultDiv.innerHTML = '测试设备能力...';
              }, 2000);
            } catch (err) {
              resultDiv.innerHTML = '❌ 错误: ' + err.message;
            }
          }

          // 页面加载时检查
          window.addEventListener('load', checkCapacitor);
        </script>
      </body>
    </html>
  `;

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="dark" />
      
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.title}>🎯 Macaron MiniApp 测试</Text>
        <Text style={styles.subtitle}>本地测试 @macaron/miniapp 模块</Text>
      </View>

      {/* Test Controls */}
      <View style={styles.controls}>
        <Button 
          title="🌐 加载 URL" 
          onPress={() => setCurrentTest('url')}
          color={currentTest === 'url' ? '#667eea' : '#999'}
        />
        <Button 
          title="📝 加载 HTML" 
          onPress={() => setCurrentTest('html')}
          color={currentTest === 'html' ? '#667eea' : '#999'}
        />
        <Button 
          title="🔌 测试 Capacitor" 
          onPress={() => setCurrentTest('capacitor')}
          color={currentTest === 'capacitor' ? '#667eea' : '#999'}
        />
      </View>

      {/* WebView Container */}
      <View style={styles.webviewContainer}>
        {currentTest === 'url' && (
          <MacaronMiniappView
            url="https://capacitorjs.com"
            style={styles.webview}
            onLoadEnd={() => {
              console.log('✅ URL 加载完成');
              Alert.alert('成功', 'URL 加载完成！');
            }}
            onError={(event) => {
              console.error('❌ 加载错误:', event.error);
              Alert.alert('错误', event.error);
            }}
          />
        )}

        {currentTest === 'html' && (
          <MacaronMiniappView
            html="<html><body style='display:flex;align-items:center;justify-content:center;height:100vh;font-family:sans-serif;background:linear-gradient(45deg,#f093fb,#f5576c);color:white;margin:0'><div style='text-align:center'><h1 style='font-size:48px;margin:0'>✨</h1><h2>HTML 内容测试</h2><p>这是直接加载的 HTML 内容</p><p style='opacity:0.8;font-size:14px'>时间: " + new Date().toLocaleTimeString() + "</p></div></body></html>"
            style={styles.webview}
            onLoadEnd={() => {
              console.log('✅ HTML 加载完成');
            }}
          />
        )}

        {currentTest === 'capacitor' && (
          <MacaronMiniappView
            html={testHTML}
            style={styles.webview}
            onLoadEnd={() => {
              console.log('✅ Capacitor 测试页面加载完成');
            }}
            onError={(event) => {
              console.error('❌ 加载错误:', event.error);
            }}
          />
        )}
      </View>

      {/* Info */}
      <View style={styles.info}>
        <Text style={styles.infoText}>
          💡 提示：切换不同测试查看效果
        </Text>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    padding: 20,
    backgroundColor: 'white',
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
  },
  subtitle: {
    fontSize: 14,
    color: '#666',
    marginTop: 4,
  },
  controls: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    padding: 10,
    backgroundColor: 'white',
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
  },
  webviewContainer: {
    flex: 1,
    backgroundColor: '#fff',
  },
  webview: {
    flex: 1,
  },
  info: {
    padding: 10,
    backgroundColor: '#fff3cd',
    borderTopWidth: 1,
    borderTopColor: '#ffc107',
  },
  infoText: {
    textAlign: 'center',
    color: '#856404',
    fontSize: 12,
  },
});
