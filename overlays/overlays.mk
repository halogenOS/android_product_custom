# SPDX-FileCopyrightText: The halogenOS Project
# SPDX-License-Identifier: Apache-2.0
# Overlays of every device that belong to no app of their own

# Framework defaults of the product, an overlay from packages/overlays/Custom
PRODUCT_PACKAGES += CustomDefaultsFrameworkOverlay

# Black surfaces in dark mode, switched on and off at runtime, from packages/overlays/accents
PRODUCT_PACKAGES += CustomBlackTheme
