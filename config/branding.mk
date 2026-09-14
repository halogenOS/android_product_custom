# SPDX-License-Identifier: Apache-2.0

CUSTOM_PRODUCT_NAME ?= halogenOS
CUSTOM_BUILD_TYPE ?= UNOFFICIAL

CUSTOM_DEVICE := $(TARGET_PRODUCT)

# Build date is injected post-build by sign_build() to keep builds
# reproducible and avoid rebuilds when only the timestamp changes.
CUSTOM_BUILD_DATE_PLACEHOLDER := 00000000-000000

CUSTOM_PLATFORM_VERSION := $(shell echo $(ROM_VERSION) | cut -d '-' -f2)

CUSTOM_VERSION := $(CUSTOM_PRODUCT_NAME)_$(CUSTOM_DEVICE)-$(CUSTOM_PLATFORM_VERSION)-$(CUSTOM_BUILD_DATE_PLACEHOLDER)-$(CUSTOM_BUILD_TYPE)
CUSTOM_DISPLAY_VERSION := $(CUSTOM_PLATFORM_VERSION)

PRODUCT_PRODUCT_PROPERTIES += \
    ro.custom.version=$(CUSTOM_VERSION) \
    ro.custom.build.version=$(CUSTOM_PLATFORM_VERSION) \
    ro.custom.display.version=$(CUSTOM_DISPLAY_VERSION) \
    ro.custom.build_type=$(CUSTOM_BUILD_TYPE)
