/*
 * Script: 03_mouse_hotkeys.ahk
 * Description: Mouse button hotkeys and combinations
 * Category: Hotkeys - Mouse
 * Version: AHK v2.0+
 *
 * Mouse Buttons:
 * LButton = Left | RButton = Right | MButton = Middle
 * XButton1 = Side 1 | XButton2 = Side 2
 * WheelUp/WheelDown = Scroll
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Ctrl+Right Click = Show coordinates
^RButton::{
    MouseGetPos &x, &y
    MsgBox "Mouse Position:`nX: " x "`nY: " y
}

; Middle mouse button = Paste clipboard
MButton::{
    Send "^v"
}

; Ctrl+Mouse Wheel Up = Increase volume
^WheelUp::Send "{Volume_Up}"

; Ctrl+Mouse Wheel Down = Decrease volume
^WheelDown::Send "{Volume_Down}"

; Side button 1 = Browser back
XButton1::Send "!{Left}"

; Side button 2 = Browser forward
XButton2::Send "!{Right}"

; Shift+Left Click = Get window info
+LButton::{
    MouseGetPos &x, &y, &winID, &control
    winTitle := WinGetTitle(winID)
    winClass := WinGetClass(winID)

    MsgBox "
    (
    Window Info:
    Title: " winTitle "
    Class: " winClass "
    Control: " control "
    Position: " x ", " y "
    )"
}

; Disable right-click on desktop
#HotIf WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW")
RButton::Return  ; Disable right-click on desktop
#HotIf

Esc::ExitApp
