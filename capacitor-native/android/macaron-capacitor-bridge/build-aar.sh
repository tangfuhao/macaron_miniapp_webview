#!/bin/bash

# build-aar.sh
# 編譯 MacaronCapacitorBridge.aar
# 這個腳本會創建一個包含所有 Capacitor 依賴的 AAR 庫

set -e

LIBRARY_NAME="macaron-capacitor-bridge"
OUTPUT_DIR="./build/outputs/aar"
MINIAPP_LIBS="../../packages/miniapp/android/libs"

echo "🚀 開始編譯 ${LIBRARY_NAME}.aar..."

# 清理舊的構建產物
echo "🧹 清理舊構建..."
cd ..
./gradlew :${LIBRARY_NAME}:clean

# 編譯 Release AAR
echo "📦 編譯 Release AAR..."
./gradlew :${LIBRARY_NAME}:assembleRelease

# 檢查 AAR 是否生成成功
AAR_FILE="${LIBRARY_NAME}/${OUTPUT_DIR}/${LIBRARY_NAME}-release.aar"
if [ ! -f "$AAR_FILE" ]; then
    echo "❌ 錯誤: AAR 文件未生成"
    exit 1
fi

echo "✅ AAR 編譯完成!"
echo "📍 位置: ${AAR_FILE}"

# 創建 miniapp 的 libs 目錄
mkdir -p "${MINIAPP_LIBS}"

# 複製到 miniapp 的 libs 目錄
echo "📋 複製到 miniapp..."
cp "${AAR_FILE}" "${MINIAPP_LIBS}/${LIBRARY_NAME}.aar"

echo "🎉 完成！AAR 已準備好供 miniapp 使用"
echo ""
echo "📝 注意事項:"
echo "   1. AAR 已複製到: packages/miniapp/android/libs/${LIBRARY_NAME}.aar"
echo "   2. miniapp 的 build.gradle 應配置為使用此 AAR"
echo "   3. Git 會忽略此 AAR，但 npm publish 時會包含（正確✅）"
echo "   4. 發布到 npm 前會自動運行 prepublishOnly 重新生成"

