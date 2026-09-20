#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up system-profiles..."

# 1. Ensure scripts are executable
chmod +x "$SCRIPT_DIR"/*.sh "$SCRIPT_DIR"/profile-switch "$SCRIPT_DIR"/power-profile-listener.py 2>/dev/null || true

# 2. Link config directory if needed
CONFIG_DIR="$HOME/.config/system-profiles"
if [ ! -L "$CONFIG_DIR" ] && [ "$CONFIG_DIR" != "$SCRIPT_DIR" ]; then
    mkdir -p "$HOME/.config"
    ln -sfn "$SCRIPT_DIR" "$CONFIG_DIR"
fi

# 3. Link and enable user systemd services
mkdir -p "$HOME/.config/systemd/user"
for s in "$SCRIPT_DIR"/systemd-user/*.service; do
    if [ -f "$s" ]; then
        ln -sf "$s" "$HOME/.config/systemd/user/$(basename "$s")"
    fi
done

systemctl --user daemon-reload
systemctl --user enable --now power-profile-listener.service

# 4. Run root permissions and logind setup
echo "Configuring root permissions and systemd-logind..."
sudo bash "$SCRIPT_DIR/setup-toggle-permissions.sh"

echo "Installation complete."
