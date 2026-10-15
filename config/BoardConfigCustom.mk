# SPDX-License-Identifier: Apache-2.0
# Board-side entry point of the product layer, included from build/make core/config.mk

include build/custom/board_functions.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
    include hardware/qcom-caf/common/BoardConfigQcom.mk
endif

include device/lineage/sepolicy/common/sepolicy.mk
include device/custom/sepolicy/common/sepolicy.mk
