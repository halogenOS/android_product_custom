# SPDX-License-Identifier: Apache-2.0

# The build stops on a name in PRODUCT_PACKAGES that no module defines
$(call enforce-product-packages-exist-internal,$(lastword $(_include_stack)),)
