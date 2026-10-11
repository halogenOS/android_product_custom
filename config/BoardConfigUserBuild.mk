# SPDX-FileCopyrightText: The halogenOS Project
# SPDX-License-Identifier: Apache-2.0
#
# The rules of a user build for the board configuration. The board configuration includes this file
# right after BoardConfigKernel.mk, before it strips the board variables and makes them read-only.

# A user build builds the kernel from source, so a board with a kernel, which it has unless it sets
# TARGET_NO_KERNEL, sets BOARD_KERNEL_BUILD_MODULE, itself or through the kernel adapter. An
# unbundled build makes no images.
_board_user_build_unbundled := $(filter true,$(TARGET_BUILD_UNBUNDLED))
_board_user_build_variant := \
  $(if $(_board_user_build_unbundled),,$(filter user,$(TARGET_BUILD_VARIANT)))
_board_user_build_has_kernel := $(if $(filter true,$(TARGET_NO_KERNEL)),,true)
ifneq ($(and $(_board_user_build_variant),$(_board_user_build_has_kernel)),)
  ifeq ($(strip $(BOARD_KERNEL_BUILD_MODULE)),)
    $(error A user build builds the kernel from source, and this board uses a prebuilt kernel. Set \
      TARGET_KERNEL_SOURCE and TARGET_KERNEL_CONFIG, or write a kernel_build module and set \
      BOARD_KERNEL_BUILD_MODULE to it.)
  endif
endif

$(foreach v,$(filter _board_user_build_%,$(.VARIABLES)),$(eval $(v) :=))
