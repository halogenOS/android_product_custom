# SPDX-License-Identifier: Apache-2.0
# Adds to build/make/target/product/handheld_product.mk

# ThemePicker, the wallpaper and style picker, with the color bundles of ThemesStub and the overlays
# that open it from the wallpaper entries of Settings and of the home screen
PRODUCT_PACKAGES += \
    ThemePicker \
    ThemesStub \
    CustomThemePickerSettingsOverlay \
    CustomThemePickerLauncherOverlay

# ThemePicker lists and previews live wallpapers, so the stock Live Wallpaper Picker would only add a second app to
# the chooser of the set-wallpaper action
PRODUCT_REMOVED_PACKAGES += LiveWallpapersPicker
