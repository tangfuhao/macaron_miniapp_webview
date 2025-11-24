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
  
  # Capacitor 依賴 - 使用與 App/Podfile 相同的路徑配置
  # 這樣在開發階段可以正確找到依賴
  s.dependency 'Capacitor', :path => '../../node_modules/@capacitor/ios'
  s.dependency 'CapacitorCordova', :path => '../../node_modules/@capacitor/ios'
  
  # Capacitor 插件依賴 - 使用完整路徑
  s.dependency 'CapacitorApp', :path => '../../node_modules/@capacitor/app'
  s.dependency 'CapacitorBrowser', :path => '../../node_modules/@capacitor/browser'
  s.dependency 'CapacitorCamera', :path => '../../node_modules/@capacitor/camera'
  s.dependency 'CapacitorClipboard', :path => '../../node_modules/@capacitor/clipboard'
  s.dependency 'CapacitorDevice', :path => '../../node_modules/@capacitor/device'
  s.dependency 'CapacitorFilesystem', :path => '../../node_modules/@capacitor/filesystem'
  s.dependency 'CapacitorGeolocation', :path => '../../node_modules/@capacitor/geolocation'
  s.dependency 'CapacitorHaptics', :path => '../../node_modules/@capacitor/haptics'
  s.dependency 'CapacitorKeyboard', :path => '../../node_modules/@capacitor/keyboard'
  s.dependency 'CapacitorLocalNotifications', :path => '../../node_modules/@capacitor/local-notifications'
  s.dependency 'CapacitorNetwork', :path => '../../node_modules/@capacitor/network'
  s.dependency 'CapacitorPreferences', :path => '../../node_modules/@capacitor/preferences'
  s.dependency 'CapacitorShare', :path => '../../node_modules/@capacitor/share'
  s.dependency 'CapacitorSplashScreen', :path => '../../node_modules/@capacitor/splash-screen'
  s.dependency 'CapacitorToast', :path => '../../node_modules/@capacitor/toast'
  
  # Community 插件
  s.dependency 'CapacitorCommunitySpeechRecognition', :path => '../../node_modules/@capacitor-community/speech-recognition'
  s.dependency 'CapacitorCommunityTextToSpeech', :path => '../../node_modules/@capacitor-community/text-to-speech'
  
  # Cordova 插件
  s.dependency 'CordovaPlugins', :path => '../capacitor-cordova-ios-plugins'
  s.dependency 'CordovaPluginsResources', :path => '../capacitor-cordova-ios-plugins'
  
  # Framework 設置
  s.static_framework = true
end

