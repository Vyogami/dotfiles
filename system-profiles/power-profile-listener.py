#!/usr/bin/env python3
import sys
import os
import subprocess
import dbus
from gi.repository import GLib
from dbus.mainloop.glib import DBusGMainLoop

DBusGMainLoop(set_as_default=True)
bus = dbus.SystemBus()

SWITCHER = "/usr/local/bin/profile-switch"

def handle_profile(profile_name):
    if profile_name == "performance":
        print(f"[listener] Power mode changed to {profile_name} -> activating desktop profile")
        subprocess.run(["sudo", SWITCHER, "desktop"])
    else:
        print(f"[listener] Power mode changed to {profile_name} -> activating laptop profile")
        subprocess.run(["sudo", SWITCHER, "laptop"])

def on_prop_changed(interface, changed_props, invalidated_props):
    if "ActiveProfile" in changed_props:
        handle_profile(str(changed_props["ActiveProfile"]))

bus.add_signal_receiver(
    on_prop_changed,
    dbus_interface="org.freedesktop.DBus.Properties",
    signal_name="PropertiesChanged",
    path="/net/hadess/PowerProfiles"
)

# Run once at startup to sync with current profile
try:
    obj = bus.get_object("net.hadess.PowerProfiles", "/net/hadess/PowerProfiles")
    props = dbus.Interface(obj, "org.freedesktop.DBus.Properties")
    current = str(props.Get("net.hadess.PowerProfiles", "ActiveProfile"))
    print(f"[listener] Starting up with active profile: {current}")
    handle_profile(current)
except Exception as e:
    print(f"[listener] Error getting initial profile: {e}", file=sys.stderr)

loop = GLib.MainLoop()
try:
    loop.run()
except KeyboardInterrupt:
    pass
