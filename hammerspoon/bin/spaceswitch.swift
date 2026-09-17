import CoreGraphics
import Foundation

// Faithful port of LinearMouse's postSymbolicHotKey (MIT) using the private
// CGSGetSymbolicHotKeyValue / CGSIsSymbolicHotKeyEnabled / CGSSetSymbolicHotKeyEnabled
// resolved via dlsym. Triggers the real "Move left/right a space" hotkey.

typealias GetValueFn = @convention(c) (UInt32, UnsafeMutablePointer<UInt16>, UnsafeMutablePointer<UInt16>, UnsafeMutablePointer<UInt32>) -> Int32
typealias IsEnabledFn = @convention(c) (UInt32) -> Bool
typealias SetEnabledFn = @convention(c) (UInt32, Bool) -> Int32

func sym<T>(_ name: String, _ type: T.Type) -> T? {
    guard let p = dlsym(UnsafeMutableRawPointer(bitPattern: -2), name) else { return nil } // RTLD_DEFAULT
    return unsafeBitCast(p, to: T.self)
}

guard let CGSGetSymbolicHotKeyValue = sym("CGSGetSymbolicHotKeyValue", GetValueFn.self),
      let CGSIsSymbolicHotKeyEnabled = sym("CGSIsSymbolicHotKeyEnabled", IsEnabledFn.self),
      let CGSSetSymbolicHotKeyEnabled = sym("CGSSetSymbolicHotKeyEnabled", SetEnabledFn.self)
else { FileHandle.standardError.write("dlsym failed\n".data(using: .utf8)!); exit(2) }

let dir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "right"
let hotkey: UInt32 = (dir == "left") ? 79 : 81  // spaceLeft / spaceRight

var keyEquivalent: UInt16 = 0
var virtualKeyCode: UInt16 = 0
var modifiers: UInt32 = 0
let err = CGSGetSymbolicHotKeyValue(hotkey, &keyEquivalent, &virtualKeyCode, &modifiers)
if err != 0 { FileHandle.standardError.write("get value err \(err)\n".data(using: .utf8)!); exit(3) }
if virtualKeyCode == 0xFFFF { FileHandle.standardError.write("hotkey not configured\n".data(using: .utf8)!); exit(4) }

let wasEnabled = CGSIsSymbolicHotKeyEnabled(hotkey)
if !wasEnabled { _ = CGSSetSymbolicHotKeyEnabled(hotkey, true) }
defer { if !wasEnabled { usleep(30000); _ = CGSSetSymbolicHotKeyEnabled(hotkey, false) } }

let flags = CGEventFlags(rawValue: UInt64(modifiers))
let tap = CGEventTapLocation.cgSessionEventTap

func mk(_ vk: CGKeyCode, _ down: Bool) -> CGEvent? {
    guard let src = CGEventSource(stateID: .hidSystemState),
          let e = CGEvent(keyboardEventSource: src, virtualKey: vk, keyDown: down) else { return nil }
    e.timestamp = CGEventTimestamp(DispatchTime.now().uptimeNanoseconds)
    e.setIntegerValueField(.keyboardEventKeyboardType, value: Int64(src.keyboardType))
    return e
}

// modifier keycodes
let modKeys: [(CGEventFlags, CGKeyCode)] = [
    (.maskShift, 0x38), (.maskControl, 0x3B), (.maskAlternate, 0x3A), (.maskCommand, 0x37)
]
let active = modKeys.filter { flags.contains($0.0) }

var acc = CGEventFlags()
for (flag, kc) in active {
    acc.insert(flag)
    if let e = mk(kc, true) { e.type = .flagsChanged; e.flags = acc; e.post(tap: tap) }
}
if let e = mk(CGKeyCode(virtualKeyCode), true) { e.flags = flags; e.post(tap: tap) }
if let e = mk(CGKeyCode(virtualKeyCode), false) { e.flags = flags; e.post(tap: tap) }
for (flag, kc) in active.reversed() {
    acc.remove(flag)
    if let e = mk(kc, false) { e.type = .flagsChanged; e.flags = acc; e.post(tap: tap) }
}
