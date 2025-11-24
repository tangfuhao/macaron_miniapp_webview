Pod::Spec.new do |s|
  s.name           = 'MacaronMiniapp'
  s.version        = '0.1.0'
  s.summary        = 'Macaron Mini App Loader - Web app container with Capacitor integration'
  s.description    = 'A powerful webview component for React Native with Capacitor bridge support'
  s.author         = 'Macaron Team'
  s.homepage       = 'https://github.com/yourusername/macaron-miniapp'
  s.platforms      = { :ios => '14.0', :tvos => '14.0' }
  s.source         = { git: '' }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'
  
  # 使用預編譯的 MacaronCapacitorBridge.xcframework
  # 這個 xcframework 包含了所有 Capacitor 依賴
  s.vendored_frameworks = 'MacaronCapacitorBridge.xcframework'
  
  # Swift version
  s.swift_version = '5.0'

  # Source files - 只包含此模塊的源文件，不包含 xcframework
  s.source_files = "*.{h,m,mm,swift,hpp,cpp}"
  
  # 排除 xcframework 目錄的內容（已通過 vendored_frameworks 引入）
  s.exclude_files = "MacaronCapacitorBridge.xcframework/**/*"
end
