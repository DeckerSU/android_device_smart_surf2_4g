## Specify phone tech before including full_phone
#$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := Smart Surf2 4G

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/mts/smart_surf2_4g/device_smart_surf2_4g.mk)

# Configure dalvik heap
$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)

TARGET_SCREEN_HEIGHT := 1280
TARGET_SCREEN_WIDTH := 720

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := smart_surf2_4g
PRODUCT_NAME := cm_smart_surf2_4g
PRODUCT_BRAND := MTS
PRODUCT_MODEL := Smart Surf2 4G
PRODUCT_MANUFACTURER := MTS
