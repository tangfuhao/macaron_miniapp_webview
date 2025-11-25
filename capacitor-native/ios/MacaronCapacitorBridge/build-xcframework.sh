#!/bin/bash

# build-xcframework.sh
# 編譯 MacaronCapacitorBridge.xcframework 及所有依賴
# 這個腳本會創建包含模擬器和真機架構的 XCFrameworks

set -e

FRAMEWORK_NAME="MacaronCapacitorBridge"
SCHEME_NAME="MacaronCapacitorBridge"
BUILD_DIR="./build"
OUTPUT_DIR="./Products"
WORKSPACE="../App/App.xcworkspace"
MINIAPP_IOS="../../../packages/miniapp/ios"

echo "🚀 開始編譯 ${FRAMEWORK_NAME}.xcframework..."

# 檢查 workspace 是否存在
if [ ! -d "${WORKSPACE}" ]; then
    echo "❌ 錯誤: Workspace 不存在: ${WORKSPACE}"
    echo "💡 請先在 capacitor-native/ios/App 目錄運行 'pod install'"
    exit 1
fi

# 清理舊的構建產物
echo "🧹 清理舊構建..."
rm -rf "${BUILD_DIR}"
rm -rf "${OUTPUT_DIR}"

# 檢查 scheme 是否存在
echo "🔍 檢查 scheme..."
xcodebuild -workspace "${WORKSPACE}" -list | grep "${SCHEME_NAME}" > /dev/null || {
    echo "❌ 錯誤: Scheme '${SCHEME_NAME}' 不存在"
    echo "💡 可用的 schemes:"
    xcodebuild -workspace "${WORKSPACE}" -list | grep -A 100 "Schemes:"
    exit 1
}

echo "📦 編譯 iOS 設備架構..."
xcodebuild archive \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME_NAME}" \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "${BUILD_DIR}/ios.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CODE_SIGNING_ALLOWED=NO

echo "📱 編譯 iOS 模擬器架構..."
xcodebuild archive \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME_NAME}" \
  -configuration Release \
  -destination 'generic/platform=iOS Simulator' \
  -archivePath "${BUILD_DIR}/ios-simulator.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CODE_SIGNING_ALLOWED=NO

echo "🔨 創建 XCFramework..."
mkdir -p "${OUTPUT_DIR}"

xcodebuild -create-xcframework \
  -framework "${BUILD_DIR}/ios.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -framework "${BUILD_DIR}/ios-simulator.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -output "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"

echo "✅ MacaronCapacitorBridge.xcframework 編譯完成!"

# ========================================
# 複製所有 XCFrameworks 到 miniapp/ios
# ========================================

echo ""
echo "📋 複製所有 XCFrameworks 到 packages/miniapp/ios..."

# 清理舊的 xcframeworks
rm -rf "${MINIAPP_IOS}"/*.xcframework
mkdir -p "${MINIAPP_IOS}"

# 1. 複製 MacaronCapacitorBridge
cp -R "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework" "${MINIAPP_IOS}/"
echo "  ✓ ${FRAMEWORK_NAME}.xcframework"

# 2. 從構建的 archive 中為每個 Capacitor framework 創建 XCFramework
ARCHIVE_FRAMEWORKS="${BUILD_DIR}/ios-simulator.xcarchive/Products/Library/Frameworks"

for fw in "${ARCHIVE_FRAMEWORKS}"/*.framework; do
    if [ -d "$fw" ]; then
        fw_name=$(basename "$fw" .framework)
        if [ "$fw_name" != "$FRAMEWORK_NAME" ]; then
            xcodebuild -create-xcframework \
              -framework "${BUILD_DIR}/ios.xcarchive/Products/Library/Frameworks/${fw_name}.framework" \
              -framework "${BUILD_DIR}/ios-simulator.xcarchive/Products/Library/Frameworks/${fw_name}.framework" \
              -output "${MINIAPP_IOS}/${fw_name}.xcframework" \
              > /dev/null 2>&1 && echo "  ✓ ${fw_name}.xcframework" || echo "  ⚠️ ${fw_name} 創建失敗"
        fi
    fi
done

# 3. 複製 ION 依賴庫（從 Pods 目錄）
PODS_DIR="../App/Pods"
for ion_pod in "${PODS_DIR}"/ION*; do
    if [ -d "$ion_pod" ]; then
        ion_name=$(basename "$ion_pod")
        if [ -d "${ion_pod}/${ion_name}.xcframework" ]; then
            cp -R "${ion_pod}/${ion_name}.xcframework" "${MINIAPP_IOS}/"
            echo "  ✓ ${ion_name}.xcframework (from Pods)"
        fi
    fi
done

# ========================================
# 更新 podspec 中的 vendored_frameworks
# ========================================

echo ""
echo "📝 更新 MacaronMiniapp.podspec..."

# 生成 podspec
cat > "${MINIAPP_IOS}/MacaronMiniapp.podspec" << 'PODSPEC_HEADER'
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
PODSPEC_HEADER

# 添加所有 xcframeworks（只取目錄名）
for fw_path in "${MINIAPP_IOS}"/*.xcframework; do
    if [ -d "$fw_path" ]; then
        fw_name=$(basename "$fw_path")
        echo "    '${fw_name}'," >> "${MINIAPP_IOS}/MacaronMiniapp.podspec"
    fi
done

cat >> "${MINIAPP_IOS}/MacaronMiniapp.podspec" << 'PODSPEC_FOOTER'
  ]
  
  s.swift_version = '5.0'
  s.source_files = "*.{h,m,mm,swift,hpp,cpp}"
  s.exclude_files = "*.xcframework/**/*"
end
PODSPEC_FOOTER

# 統計 xcframework 數量
FRAMEWORK_COUNT=$(find "${MINIAPP_IOS}" -maxdepth 1 -name "*.xcframework" -type d | wc -l | tr -d ' ')

echo ""
echo "🎉 完成！打包結果："
echo ""
echo "📍 XCFrameworks 位置: ${MINIAPP_IOS}/"
echo "   共 ${FRAMEWORK_COUNT} 個 XCFrameworks"
echo ""
echo "📄 Podspec: ${MINIAPP_IOS}/MacaronMiniapp.podspec"
echo ""
echo "下一步: 在 example/ios 目錄執行 'pod install' 然後 'npx expo run:ios'"
