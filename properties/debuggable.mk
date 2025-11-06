# SPDX-License-Identifier: Apache-2.0

# ro.debuggable=0 on userdebug builds, unless the build sets WITH_ADB_INSECURE.
# Only userdebug reads the setting: eng builds stay debuggable, user builds never are.
ifeq ($(WITH_ADB_INSECURE),)
PRODUCT_NOT_DEBUGGABLE_IN_USERDEBUG := true
endif
