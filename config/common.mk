PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup Tool
ifneq ($(WITH_GMS),true)
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/deso/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/deso/prebuilt/common/bin/50-candy.sh:system/addon.d/50-candy.sh \
    vendor/deso/prebuilt/common/bin/blacklist:system/addon.d/blacklist
endif

# Desolation backuptool
PRODUCT_PROPERTY_OVERRIDES += \
    ro.desobackuptool.version=mm6.0

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# DESO-specific init file
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/etc/init.local.rc:root/init.deso.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# superSU
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/etc/SuperSU.zip:system/addon.d/SuperSU.zip \
    vendor/deso/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/deso/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/deso/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/deso/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/deso/prebuilt/common/bin/sysinit:system/bin/sysinit

# Required packages
PRODUCT_PACKAGES += \
    Launcher3 \
    CellBroadcastReceiver \
    Development \
    SpareParts \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

# AudioFX
PRODUCT_PACKAGES += \
    AudioFX

# Extra Optional packages
PRODUCT_PACKAGES += \
    LatinIME \
    BluetoothExt \
    NovaLauncher \
    DesolatedCore \
    org.dirtyunicorns.utils
#   DesolatedDelta

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/deso/overlay/common

# Versioning System
# Desolation first version.
PRODUCT_VERSION_MAJOR = 6.0.1
PRODUCT_VERSION_MINOR = v1.0
#PRODUCT_VERSION_MAINTENANCE = MM
ifdef DESO_BUILD_EXTRA
    DESO_POSTFIX := -$(DESO_BUILD_EXTRA)
endif

ifndef DESO_BUILD_TYPE
    DESO_BUILD_TYPE := PreRelease
    DESO_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif

# Set all versions
DESO_VERSION := DesolationRom-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(DESO_BUILD_TYPE)$(DESO_POSTFIX)
OTA_VERSION := $(TARGET_PRODUCT)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(DESO_BUILD_TYPE)$(DESO_POSTFIX)
DESO_MOD_VERSION := DesolationRom-$(DESO_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(DESO_BUILD_TYPE)$(DESO_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    deso.ota.version=$(OTA_VERSION) \
    ro.deso.version=$(DESO_VERSION) \
    ro.modversion=$(DESO_MOD_VERSION) \
    ro.deso.buildtype=$(DESO_BUILD_TYPE)

EXTENDED_POST_PROCESS_PROPS := vendor/deso/tools/process_props.py

# DU Utils Library
PRODUCT_PACKAGES += \
    org.dirtyunicorns.utils

