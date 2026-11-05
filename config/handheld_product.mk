# SPDX-License-Identifier: Apache-2.0
# Adds to build/make/target/product/handheld_product.mk

# Alarm and notification sounds from packages/resources/lineage
PRODUCT_PACKAGES += \
    lineage_alarm_sounds \
    lineage_notification_sounds

# Off-mode charging screen from packages/resources/lineage
PRODUCT_PACKAGES += lineage_charger_animation

# Default notification sound, an AOSP sound
PRODUCT_PRODUCT_PROPERTIES += ro.config.notification_sound=Argon.ogg

# Default alarm sound, an AOSP sound that AllAudio.mk does not install
PRODUCT_COPY_FILES += \
    frameworks/base/data/sounds/alarms/ogg/Hassium.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/alarms/Hassium.ogg
PRODUCT_PRODUCT_PROPERTIES += ro.config.alarm_alert=Hassium.ogg

# ThemePicker, the wallpaper and style picker, with the color bundles of ThemesStub and the overlay
# that opens it from the wallpaper entry of Settings
PRODUCT_PACKAGES += \
    ThemePicker \
    ThemesStub \
    CustomThemePickerSettingsOverlay

# Framework defaults of the product, an overlay from packages/overlays/Custom
PRODUCT_PACKAGES += CustomDefaultsFrameworkOverlay
