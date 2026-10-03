# SPDX-License-Identifier: Apache-2.0

# Privileged permission allowlist, enforced except on eng builds, which log missing entries
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_PRODUCT_PROPERTIES += ro.control_privapp_permissions=log
else
PRODUCT_PRODUCT_PROPERTIES += ro.control_privapp_permissions=enforce
endif
