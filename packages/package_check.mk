# SPDX-License-Identifier: Apache-2.0

# The build stops on a name in PRODUCT_PACKAGES that no module defines,
# except for the names listed here
$(call enforce-product-packages-exist-internal,$(lastword $(_include_stack)), \
    product_manifest.xml)
