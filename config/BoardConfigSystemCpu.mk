# SPDX-FileCopyrightText: The halogenOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Sets the CPU that the system side (system, system_ext, product and the generic ramdisk) compiles
# for. On arm64 and arm the system compiles for armv8-a with the generic CPU, so that it runs on every
# CPU with that arch. A device with an arm variant below armv8-a, such as the armv7-a-neon used by
# unbundled and CTS builds, uses that variant for the system as well. On other arches the system
# compiles for the device CPU. TARGET_ARCH_VARIANT, TARGET_CPU_VARIANT, TARGET_2ND_ARCH_VARIANT and
# TARGET_2ND_CPU_VARIANT are unchanged and set the device CPU, which the device side compiles for.

# The arm variants below armv8-a, which every armv8-a CPU runs as well.
_system_cpu_arm_variants_below_armv8 := armv7-a armv7-a-neon

# $(1): the arch, $(2): the device arch variant. Returns the arch variant for the system side.
_system_cpu_arch_variant = $(if $(filter arm64 arm,$(1)), \
  $(or $(filter $(_system_cpu_arm_variants_below_armv8),$(2)),armv8-a),$(2))
# $(1): the arch, $(2): the device CPU variant. Returns the CPU variant for the system side.
_system_cpu_cpu_variant = $(if $(filter arm64 arm,$(1)),generic,$(2))

TARGET_SYSTEM_ARCH_VARIANT := $(strip $(call _system_cpu_arch_variant,$(TARGET_ARCH),$(TARGET_ARCH_VARIANT)))
TARGET_SYSTEM_CPU_VARIANT := $(strip $(call _system_cpu_cpu_variant,$(TARGET_ARCH),$(TARGET_CPU_VARIANT)))
TARGET_2ND_SYSTEM_ARCH_VARIANT := \
  $(strip $(call _system_cpu_arch_variant,$(TARGET_2ND_ARCH),$(TARGET_2ND_ARCH_VARIANT)))
TARGET_2ND_SYSTEM_CPU_VARIANT := \
  $(strip $(call _system_cpu_cpu_variant,$(TARGET_2ND_ARCH),$(TARGET_2ND_CPU_VARIANT)))

_board_strip_readonly_list += TARGET_SYSTEM_ARCH_VARIANT TARGET_SYSTEM_CPU_VARIANT
_board_strip_readonly_list += TARGET_2ND_SYSTEM_ARCH_VARIANT TARGET_2ND_SYSTEM_CPU_VARIANT

_system_cpu_arm_variants_below_armv8 :=
_system_cpu_arch_variant :=
_system_cpu_cpu_variant :=
