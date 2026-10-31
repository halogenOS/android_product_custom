# SPDX-License-Identifier: Apache-2.0

# Source user-local environment overrides (KEYS_DIR, CCACHE_DIR, OUT_DIR, etc.)
if [ -f "local.conf" ]; then
    echo "including local.conf"
    source "local.conf"
fi
# Overrides of one setup each, read after local.conf in byte order of their names
if [ -d "local.conf.d" ]; then
    while IFS= read -r conf; do
        echo "including $conf"
        source "$conf"
    done < <(find local.conf.d -maxdepth 1 -name '*.conf' \( -type f -o -type l \) | LC_ALL=C sort)
fi

XOS_TOOLS_SCRIPT="external/xos/xostools/xostools.sh"
if [ -f "$XOS_TOOLS_SCRIPT" ]; then
    source "$XOS_TOOLS_SCRIPT"
fi

export TOP="$(pwd)"
export ROM_VERSION="$(xmlstarlet sel -t -v "/manifest/remote[@name='XOS']/@revision" "$TOP/.repo/manifests/snippets/XOS.xml" | sed -e 's|refs/heads/||')"
