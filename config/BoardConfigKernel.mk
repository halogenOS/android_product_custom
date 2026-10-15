# SPDX-FileCopyrightText: The halogenOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Reads the LineageOS-style kernel variables of a board and passes them to board_kernel_adapter
# through the Soong config namespace board_kernel. The board configuration includes this file right
# after the BoardConfig.mk of the device, before it strips the board variables and makes them
# read-only.

# _board_kernel_stop stops the build for each variable of $(1) whose value has a word that matches
# a filter pattern of $(2), % for any value, with the next step $(3).
_board_kernel_stop = $(foreach v,$(1),$(if $(filter $(2),$($(v))), \
  $(error $(v) is set to $(strip $($(v))), and kernel_build has no counterpart for it. \
    $(strip $(3)))))

# _board_kernel_stop_unless stops the build for each variable of $(1) that is set to anything but
# $(2), with the next step $(3).
_board_kernel_stop_unless = $(foreach v,$(1),$(if $(filter-out $(2),$($(v))), \
  $(call _board_kernel_stop,$(v),%,$(3))))

# The adapter is on for a board that sets TARGET_KERNEL_SOURCE or TARGET_KERNEL_CONFIG and neither
# TARGET_NO_KERNEL nor TARGET_NO_KERNEL_OVERRIDE.
_board_kernel_no_build := $(filter true,$(TARGET_NO_KERNEL) $(TARGET_NO_KERNEL_OVERRIDE))
_board_kernel_variables := $(strip $(TARGET_KERNEL_SOURCE) $(TARGET_KERNEL_CONFIG))
_board_kernel_adapter_on := $(if $(_board_kernel_no_build),,$(_board_kernel_variables))

ifneq ($(_board_kernel_adapter_on),)

ifneq ($(strip $(BOARD_KERNEL_BUILD_MODULE)),)
  $(error BOARD_KERNEL_BUILD_MODULE is set to $(strip $(BOARD_KERNEL_BUILD_MODULE)), and \
    TARGET_KERNEL_SOURCE or TARGET_KERNEL_CONFIG is set too. Set only one of the two ways: remove \
    BOARD_KERNEL_BUILD_MODULE to build the kernel from TARGET_KERNEL_SOURCE and \
    TARGET_KERNEL_CONFIG, or remove TARGET_KERNEL_SOURCE and TARGET_KERNEL_CONFIG to build the \
    kernel with the module in BOARD_KERNEL_BUILD_MODULE.)
endif

_board_kernel_fragments := $(wordlist 2,$(words $(TARGET_KERNEL_CONFIG)),$(TARGET_KERNEL_CONFIG))
$(foreach w,$(filter-out %.config,$(_board_kernel_fragments)), \
  $(error TARGET_KERNEL_CONFIG contains $(w), which does not end in .config. Rename the fragment \
    so it ends in .config, or move its options into the defconfig.))

$(foreach e,$(filter %:kbuild,$(TARGET_KERNEL_EXT_MODULES)), \
  $(error TARGET_KERNEL_EXT_MODULES contains $(e), which ends in :kbuild. List the directory \
    without :kbuild.))

ifneq ($(filter true,$(TARGET_NEEDS_DTBOIMAGE)),)
  ifeq ($(filter true,$(BOARD_USES_QCOM_MERGE_DTBS_SCRIPT) $(BOARD_KERNEL_SEPARATED_DTBO)),)
    $(error TARGET_NEEDS_DTBOIMAGE is true without BOARD_USES_QCOM_MERGE_DTBS_SCRIPT or \
      BOARD_KERNEL_SEPARATED_DTBO, so dtbo.img would come from the dtbo.img target of the kernel, \
      which kernel_build does not build. Remove TARGET_KERNEL_DTBO and TARGET_KERNEL_DTBO_PREFIX, \
      and set BOARD_USES_QCOM_MERGE_DTBS_SCRIPT or BOARD_KERNEL_SEPARATED_DTBO.)
  endif
endif

# The variables that kernel_build has no counterpart for, by the values that stop the build, with
# the next step for each group
_board_kernel_next_config_ext := Move the configuration into arch/<arch>/configs of the kernel \
  source and name it in TARGET_KERNEL_CONFIG.
$(call _board_kernel_stop,TARGET_KERNEL_CONFIG_EXT,%,$(_board_kernel_next_config_ext))

_board_kernel_next_merge := Remove it. The fragments are merged one after the other, in the \
  order of TARGET_KERNEL_CONFIG.
$(call _board_kernel_stop,MERGE_ALL_KERNEL_CONFIGS_AT_ONCE,true,$(_board_kernel_next_merge))

_board_kernel_next_config_edit := Put the options into a .config fragment and add it to \
  TARGET_KERNEL_CONFIG.
$(call _board_kernel_stop,KERNEL_LTO KERNEL_CONFIG_OVERRIDE,%,$(_board_kernel_next_config_edit))

_board_kernel_next_gcc := Remove it. The kernel builds with clang and LLVM=1 only.
$(call _board_kernel_stop,TARGET_KERNEL_CLANG_COMPILE TARGET_KERNEL_LLVM_BINUTILS \
  TARGET_KERNEL_NO_GCC,false,$(_board_kernel_next_gcc))

_board_kernel_next_compiler := Remove it. The kernel builds with clang and its LLVM tools.
$(call _board_kernel_stop,TARGET_KERNEL_CROSS_COMPILE_PREFIX KERNEL_TOOLCHAIN \
  KERNEL_TOOLCHAIN_PREFIX KERNEL_CC KERNEL_CLANG_TRIPLE,%,$(_board_kernel_next_compiler))

_board_kernel_next_sysroot := Kernels 6.11 and newer, which need the host sysroot, are not \
  supported. Use a kernel source below 6.11, and remove the variable.
$(call _board_kernel_stop,TARGET_KERNEL_LIBC_SYSROOT_USE,host,$(_board_kernel_next_sysroot))

_board_kernel_next_rust := Remove it. The kernel builds without Rust.
$(call _board_kernel_stop,TARGET_KERNEL_RUST_VERSION,%,$(_board_kernel_next_rust))

_board_kernel_next_flags := Remove it. kernel_build passes the make flags ARCH, LLVM=1, \
  LLVM_IAS=1, LEX, YACC, M4, DTC_EXT, HOSTCFLAGS, HOSTLDFLAGS, CRYPTO_CFLAGS, CRYPTO_LIBS and \
  PAHOLE itself, and other make flags have no counterpart. Put kernel options into a .config \
  fragment in TARGET_KERNEL_CONFIG.
$(call _board_kernel_stop,TARGET_KERNEL_ADDITIONAL_FLAGS,%,$(_board_kernel_next_flags))

_board_kernel_next_dtb := Remove it. The build makes the dtbs target and uses every .dtb it builds.
$(call _board_kernel_stop_unless,TARGET_KERNEL_DTB,dtbs,$(_board_kernel_next_dtb))
$(call _board_kernel_stop_unless,TARGET_MERGE_DTBS_WILDCARD TARGET_DTB_LIST_WILDCARD,*, \
  $(_board_kernel_next_dtb))

_board_kernel_next_dt_recipe := Write a kernel_build module with its dt_images in the device \
  tree's Android.bp, and name it in BOARD_KERNEL_BUILD_MODULE.
$(call _board_kernel_stop,BOARD_DTB_CFG BOARD_DTBO_CFG BOARD_CUSTOM_DTBIMG_MK \
  BOARD_CUSTOM_DTBOIMG_MK BOARD_KERNEL_APPEND_DTBS BOARD_KERNEL_PREBUILT_DT TARGET_CUSTOM_DTBTOOL \
  BOARD_DTBTOOL_ARGS,%,$(_board_kernel_next_dt_recipe))
$(call _board_kernel_stop,TARGET_WANTS_EMPTY_DTB BOARD_KERNEL_SEPARATED_DT BOARD_KERNEL_LZ4C_DT, \
  true,$(_board_kernel_next_dt_recipe))

_board_kernel_next_prebuilt_modules := Remove it, and build each of its modules from the kernel \
  source: enable the module in the kernel configuration, or add its directory to \
  TARGET_KERNEL_EXT_MODULES. A prebuilt module does not match a kernel built from source.
$(call _board_kernel_stop,BOARD_VENDOR_KERNEL_MODULES BOARD_VENDOR_RAMDISK_KERNEL_MODULES \
  BOARD_VENDOR_KERNEL_MODULES_ARCHIVE BOARD_VENDOR_RAMDISK_KERNEL_MODULES_ARCHIVE,%, \
  $(_board_kernel_next_prebuilt_modules))

# core/Makefile writes these files into the directories that the partition modules replace
_board_kernel_next_charger := Remove it. Without modules.load.charger, init loads the modules of \
  modules.load in charger mode.
$(call _board_kernel_stop,BOARD_VENDOR_CHARGER_KERNEL_MODULES_LOAD \
  BOARD_VENDOR_RAMDISK_CHARGER_KERNEL_MODULES_LOAD,%,$(_board_kernel_next_charger))

_board_kernel_next_options := Remove it, and set each option on the kernel command line as \
  <module>.<parameter>=<value> in BOARD_KERNEL_CMDLINE.
$(call _board_kernel_stop,BOARD_VENDOR_KERNEL_MODULES_OPTIONS_FILE \
  BOARD_VENDOR_RAMDISK_KERNEL_MODULES_OPTIONS_FILE,%,$(_board_kernel_next_options))

_board_kernel_next_partitions := Write kernel_build and kernel_partition_modules modules in the \
  device tree's Android.bp, and name the kernel module in BOARD_KERNEL_BUILD_MODULE.
$(call _board_kernel_stop,SYSTEM_KERNEL_MODULES RECOVERY_KERNEL_MODULES,%, \
  $(_board_kernel_next_partitions))
$(call _board_kernel_stop,NEED_KERNEL_MODULE_ROOT NEED_KERNEL_MODULE_SYSTEM \
  NEED_KERNEL_MODULE_VENDOR_OVERLAY PRODUCT_BUILD_VENDOR_KERNEL_BOOT_IMAGE,true, \
  $(_board_kernel_next_partitions))
$(call _board_kernel_stop,BOARD_VENDOR_RAMDISK_FRAGMENTS,dlkm,$(_board_kernel_next_partitions))
# The module lists of a kernel module directory of its own, such as
# BOARD_VENDOR_KERNEL_MODULES_LOAD_<dir>
$(call _board_kernel_stop,BOARD_KERNEL_MODULE_DIRS,%,$(_board_kernel_next_partitions))

_board_kernel_next_force_prebuilt := Remove it. The kernel builds from TARGET_KERNEL_SOURCE.
$(call _board_kernel_stop,TARGET_FORCE_PREBUILT_KERNEL,%,$(_board_kernel_next_force_prebuilt))

# The adapter creates the ramdisk partition module, which installs the ramdisk blocklist, only for
# a board with ramdisk modules. Without that module core/Makefile installs the blocklist.
_board_kernel_ramdisk_lists := $(strip $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD) \
  $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD) $(BOOT_KERNEL_MODULES))

# The values that the namespace gets in place of those of the board. Without TARGET_KERNEL_SOURCE,
# the kernel source is the device directory below kernel/. Without TARGET_KERNEL_ARCH, the adapter
# takes the architecture of the device. A board may give TARGET_KERNEL_CLANG_PATH as an absolute
# path below the top of the source tree.
_board_kernel_value.TARGET_KERNEL_SOURCE := \
  $(or $(strip $(TARGET_KERNEL_SOURCE)),$(patsubst device/%,kernel/%,$(TARGET_DEVICE_DIR)))
_board_kernel_value.TARGET_KERNEL_CLANG_PATH := \
  $(patsubst $(abspath .)/%,%,$(strip $(TARGET_KERNEL_CLANG_PATH)))
_board_kernel_value.BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := \
  $(if $(_board_kernel_ramdisk_lists),$(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE))

# The variables that board_kernel_adapter reads, each passed under its own name when it has a
# value. The namespace gets this list under the key variables as well, and the adapter stops the
# build when it differs from the board variables that the adapter declares.
_board_kernel_passed := TARGET_KERNEL_SOURCE TARGET_KERNEL_CONFIG TARGET_KERNEL_ARCH \
  BOARD_KERNEL_IMAGE_NAME TARGET_KERNEL_CLANG_PATH TARGET_KERNEL_CLANG_VERSION \
  TARGET_KERNEL_EXT_MODULE_ROOT TARGET_KERNEL_EXT_MODULES \
  TARGET_MODULE_ALIASES BOARD_USES_QCOM_MERGE_DTBS_SCRIPT TARGET_NEEDS_DTBOIMAGE \
  BOARD_KERNEL_SEPARATED_DTBO BOARD_KERNEL_PAGESIZE BOARD_VENDOR_KERNEL_MODULES_LOAD \
  BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD \
  BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD \
  BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE BOOT_KERNEL_MODULES
$(foreach v,$(_board_kernel_passed),$(call soong_config_set_if_exist,board_kernel,$(v), \
  $(if $(filter undefined,$(origin _board_kernel_value.$(v))),$($(v)),$(_board_kernel_value.$(v)))))
$(call soong_config_set,board_kernel,variables,$(_board_kernel_passed))

# The kernel_build module that board_kernel_adapter creates under this name
BOARD_KERNEL_BUILD_MODULE := :board_kernel

# The partition modules that board_kernel_adapter creates install what these variables contain, so
# core/Makefile and fsgen get them empty.
BOARD_VENDOR_KERNEL_MODULES_LOAD :=
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE :=
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD :=
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD :=
ifneq ($(_board_kernel_ramdisk_lists),)
  BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE :=
endif

endif

$(foreach v,$(filter _board_kernel_%,$(.VARIABLES)),$(eval $(v) :=))
