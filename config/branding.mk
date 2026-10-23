# SPDX-License-Identifier: Apache-2.0

CUSTOM_PRODUCT_NAME ?= halogenOS
CUSTOM_BUILD_TYPE ?= UNOFFICIAL

CUSTOM_DEVICE := $(TARGET_PRODUCT)

CUSTOM_PLATFORM_VERSION := $(shell echo $(ROM_VERSION) | cut -d '-' -f2)

# soong_ui sets BUILD_DATE_PLACEHOLDER, and gen_build_prop writes build_date in
# its place: the date of the signing build, or the placeholder itself in a
# regular build, which then rebuilds nothing for a new date.
CUSTOM_VERSION := $(CUSTOM_PRODUCT_NAME)_$(CUSTOM_DEVICE)-$(CUSTOM_PLATFORM_VERSION)-$(BUILD_DATE_PLACEHOLDER)-$(CUSTOM_BUILD_TYPE)
CUSTOM_DISPLAY_VERSION := $(CUSTOM_PLATFORM_VERSION)

PRODUCT_PRODUCT_PROPERTIES += \
    ro.custom.version=$(CUSTOM_VERSION) \
    ro.custom.build.version=$(CUSTOM_PLATFORM_VERSION) \
    ro.custom.display.version=$(CUSTOM_DISPLAY_VERSION) \
    ro.custom.build_type=$(CUSTOM_BUILD_TYPE)
