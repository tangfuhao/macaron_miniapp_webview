#!/usr/bin/env ruby

# add-xcframework-target.rb
# 自动在 App.xcodeproj 中添加一个 Aggregate Target 用于构建 MacaronCapacitorBridge.xcframework

require 'xcodeproj'

project_path = File.join(__dir__, 'App/App.xcodeproj')
project = Xcodeproj::Project.open(project_path)

# 检查是否已存在此 target
existing_target = project.targets.find { |t| t.name == 'BuildMacaronCapacitorBridgeXCFramework' }

if existing_target
  puts "⚠️  Target 'BuildMacaronCapacitorBridgeXCFramework' 已存在"
  exit 0
end

puts "🚀 正在添加 Aggregate Target..."

# 创建 Aggregate Target
target = project.new_aggregate_target('BuildMacaronCapacitorBridgeXCFramework')

puts "✅ 已创建 Aggregate Target: #{target.name}"

# 添加 Run Script Phase
script_phase = target.new_shell_script_build_phase('Build XCFramework')
script_phase.shell_script = <<~SCRIPT
  set -e
  
  FRAMEWORK_NAME="MacaronCapacitorBridge"
  BUILD_DIR="${PROJECT_DIR}/../MacaronCapacitorBridge/build"
  OUTPUT_DIR="${PROJECT_DIR}/../MacaronCapacitorBridge/Products"
  
  echo "🚀 開始構建 ${FRAMEWORK_NAME}.xcframework..."
  
  # 清理舊的構建產物
  echo "🧹 清理舊構建..."
  rm -rf "${BUILD_DIR}"
  rm -rf "${OUTPUT_DIR}"
  
  echo "📦 編譯 iOS 設備架構..."
  xcodebuild archive \\
    -workspace "${PROJECT_DIR}/App.xcworkspace" \\
    -scheme "MacaronCapacitorBridge" \\
    -configuration Release \\
    -destination 'generic/platform=iOS' \\
    -archivePath "${BUILD_DIR}/ios.xcarchive" \\
    SKIP_INSTALL=NO \\
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \\
    CODE_SIGNING_ALLOWED=NO
  
  echo "📱 編譯 iOS 模擬器架構..."
  xcodebuild archive \\
    -workspace "${PROJECT_DIR}/App.xcworkspace" \\
    -scheme "MacaronCapacitorBridge" \\
    -configuration Release \\
    -destination 'generic/platform=iOS Simulator' \\
    -archivePath "${BUILD_DIR}/ios-simulator.xcarchive" \\
    SKIP_INSTALL=NO \\
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \\
    CODE_SIGNING_ALLOWED=NO
  
  echo "🔨 創建 XCFramework..."
  mkdir -p "${OUTPUT_DIR}"
  
  xcodebuild -create-xcframework \\
    -framework "${BUILD_DIR}/ios.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \\
    -framework "${BUILD_DIR}/ios-simulator.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \\
    -output "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"
  
  echo "✅ XCFramework 編譯完成!"
  echo "📍 位置: ${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"
  
  # 複製到 miniapp 的 ios 目錄
  MINIAPP_IOS="${PROJECT_DIR}/../../../packages/miniapp/ios"
  mkdir -p "${MINIAPP_IOS}"
  echo "📋 複製到 miniapp..."
  rm -rf "${MINIAPP_IOS}/${FRAMEWORK_NAME}.xcframework"
  cp -R "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework" "${MINIAPP_IOS}/"
  
  echo "🎉 完成！"
SCRIPT

script_phase.show_env_vars_in_log = '1'

puts "✅ 已添加 Run Script Build Phase"

# 保存项目
project.save

puts "✅ 項目已保存"
puts ""
puts "🎉 完成！現在你可以："
puts "  1. 打開 App.xcworkspace"
puts "  2. 選擇 'BuildMacaronCapacitorBridgeXCFramework' scheme"
puts "  3. 點擊 Product -> Build (⌘B)"
puts "  4. 在構建日誌中查看詳細輸出"
puts ""
puts "💡 提示：首次使用需要在 Xcode 中創建 MacaronCapacitorBridge scheme"

