# SPDX-FileCopyrightText: The halogenOS Project
# SPDX-License-Identifier: Apache-2.0
#
# The board variables that the product layer sets for every board. The board configuration includes
# this file after the device's BoardConfig.mk and the combo makefiles, before it makes the board
# variables read-only.

include product/custom/config/BoardConfigDexpreopt.mk
include product/custom/config/BoardConfigSystemCpu.mk
