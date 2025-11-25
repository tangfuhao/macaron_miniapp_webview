Pod::Spec.new do |s|
  s.name           = 'MacaronMiniapp'
  s.version        = '1.0.0'
  s.summary        = 'Macaron Mini App Loader - Web app container with Capacitor integration'
  s.description    = 'A powerful webview component for React Native with Capacitor bridge support'
  s.author         = 'Macaron Team'
  s.homepage       = 'https://github.com/yourusername/macaron-miniapp'
  s.platforms      = { :ios => '15.1' }
  s.source         = { git: '' }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'
  
  # 使用預編譯的 XCFrameworks
  s.vendored_frameworks = [
    'Capacitor.xcframework',
    'CapacitorApp.xcframework',
    'CapacitorBrowser.xcframework',
    'CapacitorCamera.xcframework',
    'CapacitorClipboard.xcframework',
    'CapacitorCommunitySpeechRecognition.xcframework',
    'CapacitorCommunityTextToSpeech.xcframework',
    'CapacitorDevice.xcframework',
    'CapacitorFilesystem.xcframework',
    'CapacitorGeolocation.xcframework',
    'CapacitorHaptics.xcframework',
    'CapacitorKeyboard.xcframework',
    'CapacitorLocalNotifications.xcframework',
    'CapacitorNetwork.xcframework',
    'CapacitorPreferences.xcframework',
    'CapacitorShare.xcframework',
    'CapacitorSplashScreen.xcframework',
    'CapacitorToast.xcframework',
    'Cordova.xcframework',
    'CordovaPlugins.xcframework',
    'IONFilesystemLib.xcframework',
    'IONGeolocationLib.xcframework',
    'MacaronCapacitorBridge.xcframework',
  ]
  
  s.swift_version = '5.0'
  s.source_files = "*.{h,m,mm,swift,hpp,cpp}"
  s.exclude_files = "*.xcframework/**/*"
end
