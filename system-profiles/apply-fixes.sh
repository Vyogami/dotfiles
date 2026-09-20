#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "[-] Please run with sudo: sudo bash $0"
    exit 1
fi

echo "=== 1. REMOVING RUSTDESK & GOHTTPSERVER COMPLETELY ==="
systemctl stop rustdeskrelay.service rustdesksignal.service gohttpserver.service 2>/dev/null || true
systemctl disable rustdeskrelay.service rustdesksignal.service gohttpserver.service 2>/dev/null || true

rm -f /etc/systemd/system/rustdeskrelay.service
rm -f /etc/systemd/system/rustdesksignal.service
rm -f /etc/systemd/system/gohttpserver.service
rm -f /etc/systemd/system/multi-user.target.wants/rustdesk*
rm -f /etc/systemd/system/multi-user.target.wants/gohttp*
systemctl daemon-reload
systemctl reset-failed 2>/dev/null || true

rm -rf /opt/rustdesk /var/log/rustdesk
rm -rf /opt/gohttp /var/log/gohttp
rm -rf /home/vyogami/.config/rustdesk /home/vyogami/.local/share/rustdesk

echo "[+] Rustdesk and GoHTTPServer removed."

echo -e "\n=== 2. CONFIGURING NVIDIA PERFORMANCE ==="
# Enable nvidia persistence daemon
systemctl enable --now nvidia-persistenced.service
nvidia-smi -pm 1 2>/dev/null || true

# Lock clocks to avoid 225MHz throttling on dual monitors
nvidia-smi --lock-gpu-clocks=800,1800 2>/dev/null || true

# Create systemd service to keep clocks locked on boot
cat << 'EOF' > /etc/systemd/system/nvidia-performance.service
[Unit]
Description=Lock NVIDIA GPU minimum clocks for smooth desktop compositing
After=nvidia-persistenced.service
Requires=nvidia-persistenced.service

[Service]
Type=oneshot
ExecStart=/usr/bin/nvidia-smi --lock-gpu-clocks=800,1800
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now nvidia-performance.service
echo "[+] NVIDIA persistence and clock floor enabled."

echo -e "\n=== 3. DISABLING USB AUTOSUSPEND (Fixes KVM Mouse Jitter) ==="
# Disable immediately for all current devices
for d in /sys/bus/usb/devices/*/power/control; do
    if [ -f "$d" ]; then
        echo on > "$d" 2>/dev/null || true
    fi
done

# Persist via udev rule
cat << 'EOF' > /etc/udev/rules.d/50-usb-power.rules
# Disable autosuspend for USB HID and Hub devices to prevent KVM mouse lag
ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
EOF
udevadm control --reload-rules 2>/dev/null || true
echo "[+] USB autosuspend disabled (current session + permanent udev rule)."

echo -e "\n=== 4. CONFIGURING NVIDIA PRIME RENDERING BY DEFAULT & DISABLING VSYNC ==="
# Ensure all apps render on NVIDIA dGPU by default
for var in "__NV_PRIME_RENDER_OFFLOAD=1" "__GLX_VENDOR_LIBRARY_NAME=nvidia" "__VK_LAYER_NV_optimus=NVIDIA_only" "__GL_SYNC_TO_VBLANK=0" "vblank_mode=0"; do
    key="${var%%=*}"
    if ! grep -q "^${key}=" /etc/environment 2>/dev/null; then
        echo "$var" >> /etc/environment
    fi
done
echo "[+] NVIDIA PRIME default offloading and VSYNC disabled in /etc/environment."

# Apply to Flatpaks if installed
if command -v flatpak &>/dev/null; then
    TARGET_USER="${SUDO_USER:-$USER}"
    sudo -u "$TARGET_USER" flatpak override --user \
        --env=__NV_PRIME_RENDER_OFFLOAD=1 \
        --env=__GLX_VENDOR_LIBRARY_NAME=nvidia \
        --env=__VK_LAYER_NV_optimus=NVIDIA_only 2>/dev/null || true
    echo "[+] Flatpak NVIDIA PRIME overrides configured for $TARGET_USER."
fi


echo -e "\n=== 5. UPDATING GRUB (nvidia_drm.fbdev=1 & usbcore.autosuspend=-1) ==="
if [ -f /etc/default/grub ]; then
    sed -i -E 's/GRUB_CMDLINE_LINUX_DEFAULT="([^"]*)"/GRUB_CMDLINE_LINUX_DEFAULT="\1"/' /etc/default/grub
    
    # Ensure nvidia_drm.fbdev=1 is present
    if ! grep -q "nvidia_drm.fbdev=1" /etc/default/grub; then
        sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia_drm.fbdev=1 /' /etc/default/grub
    fi
    
    # Ensure usbcore.autosuspend=-1 is present
    if ! grep -q "usbcore.autosuspend=-1" /etc/default/grub; then
        sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="usbcore.autosuspend=-1 /' /etc/default/grub
    fi
    
    # Clean up any duplicate spaces
    sed -i -E 's/  +/ /g' /etc/default/grub
    
    grub-mkconfig -o /boot/grub/grub.cfg
    echo "[+] GRUB updated."
fi

echo -e "\n[SUCCESS] All fixes applied! Please test your mouse now."
