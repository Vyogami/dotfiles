#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "[-] Please run with sudo: sudo bash $0"
    exit 1
fi

# 1. Symlink switcher to /usr/local/bin
ln -sf /home/vyogami/.config/system-profiles/profile-switch /usr/local/bin/profile-switch
chmod +x /home/vyogami/.config/system-profiles/profile-switch

# 2. Allow passwordless execution for profile-switch from Quick Settings
cat << 'EOF' > /etc/sudoers.d/system-profiles
vyogami ALL=(ALL) NOPASSWD: /usr/local/bin/profile-switch
EOF
chmod 440 /etc/sudoers.d/system-profiles

# 3. Ensure global schema is also updated
if [ -d /usr/share/glib-2.0/schemas ]; then
    cp /home/vyogami/.local/share/gnome-shell/extensions/custom-command-toggle@storageb.github.com/schemas/org.gnome.shell.extensions.custom-command-toggle.gschema.xml /usr/share/glib-2.0/schemas/ 2>/dev/null || true
    glib-compile-schemas /usr/share/glib-2.0/schemas/ 2>/dev/null || true
fi

# 4. Migrate static logind.conf entries to dynamic logind.conf.d
if [ -f /etc/systemd/logind.conf ]; then
    cp /etc/systemd/logind.conf /etc/systemd/logind.conf.bak
    # Comment out static HandleLidSwitch lines in main file so drop-ins have full control
    sed -i -E 's/^(HandleLidSwitch.*)/#\1/' /etc/systemd/logind.conf
fi

mkdir -p /etc/systemd/logind.conf.d
cat << 'EOF' > /etc/systemd/logind.conf.d/lid.conf
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF

systemctl kill --signal=HUP systemd-logind 2>/dev/null || true

echo "[+] Dynamic lid behavior, profile switch permissions, and symlinks installed successfully!"
