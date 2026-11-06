#!/bin/sh
# Installs or removes the Zen startup script that reloads mods without a window.
# Usage: sh install.sh [--remove] [zen-install-dir...]
# Without a folder, every Zen install found is used. System folders need sudo.
set -eu

here=$(dirname "$(readlink -f "$0")")
remove=0
if [ "${1:-}" = "--remove" ]; then
    remove=1
    shift
fi

if [ $# -eq 0 ]; then
    running=$(pgrep -o -x zen-bin || true)
    launcher=$(command -v zen-browser || command -v zen || true)
    for dir in \
        "${running:+$(dirname "$(readlink -f "/proc/$running/exe" 2>/dev/null || echo /nonexistent/x)")}" \
        "${launcher:+$(dirname "$(readlink -f "$launcher")")}" \
        "$(sed -n 's|^exec \(/[^ ]*\)/zen-bin.*|\1|p' "${launcher:-/dev/null}" 2>/dev/null | head -n 1)" \
        /opt/zen-browser-bin /opt/zen-browser /opt/zen /usr/lib/zen-browser /usr/lib64/zen-browser \
        "${SUDO_USER:+$(getent passwd "$SUDO_USER" | cut -d: -f6)/.tarball-installations/zen}" \
        "$HOME/.tarball-installations/zen"; do
        [ -n "$dir" ] && [ -x "$dir/zen-bin" ] && [ -d "$dir/defaults/pref" ] && set -- "$@" "$dir"
    done
    if [ $# -eq 0 ]; then
        echo "No Zen install found. Pass its folder (the one containing zen-bin)." >&2
        echo "The Flatpak version cannot be changed; the mod uses a short window there." >&2
        exit 1
    fi
fi

done_dirs=""
for zen_dir in "$@"; do
    zen_dir=$(readlink -f "$zen_dir")
    case " $done_dirs " in *" $zen_dir "*) continue ;; esac
    done_dirs="$done_dirs $zen_dir"
    if [ ! -d "$zen_dir/defaults/pref" ]; then
        echo "Zen not found in $zen_dir" >&2
        exit 1
    fi
    if [ "$remove" = 1 ]; then
        rm -f "$zen_dir/ambxst-zen-sync.cfg" "$zen_dir/defaults/pref/ambxst-zen-sync-prefs.js"
        echo "Removed from $zen_dir"
    else
        install -m 644 "$here/ambxst-zen-sync.cfg" "$zen_dir/ambxst-zen-sync.cfg"
        install -m 644 "$here/ambxst-zen-sync-prefs.js" "$zen_dir/defaults/pref/ambxst-zen-sync-prefs.js"
        echo "Installed in $zen_dir"
    fi
done
echo "Restart Zen."
