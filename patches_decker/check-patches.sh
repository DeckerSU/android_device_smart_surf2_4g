#!/bin/bash
cd ../../../..
cd frameworks/av
git apply -v --check ../../device/mts/smart_surf2_4g/patches_decker/0001-mtk-audio-fix.patch
git apply -v --check ../../device/mts/smart_surf2_4g/patches_decker/0002-fix-access-wvm-to-ReadOptions.patch
cd ../..
echo Patches Applied Successfully!
