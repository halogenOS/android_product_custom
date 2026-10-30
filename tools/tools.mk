# SPDX-FileCopyrightText: The halogenOS Project
# SPDX-License-Identifier: Apache-2.0
# Command line tools for adb shell

PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    setcap \
    vim \
    zstd

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap \
    system/%/libzstd.so
