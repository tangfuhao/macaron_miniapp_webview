#!/bin/bash

# build-native-libs.sh
# 構建所有原生庫（iOS xcframework 和 Android AAR）
# 用於開發和發布前的準備
# 
# 這是一個主腳本，會依次調用：
#   - build-ios-xcframework.sh
#   - build-android-aar.sh

set -e

echo "🚀 開始構建原生庫..."
echo ""

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 檢查是否在正確的目錄
if [ ! -d "capacitor-native" ] || [ ! -d "packages/miniapp" ]; then
    echo -e "${RED}❌ 錯誤: 請在項目根目錄運行此腳本${NC}"
    exit 1
fi

echo "================================"
echo "📦 1/2 構建 iOS XCFramework"
echo "================================"
echo ""

# 調用 iOS 構建腳本
if [ ! -f "build-ios-xcframework.sh" ]; then
    echo -e "${RED}❌ 錯誤: build-ios-xcframework.sh 不存在${NC}"
    exit 1
fi

./build-ios-xcframework.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ iOS XCFramework 構建失敗${NC}"
    exit 1
fi

echo ""
echo "================================"
echo "📦 2/2 構建 Android AAR"
echo "================================"
echo ""

# 調用 Android 構建腳本
if [ ! -f "build-android-aar.sh" ]; then
    echo -e "${RED}❌ 錯誤: build-android-aar.sh 不存在${NC}"
    exit 1
fi

./build-android-aar.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Android AAR 構建失敗${NC}"
    exit 1
fi

echo ""
echo "================================"
echo "🎉 所有原生庫構建完成！"
echo "================================"
echo ""
echo "生成的文件："
echo "  📱 iOS:     packages/miniapp/ios/MacaronCapacitorBridge.xcframework"
echo "  🤖 Android: packages/miniapp/android/libs/macaron-capacitor-bridge.aar"
echo ""
echo "下一步："
echo "  1. 在 example 項目中測試: cd example && npm start"
echo "  2. 發布到 npm: cd packages/miniapp && npm publish"
echo ""
echo "提示："
echo "  - 單獨構建 iOS: ./build-ios-xcframework.sh"
echo "  - 單獨構建 Android: ./build-android-aar.sh"
echo ""

