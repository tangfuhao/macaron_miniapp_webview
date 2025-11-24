#!/bin/bash

# build-ios-xcframework.sh
# 構建 iOS XCFramework
# 用於開發和發布前的準備

set -e

echo "🚀 開始構建 iOS XCFramework..."
echo ""

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 檢查是否在正確的目錄
if [ ! -d "capacitor-native" ]; then
    echo -e "${RED}❌ 錯誤: 請在項目根目錄運行此腳本${NC}"
    exit 1
fi

# 檢查是否安裝了 Pods
if [ ! -d "capacitor-native/ios/App/Pods" ]; then
    echo -e "${YELLOW}⚠️  Pods 未安裝，正在安裝...${NC}"
    cd capacitor-native/ios/App
    pod install
    cd ../../..
fi

# 優先使用 Xcode 構建（如果可用）
USE_XCODE=false
if command -v xcodebuild &> /dev/null; then
    # 檢查 scheme 是否存在
    cd capacitor-native/ios/App
    if xcodebuild -workspace App.xcworkspace -list 2>/dev/null | grep -q "BuildMacaronCapacitorBridgeXCFramework"; then
        USE_XCODE=true
        echo "✨ 使用 Xcode Aggregate Target 構建..."
        xcodebuild -workspace App.xcworkspace \
          -scheme BuildMacaronCapacitorBridgeXCFramework \
          -configuration Release \
          build
    fi
    cd ../../..
fi

# 如果 Xcode 方式不可用，使用腳本
if [ "$USE_XCODE" = false ]; then
    echo "📝 使用構建腳本..."
    cd capacitor-native/ios/MacaronCapacitorBridge
    
    if [ ! -f "build-xcframework.sh" ]; then
        echo -e "${RED}❌ 錯誤: build-xcframework.sh 不存在${NC}"
        exit 1
    fi
    
    ./build-xcframework.sh
    cd ../../..
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ iOS XCFramework 構建成功${NC}"
    echo ""
    echo "生成的文件："
    echo "  📱 iOS: packages/miniapp/ios/MacaronCapacitorBridge.xcframework"
    echo ""
else
    echo -e "${RED}❌ iOS XCFramework 構建失敗${NC}"
    exit 1
fi

