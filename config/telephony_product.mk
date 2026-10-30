# SPDX-License-Identifier: Apache-2.0
# Adds to build/make/target/product/telephony_product.mk

# APN list from vendor/apn
PRODUCT_PACKAGES += apns-conf.xml

# Default ringtone, an AOSP sound
PRODUCT_PRODUCT_PROPERTIES += ro.config.ringtone=Orion.ogg
