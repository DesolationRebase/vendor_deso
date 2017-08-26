PRODUCT_COPY_FILES += \
    vendor/deso/utils/emulator/fstab.ranchu:root/fstab.ranchu

$(call inherit-product, build/target/product/sdk_x86.mk)

$(call inherit-product, vendor/deso/common.mk)

$(call inherit-product, vendor/deso/utils/emulator/common.mk)

# Override product naming for Omni
PRODUCT_NAME := omni_emulator

PRODUCT_PACKAGE_OVERLAYS += vendor/deso/utils/emulator/overlay
