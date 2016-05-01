# Inherit common stuff
$(call inherit-product, vendor/deso/config/common.mk)
$(call inherit-product, vendor/deso/config/common_apn.mk)

# SIM Toolkit
PRODUCT_PACKAGES += \
    Stk
