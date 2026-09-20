# System Profiles

Hardware profiles for Linux on hybrid laptops (ASUS ROG Zephyrus G14, AMD Ryzen + NVIDIA RTX 3050). Automatically syncs with GNOME Quick Settings Power Mode.

## Overview

Switches hardware states based on whether the machine is used docked at a desk or mobile on battery.

- **Desktop (Performance Mode):** Disables USB autosuspend, locks NVIDIA GPU clocks to a stable floor, sets 1:1 flat mouse acceleration, and ignores lid close for clamshell mode.
- **Laptop (Balanced / Power Saver Mode):** Enables USB autosuspend, releases GPU clocks to dynamic idle, and restores suspend on lid close.

## Profile matrix

| Setting | Performance (Desktop) | Balanced / Power Saver (Laptop) |
| --- | --- | --- |
| Lid close | Ignore (clamshell mode) | Suspend |
| USB autosuspend | Disabled (`on`) | Enabled (`auto`) |
| NVIDIA clocks | Locked floor (800 to 1800 MHz) | Reset to dynamic idle |
| Mouse acceleration | Flat (1:1 tracking) | Default |
| ASUS profile | Performance | Balanced |

## Structure

- `install.sh`: One-shot installer script.
- `desktop.sh`: Hook executed when entering Desktop mode.
- `laptop.sh`: Hook executed when entering Laptop mode.
- `profile-switch`: CLI switcher (`desktop`, `laptop`, `toggle`, `status`).
- `power-profile-listener.py`: D-Bus daemon tracking GNOME Power Mode changes.
- `setup-toggle-permissions.sh`: Sets up sudoers, systemd-logind drop-ins, and symlinks.
- `systemd-user/`: Systemd user services for the D-Bus listener and clamshell inhibitor.

## Install

The quickest path is the installer script, which sets up links, systemd services, and root permissions:

```bash
./system-profiles/install.sh
```

If you prefer to set it up by hand, use the manual steps below.

<details>
<summary>Manual install</summary>

<br>

1. Link profile configs:

   ```bash
   ln -sf ~/.dotfiles/system-profiles ~/.config/system-profiles
   ```

2. Enable user services:

   ```bash
   mkdir -p ~/.config/systemd/user
   ln -sf ~/.dotfiles/system-profiles/systemd-user/*.service ~/.config/systemd/user/
   systemctl --user daemon-reload
   systemctl --user enable --now power-profile-listener.service
   ```

3. Configure permissions and logind:

   ```bash
   sudo bash ~/.dotfiles/system-profiles/setup-toggle-permissions.sh
   ```

</details>

## GPU Rendering & PRIME Offload

On hybrid graphics (AMD APU + NVIDIA RTX 3050), all applications (OpenGL, Vulkan, and Flatpaks) are configured to render on the discrete NVIDIA GPU by default while displaying through the compositor via PRIME.

### Global Configuration (`/etc/environment`)
Session-wide environment variables tell GLVND and Vulkan loaders to target the NVIDIA dGPU:
```ini
__NV_PRIME_RENDER_OFFLOAD=1
__GLX_VENDOR_LIBRARY_NAME=nvidia
__VK_LAYER_NV_optimus=NVIDIA_only
__GL_SYNC_TO_VBLANK=0
vblank_mode=0
```

### Flatpak Sandbox Overrides
Flatpak apps run sandboxed and do not inherit `/etc/environment`. Global overrides are applied via:
```bash
flatpak override --user \
  --env=__NV_PRIME_RENDER_OFFLOAD=1 \
  --env=__GLX_VENDOR_LIBRARY_NAME=nvidia \
  --env=__VK_LAYER_NV_optimus=NVIDIA_only
```

### Is `gdm-prime` Required?
**No.** `gdm-prime` was a legacy AUR patch required on older GNOME/Xorg versions to avoid GDM disabling Wayland or failing to detect secondary GPUs. 

On modern GNOME Wayland (GNOME 46+ with NVIDIA 555+/615+ explicit sync), standard upstream `gdm` and `libgdm` handle hybrid graphics out of the box. PRIME offloading is handled entirely at the user-space driver level via GLVND and Vulkan layers, making display manager patches unnecessary (and potentially causing dependency conflicts).

## Customization

Add custom commands to `desktop.sh` or `laptop.sh`. Scripts are executed automatically whenever Power Mode changes in Quick Settings.

