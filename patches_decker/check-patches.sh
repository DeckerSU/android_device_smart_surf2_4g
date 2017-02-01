#!/bin/bash
cd ../../../..
cd system/core
git apply -v --check ../../device/mts/smart_surf2_4g/patches_decker/0001-libnetutils-add-MTK-bits.patch
git apply -v --check ../../device/mts/smart_surf2_4g/patches_decker/0002-xen0n-some-MTK-services-e.g.-ril-daemon-mtk-require-.patch
cd ../..
cd packages/apps/Settings
git apply -v --check ../../../device/mts/smart_surf2_4g/patches_decker/0003-add-author-info-in-device-info.patch
cd ../../..
cd frameworks/av
git apply -v --check ../../device/mts/smart_surf2_4g/patches_decker/0006-Implement-mtk-color-format-support-fire855.patch
cd ../..
cd packages/apps/FMRadio/jni/fmr/ 
git apply -v --check ../../../../../device/mts/smart_surf2_4g/patches_decker/0007-fix-fm-radio-power-up-mt6737m-mt6627-chip.patch
cd ../../../../..
cd system/netd/server/
git apply -v --check ../../../device/mts/smart_surf2_4g/patches_decker/0008-WiFi-AP-fix.patch
cd ../../..
