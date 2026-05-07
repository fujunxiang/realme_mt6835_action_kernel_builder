#!/bin/bash

# prebuild_download.sh
# Script to download Android kernel prebuilts into ./prebuilts with custom structure

set -e

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Toolchain Base (Local directory)
TOOLCHAIN_DIR="$(pwd)/prebuilts"

# Sub-directories as requested
CLANG_DIR="$TOOLCHAIN_DIR/clang/host/linux-x86/clang-r450784e"
GCC64_DIR="$TOOLCHAIN_DIR/gcc/linux-x86/aarch64/aarch64-linux-gnu"
GCC32_DIR="$TOOLCHAIN_DIR/gcc/linux-x86/arm/arm-linux-gnueabi"
BUILD_TOOLS_DIR="$TOOLCHAIN_DIR/build-tools/linux-x86/bin"
BISON_DATA_DIR="$TOOLCHAIN_DIR/build-tools/common/bison"

echo -e "${BLUE}==> Preparing toolchain directories in $TOOLCHAIN_DIR...${NC}"
mkdir -p "$TOOLCHAIN_DIR"

# 1. Download Clang r450784e
if [ ! -d "$CLANG_DIR" ]; then
    echo -e "${BLUE}==> Fetching Clang r450784e into $(dirname "$CLANG_DIR")...${NC}"
    mkdir -p "$(dirname "$CLANG_DIR")"
    cd "$(dirname "$CLANG_DIR")"
    
    # Use sparse-checkout to get only the requested version
    git clone --depth 1 --filter=blob:none --sparse -b master-kernel-build-2022 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 clang-temp
    cd clang-temp
    git sparse-checkout set clang-r450784e
    mv clang-r450784e ..
    cd ..
    rm -rf clang-temp
    echo -e "${GREEN}Successfully fetched Clang r450784e.${NC}"
    cd "$TOOLCHAIN_DIR/.."
else
    echo -e "${GREEN}Clang r450784e already exists, skipping.${NC}"
fi

# 2. Clone GCC Aarch64
if [ ! -d "$GCC64_DIR" ]; then
    echo -e "${BLUE}==> Cloning GCC Aarch64 4.9 into $GCC64_DIR...${NC}"
    mkdir -p "$(dirname "$GCC64_DIR")"
    git clone --depth 1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 "$GCC64_DIR"
    echo -e "${GREEN}Successfully cloned GCC Aarch64.${NC}"
else
    echo -e "${GREEN}GCC Aarch64 already exists, skipping.${NC}"
fi

# 3. Clone GCC Arm
if [ ! -d "$GCC32_DIR" ]; then
    echo -e "${BLUE}==> Cloning GCC Arm 4.9 into $GCC32_DIR...${NC}"
    mkdir -p "$(dirname "$GCC32_DIR")"
    git clone --depth 1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 "$GCC32_DIR"
    echo -e "${GREEN}Successfully cloned GCC Arm.${NC}"
else
    echo -e "${GREEN}GCC Arm already exists, skipping.${NC}"
fi

# 4. Clone Build Tools
if [ ! -d "$TOOLCHAIN_DIR/build-tools" ]; then
    echo -e "${BLUE}==> Cloning Build Tools into $TOOLCHAIN_DIR/build-tools...${NC}"
    git clone --depth 1 https://android.googlesource.com/platform/prebuilts/build-tools "$TOOLCHAIN_DIR/build-tools"
    echo -e "${GREEN}Successfully cloned Build Tools.${NC}"
else
    echo -e "${GREEN}Build Tools already exists, skipping.${NC}"
fi

echo -e "\n${BLUE}==> Prebuilts setup complete!${NC}"
echo -e "Toolchain Base:  $TOOLCHAIN_DIR"
echo -e "Clang:           $CLANG_DIR"
echo -e "GCC64:           $GCC64_DIR"
echo -e "GCC32:           $GCC32_DIR"
echo -e "Build Tools Bin: $BUILD_TOOLS_DIR"
echo -e "Bison Data:      $BISON_DATA_DIR"

echo -e "\nTo use these in your build environment, export the following:"
echo -e "  export PATH=\"$CLANG_DIR/bin:$GCC64_DIR/bin:$GCC32_DIR/bin:$BUILD_TOOLS_DIR:\$PATH\""
