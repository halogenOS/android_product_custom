# SPDX-FileCopyrightText: The halogenOS Project
# SPDX-License-Identifier: Apache-2.0
# This file runs after the product variables are stripped, so it may only append to PRODUCT_*
# variables, and inherit-product has no effect here.

# Desktop windowing and lock screen widgets: two overlays from packages/overlays/Custom and the
# overlay config file that enables them at boot
PRODUCT_PACKAGES += \
    CustomTabletFrameworkOverlay \
    CustomTabletSystemUIOverlay \
    custom_overlay_config.xml
