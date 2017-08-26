PRODUCT_BRAND ?= deso

# use specific resolution for bootanimation
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/bootanimation/1440.zip:system/media/bootanimation.zip

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# general properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.build.selinux=1

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/deso/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \

# init.d support
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/deso/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# Init script file with omni extras
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/etc/init.local.rc:root/init.deso.rc

# Enable SIP and VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Additional packages
-include vendor/deso/utils/emulator/packages.mk

# Add our overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/deso/overlay/common

WITH_DEXPREOPT := true

# Versioning
-include vendor/deso/config/common.mk
