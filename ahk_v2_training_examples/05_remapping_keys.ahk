/*
 * Script: 05_remapping_keys.ahk
 * Description: Remap keys and create custom keyboard layouts
 * Category: Hotkeys - Remapping
 * Version: AHK v2.0+
 *
 * Simple remapping: key1::key2
 * Complex remapping using Send
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Simple key remapping - CapsLock becomes Ctrl
CapsLock::Ctrl

; Swap two keys - perfect for Dvorak/Colemak users
;a::s
;s::a

; Make CapsLock useful - CapsLock+hjkl for arrow keys (Vim-style)
CapsLock & h::Send "{Left}"
CapsLock & j::Send "{Down}"
CapsLock & k::Send "{Up}"
CapsLock & l::Send "{Right}"

; CapsLock+u/d for Page Up/Down
CapsLock & u::Send "{PgUp}"
CapsLock & d::Send "{PgDn}"

; Numpad remapping for quick symbols (when NumLock is off)
Numpad7::Send "{Home}"
Numpad9::Send "{PgUp}"
Numpad1::Send "{End}"
Numpad3::Send "{PgDn}"

; Remap rarely used key to useful function
ScrollLock::Send "{Media_Play_Pause}"

; F13-F24 keys remapping (extended keyboard)
F13::Send "^c"  ; Copy
F14::Send "^v"  ; Paste
F15::Send "^z"  ; Undo
F16::Send "^y"  ; Redo

; Remap right Alt to act as AltGr for international characters
>!a::Send "á"
>!e::Send "é"
>!i::Send "í"
>!o::Send "ó"
>!u::Send "ú"

; Make Insert key useful - toggle always-on-top
Insert::{
    WinSetAlwaysOnTop -1, "A"
    isOnTop := WinGetExStyle("A") & 0x8
    ToolTip isOnTop ? "Window: Always On Top" : "Window: Normal"
    SetTimer () => ToolTip(), -1500
}

; Remap Right Ctrl to act as Enter (for compact keyboards)
RCtrl::Enter

; Disable Windows key (useful for gaming)
;LWin::Return
;RWin::Return

; Pause script with Pause key
Pause::Suspend

Esc::ExitApp
