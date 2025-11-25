require 'json'

Pod::Spec.new do |s|
  s.name           = 'MacaronCapacitorBridge'
  s.version        = '1.0.0'
  s.summary        = 'Capacitor Bridge Framework for Macaron MiniApp'
  s.description    = <<-DESC
    A complete Capacitor bridge implementation that can be used in any iOS app.
    Includes WebView with full Capacitor plugin support.
  DESC
  
  s.homepage       = 'https://github.com/yourusername/macaron-miniapp'
  s.license        = { :type => 'MIT' }
  s.author         = { 'Macaron Team' => 'team@macaron.com' }
  s.source         = { :path => '.' }
  
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.0'
  
  # 源文件
  s.source_files = 'Sources/**/*.{swift,h,m}'
  
  # Capacitor 核心依賴
  # 注意：路徑配置在 Podfile 中，這裡只聲明依賴
  s.dependency 'Capacitor'
  s.dependency 'CapacitorCordova'
  
  # Capacitor 官方插件
  s.dependency 'CapacitorApp'
  s.dependency 'CapacitorBrowser'
  s.dependency 'CapacitorCamera'
  s.dependency 'CapacitorClipboard'
  s.dependency 'CapacitorDevice'
  s.dependency 'CapacitorFilesystem'
  s.dependency 'CapacitorGeolocation'
  s.dependency 'CapacitorHaptics'
  s.dependency 'CapacitorKeyboard'
  s.dependency 'CapacitorLocalNotifications'
  s.dependency 'CapacitorNetwork'
  s.dependency 'CapacitorPreferences'
  s.dependency 'CapacitorShare'
  s.dependency 'CapacitorSplashScreen'
  s.dependency 'CapacitorToast'
  
  # Capacitor 社群插件
  s.dependency 'CapacitorCommunitySpeechRecognition'
  s.dependency 'CapacitorCommunityTextToSpeech'
  
  # Cordova 插件
  s.dependency 'CordovaPlugins'
  s.dependency 'CordovaPluginsResources'
  
  # Framework 設置 - 使用靜態框架以便合併
  s.static_framework = true
end

