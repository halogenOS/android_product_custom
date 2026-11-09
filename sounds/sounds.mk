# SPDX-FileCopyrightText: The halogenOS Project
# SPDX-License-Identifier: Apache-2.0
# Sounds of every device

# Alarm and notification sounds from packages/resources/lineage
PRODUCT_PACKAGES += \
    lineage_alarm_sounds \
    lineage_notification_sounds

# Default notification sound, an AOSP sound
PRODUCT_PRODUCT_PROPERTIES += ro.config.notification_sound=Argon.ogg

# Default alarm sound, an AOSP sound that AllAudio.mk does not install
PRODUCT_COPY_FILES += \
    frameworks/base/data/sounds/alarms/ogg/Hassium.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/alarms/Hassium.ogg
PRODUCT_PRODUCT_PROPERTIES += ro.config.alarm_alert=Hassium.ogg
