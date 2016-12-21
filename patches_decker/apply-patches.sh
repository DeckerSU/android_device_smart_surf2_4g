#!/bin/bash
clear
cd ../../../..
cd frameworks/av
git apply -v  ../../device/mts/smart_surf2_4g/patches_decker/0001-mtk-audio-fix.patch
git apply -v  ../../device/mts/smart_surf2_4g/patches_decker/0002-fix-access-wvm-to-ReadOptions.patch
git apply -v  ../../device/mts/smart_surf2_4g/patches_decker/0003-add-mising-MediaBufferGroup-acquire_buffer-symbol.patch
git apply -v  ../../device/mts/smart_surf2_4g/patches_decker/0004-add-mising-MediaBufferGroup-acquire_buffer-symbol-2.patch
git apply -v  ../../device/mts/smart_surf2_4g/patches_decker/0007-Use-hw-encoder-only-for-camera-fire855.patch
cd ../..
cd frameworks/native
git apply -v  ../../device/mts/smart_surf2_4g/patches_decker/0005-_ZN7android13GraphicBufferC1Ejjij-symbol-fix-on-fram.patch
cd ../..
cd packages/apps/Settings
git apply -v  ../../../device/mts/smart_surf2_4g/patches_decker/0006-add-author-info-in-device-info.patch
cd ../../..

#echo "Проверьте, все ли патчи из каталога прописаны в скрипте!"
#echo Patches Applied Successfully!
