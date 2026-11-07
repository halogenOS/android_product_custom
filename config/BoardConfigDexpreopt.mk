# SPDX-FileCopyrightText: The halogenOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Turns dexpreopt off for every product, so the images contain no odex files and no boot image. The
# device compiles ART code for the CPU in the device: odrefresh builds the boot image and
# system_server, and ART compiles apps on install and while idle. The board configuration includes
# this file after the BoardConfig.mk of the device and before it makes WITH_DEXPREOPT read-only, so
# neither the device nor the environment can turn dexpreopt back on.

WITH_DEXPREOPT := false
