# SPDX-License-Identifier: Apache-2.0

# SystemUI is compiled with the speed filter on user builds, by ART whenever
# the device compiles it
ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_PROPERTIES += dalvik.vm.systemuicompilerfilter=speed
endif
