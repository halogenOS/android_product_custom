# SPDX-License-Identifier: Apache-2.0

# SystemUI is compiled with the speed filter on user builds
ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_DEXPREOPT_SPEED_APPS += SystemUI
endif
