DEVICE_PATH := device/mts/smart_surf2_4g
VENDOR_PATH := vendor/mts/smart_surf2_4g

USE_CAMERA_STUB := true

FORCE_32_BIT = true

# inherit from the proprietary version
-include $(VENDOR_PATH)/BoardConfigVendor.mk

TARGET_BOARD_PLATFORM := mt6737m

# Architecture
ifeq ($(FORCE_32_BIT),true)
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53
else
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53
endif

TARGET_NO_BOOTLOADER := true
TARGET_CPU_SMP := true

ARCH_ARM_HAVE_TLS_REGISTER := true
ARCH_ARM_HAVE_NEON := true
ARCH_ARM_HAVE_VFP := true

TARGET_GLOBAL_CFLAGS   += -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mfpu=neon -mfloat-abi=softfp
TARGET_USERIMAGES_USE_EXT4:=true

TARGET_BOOTLOADER_BOARD_NAME := mt6737m

BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,32N2 androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x40000000
#extracted from stock recovery
BOARD_KERNEL_PAGESIZE := 2048
BOARD_RAMDISK_OFFSET := 0x04000000

#extracted from /proc/partinfo
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216 
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216 
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 3975675904 
BOARD_CACHEIMAGE_PARTITION_SIZE := 419430400

#pagesize * 64
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x04000000 --tags_offset 0x0e000000 --board 1473313359

#in case we want to build kernel from source
# uncomment the following lines
#TARGET_KERNEL_SOURCE := kernel/mts/smart_surf2_4g
#TARGET_KERNEL_CONFIG := smart_surf2_4g_debug_defconfig
#TARGET_KERNEL_CROSS_COMPILE_PREFIX := arm-linux-android-
#BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
# end of commented lines

#for now lets use prebuilt
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz-dtb
BOARD_HAS_NO_SELECT_BUTTON := true
#recovery
#TARGET_RECOVERY_INITRC := $(DEVICE_PATH)/recovery/init.mt6753.rc
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/fstab.mt6735
TARGET_RECOVERY_LCD_BACKLIGHT_PATH := \"/sys/devices/platform/leds-mt65xx/leds/lcd-backlight/brightness\"

#system.prop
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop

# WiFi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_FW_PATH_PARAM:="/dev/wmtWifi"
WIFI_DRIVER_FW_PATH_STA:=STA
WIFI_DRIVER_FW_PATH_AP:=AP
WIFI_DRIVER_FW_PATH_P2P:=P2P

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_MTK := true
BOARD_BLUETOOTH_DOES_NOT_USE_RFKILL := true

#twrp ( WIP do not use!!! see comments )

#tw_theme is essential flag
TW_THEME := portrait_hdpi

#brightness settings (needs verification)
TW_BRIGHTNESS_PATH := /sys/devices/platform/leds-mt65xx/leds/lcd-backlight/brightness/
TW_MAX_BRIGHTNESS := 255

#may be usefull if we get graphical glitches
#RECOVERY_GRAPHICS_USE_LINELENGTH := true

#in case of wrong color this needs modification
#TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"

#if sdcard0 is a /data/media emulated one
#RECOVERY_SDCARD_ON_DATA := true

#ntfs support? (needs much space..)
#TW_INCLUDE_NTFS_3G := true

#we may need that if sdcard0 dont work
#TW_FLASH_FROM_STORAGE := true
#TW_EXTERNAL_STORAGE_PATH := "/external_sd"
#TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"
#TW_DEFAULT_EXTERNAL_STORAGE := true

#only add if kernel supports
#TW_INCLUDE_FUSE_EXFAT := true

#F2FS support (only activate if kernel supports)
#TARGET_USERIMAGES_USE_F2FS:=true


#Mediatek flags
BOARD_HAS_MTK_HARDWARE := true
BOARD_USES_MTK_HARDWARE := true
MTK_HARDWARE := true
#COMMON_GLOBAL_CFLAGS += -DMTK_HARDWARE -DMTK_AOSP_ENHANCEMENT
#COMMON_GLOBAL_CPPFLAGS += -DMTK_HARDWARE -DMTK_AOSP_ENHANCEMENT

#EGL settings
USE_OPENGL_RENDERER := true
BOARD_EGL_CFG := $(DEVICE_PATH)/egl.cfg

# CyanogenMod Hardware Hooks
# BOARD_HARDWARE_CLASS := $(DEVICE_PATH)/cmhw/

# RIL
BOARD_RIL_CLASS := ../../../$(DEVICE_PATH)/ril

BOARD_SEPOLICY_DIRS := $(DEVICE_PATH)/sepolicy

TARGET_LDPRELOAD += libxlog.so:libmtk_symbols.so
#TARGET_LDPRELOAD += libxlog.so

BOARD_SECCOMP_POLICY := $(DEVICE_PATH)/seccomp

TARGET_TAP_TO_WAKE_NODE := /sys/devices/mx_tsp/gesture_control

# [+] Decker
BLOCK_BASED_OTA := false
# Test (for using modified framework)
BOARD_USES_LEGACY_MTK_AV_BLOB := true
BOARD_HAS_MTK_HARDWARE := true

#Don't enable this strings ... Just for test ...

#TARGET_USES_MEDIA_EXTENSIONS := false
#TARGET_HAS_LEGACY_CAMERA_HAL1 := true

# Mediatek 
#ifeq ($(BOARD_HAS_MTK_HARDWARE),true)
#MTK_GLOBAL_C_INCLUDES:=
#MTK_GLOBAL_CFLAGS:=
#MTK_GLOBAL_CONLYFLAGS:=
#MTK_GLOBAL_CPPFLAGS:=
#MTK_GLOBAL_LDFLAGS:=

#MTK_GLOBAL_CFLAGS += -DMTK_AOSP_ENHANCEMENT
#MTK_PATH_SOURCE := vendor/mediatek/proprietary
#MTK_ROOT := vendor/mediatek/proprietary

#$(info *** Mediatek Platform Used ***)
#endif

