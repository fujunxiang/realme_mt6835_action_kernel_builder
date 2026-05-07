#!/bin/bash
set -e

git clone --depth=1 https://github.com/realme-kernel-opensource/realme_11_5G_realme_narzo_60X5G_realme_C67_5G_realme_11x5G-AndroidU-kernel-source
mv realme_11_5G_realme_narzo_60X5G_realme_C67_5G_realme_11x5G-AndroidU-kernel-source kernel

git clone --depth=1 https://github.com/realme-kernel-opensource/realme_11_5G_realme_narzo_60X5G_realme_C67_5G_realme_11x5G-AndroidU-vendor-source
mv realme_11_5G_realme_narzo_60X5G_realme_C67_5G_realme_11x5G-AndroidU-vendor-source/vendor/ .

cp kernel/tools/ ./ -r