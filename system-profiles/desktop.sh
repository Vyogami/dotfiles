#!/usr/bin/env bash
# ==========================================================
# DESKTOP / DOCKED PROFILE
# Triggered when working docked with external monitors & KVM
# ==========================================================

echo "Activating Desktop Profile..."

# 1. Disable USB autosuspend across ALL USB ports (prevents KVM/mouse lag)
for d in /sys/bus/usb/devices/*/power/control; do
    if [ -f "$d" ]; then
        echo on > "$d" 2>/dev/null || true
    fi
done

# 2. Set GPU to responsive clock floor (prevents 225MHz throttling)
nvidia-smi --lock-gpu-clocks=800,1800 2>/dev/null || true

# 3. Ensure 1:1 flat mouse acceleration curve
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat' 2>/dev/null || true

# 4. Asus Performance Profile
asusctl profile -P Performance 2>/dev/null || true

# 5. Inhibit lid close suspend (clamshell mode stays awake)
systemctl --user start desktop-lid-inhibit.service 2>/dev/null || true

# 6. Apply systemd-logind ignore rules
mkdir -p /etc/systemd/logind.conf.d
cat << 'EOF' > /etc/systemd/logind.conf.d/lid.conf
[Login]
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF
systemctl kill --signal=HUP systemd-logind 2>/dev/null || true

# ==========================================================
# Add your custom desktop commands below:
# ==========================================================

