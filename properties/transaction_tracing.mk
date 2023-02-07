# SPDX-License-Identifier: Apache-2.0

# SurfaceFlinger records every transaction while ro.debuggable is set; userdebug builds turn that off.
ifeq ($(TARGET_BUILD_VARIANT),userdebug)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += debug.sf.enable_transaction_tracing=false
endif
