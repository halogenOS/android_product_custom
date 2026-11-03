# SPDX-License-Identifier: Apache-2.0
# Apps of every device

# Etar, the calendar, in place of AOSP's Calendar
PRODUCT_PACKAGES += Etar

# ExactCalculator, the calculator, in place of AOSP's Calculator
PRODUCT_PACKAGES += ExactCalculator

# Seedvault, the backup app
PRODUCT_PACKAGES += Seedvault

# Wallpapers, the wallpaper pack
PRODUCT_PACKAGES += Wallpapers

# ClockStyles, the lock screen clock styles, with the overlays that add them to the plugin lists
# of SystemUI and ThemePicker for user builds, and the overlay config file that enables them at boot
PRODUCT_PACKAGES += \
    ClockStyles \
    CustomClockStylesSystemUIOverlay \
    CustomClockStylesThemePickerOverlay \
    custom_overlay_config.xml

# Camelot, the PDF viewer
PRODUCT_PACKAGES += Camelot
