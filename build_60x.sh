#!/bin/bash
set -e

cp ./60x_defconfig ./kernel/arch/arm64/configs/


# Fix vendor symlinks
ln -sfn ../../../../kernel/drivers/power vendor/oplus/kernel-5.15/drivers
ln -sfn ../../../../../../kernel/drivers/gpu/drm/mediatek vendor/oplus/kernel-5.15/drivers/gpu/drm

# Toolchains
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TOOLCHAIN_DIR="$SCRIPT_DIR/prebuilts"

CLANG_DIR=$TOOLCHAIN_DIR/clang/host/linux-x86/clang-r450784e
GCC64_DIR=$TOOLCHAIN_DIR/gcc/linux-x86/aarch64/aarch64-linux-gnu
GCC32_DIR=$TOOLCHAIN_DIR/gcc/linux-x86/arm/arm-linux-gnueabi
BUILD_TOOLS_DIR=$TOOLCHAIN_DIR/build-tools/linux-x86/bin
BISON_DATA_DIR=$TOOLCHAIN_DIR/build-tools/common/bison

export PATH=$CLANG_DIR/bin:$GCC64_DIR/bin:$GCC32_DIR/bin:$BUILD_TOOLS_DIR:$PATH

export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
export CC=clang
export LLVM=1
export LLVM_IAS=1
export BISON_PKGDATADIR=$BISON_DATA_DIR
export M4=$BUILD_TOOLS_DIR/m4

# Minimal flags only (DON’T over-inject)
export KCFLAGS="
-ferror-limit=1000 \
-I../../vendor/oplus/kernel-5.15/drivers/gpu/drm/ \
"

# Build
cd kernel

echo "Using 60x_defconfig..."
make O=out 60x_defconfig

echo "Starting build..."
make O=out -j4
