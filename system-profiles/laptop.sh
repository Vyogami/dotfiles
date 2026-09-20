#!/usr/bin/env bash
# ==========================================================
# LAPTOP / MOBILE PROFILE
# Triggered when on battery or using laptop away from desk
# ==========================================================

echo "Activating Laptop Profile..."

# 1. Enable USB autosuspend on all USB devices to maximize battery life
for d in /sys/bus/usb/devices/*/power/control; do
    if [ -f "$d" ]; then
        echo auto > "$d" 2>/dev/null || true
    fi
done

# 2. Reset GPU clocks so NVIDIA GPU can dynamically downclock & power down
nvidia-smi --reset-gpu-clocks 2>/dev/null || true

# 3. Asus Balanced / Power-saving profile
asusctl profile -P Balanced 2>/dev/null || true

# 4. Release lid switch inhibitor (closing lid will now suspend properly)
systemctl --user stop desktop-lid-inhibit.service 2>/dev/null || true

# 5. Restore systemd-logind suspend behavior
mkdir -p /etc/systemd/logind.conf.d
cat << 'EOF' > /etc/systemd/logind.conf.d/lid.conf
[Login]
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
HandleLidSwitchDocked=suspend
EOF
systemctl kill --signal=HUP systemd-logind 2>/dev/null || true

# ==========================================================
# Add your custom battery/laptop commands below:
# ==========================================================

