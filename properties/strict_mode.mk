# SPDX-License-Identifier: Apache-2.0

# StrictMode's extra checks of bundled apps, off except on eng builds
ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_PRODUCT_PROPERTIES += persist.sys.strictmode.disable=true
endif
