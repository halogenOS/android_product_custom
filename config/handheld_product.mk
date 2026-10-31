# SPDX-License-Identifier: Apache-2.0
# Adds to build/make/target/product/handheld_product.mk

include product/custom/apps/handheld.mk

# Alarm and notification sounds from packages/resources/lineage
PRODUCT_PACKAGES += \
    lineage_alarm_sounds \
    lineage_notification_sounds
