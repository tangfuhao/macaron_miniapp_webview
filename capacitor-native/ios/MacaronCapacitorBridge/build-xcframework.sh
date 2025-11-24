#!/bin/bash

# build-xcframework.sh
# 編譯 MacaronCapacitorBridge.xcframework
# 這個腳本會創建一個包含模擬器和真機架構的 XCFramework

set -e

FRAMEWORK_NAME="MacaronCapacitorBridge"
SCHEME_NAME="MacaronCapacitorBridge"
BUILD_DIR="./build"
OUTPUT_DIR="./Products"
WORKSPACE="../App/App.xcworkspace"

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

echo "✅ XCFramework 編譯完成!"
echo "📍 位置: ${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework"

# 複製到 miniapp 的 ios 目錄
MINIAPP_IOS="../../../packages/miniapp/ios"
mkdir -p "${MINIAPP_IOS}"
echo "📋 複製到 miniapp..."
rm -rf "${MINIAPP_IOS}/${FRAMEWORK_NAME}.xcframework"
cp -R "${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework" "${MINIAPP_IOS}/"

echo "🎉 完成！XCFramework 已準備好供 miniapp 使用"
echo ""
echo "📝 注意事項:"
echo "   1. XCFramework 已複製到: ${MINIAPP_IOS}/${FRAMEWORK_NAME}.xcframework"
echo "   2. miniapp 的 podspec 應配置為使用 vendored_frameworks"
echo "   3. 發布到 npm 時需要包含此 xcframework"
echo "   4. xcframework 大小較大，建議在 .gitignore 排除（開發階段生成）"

