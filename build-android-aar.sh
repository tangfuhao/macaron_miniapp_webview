#!/bin/bash

# build-android-aar.sh
# 構建 Android AAR
# 用於開發和發布前的準備

set -e

echo "🚀 開始構建 Android AAR..."
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

cd capacitor-native/android/macaron-capacitor-bridge

if [ ! -f "build-aar.sh" ]; then
    echo -e "${RED}❌ 錯誤: build-aar.sh 不存在${NC}"
    exit 1
fi

./build-aar.sh

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Android AAR 構建成功${NC}"
    echo ""
    echo "生成的文件："
    echo "  🤖 Android: packages/miniapp/android/libs/macaron-capacitor-bridge.aar"
    echo ""
else
    echo -e "${RED}❌ Android AAR 構建失敗${NC}"
    exit 1
fi

cd ../../..

