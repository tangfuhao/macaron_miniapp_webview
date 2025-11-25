#!/bin/bash

# build-ios-xcframework.sh
# 構建 iOS XCFramework（包含 MacaronCapacitorBridge 和所有 Capacitor 依賴）
# 用於開發和發布前的準備

set -e

echo "🚀 開始構建 iOS XCFrameworks..."
echo ""

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
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

# 執行構建腳本
echo "📝 執行構建腳本..."
cd capacitor-native/ios/MacaronCapacitorBridge

if [ ! -f "build-xcframework.sh" ]; then
    echo -e "${RED}❌ 錯誤: build-xcframework.sh 不存在${NC}"
    exit 1
fi

./build-xcframework.sh
BUILD_RESULT=$?
cd ../../..

if [ $BUILD_RESULT -eq 0 ]; then
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ iOS XCFrameworks 構建成功！${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}生成的文件位置:${NC}"
    echo "  📁 packages/miniapp/ios/"
    echo ""
    
    # 顯示生成的 xcframeworks
    if [ -d "packages/miniapp/ios" ]; then
        FRAMEWORK_COUNT=$(find packages/miniapp/ios -maxdepth 1 -name "*.xcframework" -type d | wc -l | tr -d ' ')
        echo -e "${CYAN}包含 ${FRAMEWORK_COUNT} 個 XCFrameworks:${NC}"
        for fw_path in packages/miniapp/ios/*.xcframework; do
            if [ -d "$fw_path" ]; then
                echo "    ✓ $(basename $fw_path)"
            fi
        done | head -10
        if [ "$FRAMEWORK_COUNT" -gt 10 ]; then
            echo "    ... 及更多"
        fi
    fi
    
    echo ""
    echo -e "${CYAN}下一步:${NC}"
    echo "  1. cd example/ios && rm -rf Pods Podfile.lock && pod install"
    echo "  2. cd .. && npx expo run:ios"
    echo ""
else
    echo -e "${RED}❌ iOS XCFramework 構建失敗${NC}"
    exit 1
fi
