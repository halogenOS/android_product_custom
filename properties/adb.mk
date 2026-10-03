# SPDX-License-Identifier: Apache-2.0

# ADB authentication, off on eng builds and when the build sets WITH_ADB_INSECURE.
# system_ext loads after system, so its 0 also replaces the 1 that user builds get there.
ifneq ($(filter eng,$(TARGET_BUILD_VARIANT))$(WITH_ADB_INSECURE),)
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=0
else
PRODUCT_SYSTEM_EXT_PROPERTIES += ro.adb.secure=1
endif
