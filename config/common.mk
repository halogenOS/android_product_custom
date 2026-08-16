# SPDX-License-Identifier: Apache-2.0

# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

include product/custom/config/branding.mk
