## Specify phone tech before including full_phone

# Release name
PRODUCT_RELEASE_NAME := smart_surf2_4g

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/mts/smart_surf2_4g/device_smart_surf2_4g.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := smart_surf2_4g
PRODUCT_NAME := lineage_smart_surf2_4g
PRODUCT_BRAND := MTS
PRODUCT_MODEL := Smart Surf2 4G
PRODUCT_MANUFACTURER := mts
