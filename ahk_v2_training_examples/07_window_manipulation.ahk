/*
 * Script: 07_window_manipulation.ahk
 * Description: Manipulate windows - move, resize, minimize, etc.
 * Category: Window Management
 * Version: AHK v2.0+
 *
 * Window functions: WinMove, WinResize, WinActivate, etc.
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Win+Left Arrow = Snap window to left half
#Left::{
    if WinExist("A") {
        MonitorGetWorkArea(, &left, &top, &right, &bottom)
        width := (right - left) // 2
        height := bottom - top
        WinMove left, top, width, height, "A"
    }
}

; Win+Right Arrow = Snap window to right half
#Right::{
    if WinExist("A") {
        MonitorGetWorkArea(, &left, &top, &right, &bottom)
        width := (right - left) // 2
        height := bottom - top
        WinMove left + width, top, width, height, "A"
    }
}

; Win+Up = Maximize window
#Up::WinMaximize "A"

; Win+Down = Minimize or restore window
#Down::{
    if WinGetMinMax("A") = 0
        WinMinimize "A"
    else
        WinRestore "A"
}

; Ctrl+Alt+C = Center active window
^!c::{
    if WinExist("A") {
        WinGetPos(&x, &y, &w, &h, "A")
        MonitorGetWorkArea(, &left, &top, &right, &bottom)

        newX := left + ((right - left - w) // 2)
        newY := top + ((bottom - top - h) // 2)

        WinMove newX, newY,,, "A"
    }
}

; Ctrl+Alt+T = Always on top toggle
^!t::{
    WinSetAlwaysOnTop -1, "A"
    isOnTop := WinGetExStyle("A") & 0x8
    ToolTip isOnTop ? "Always On Top: ON" : "Always On Top: OFF"
    SetTimer () => ToolTip(), -1500
}

; Ctrl+Alt+O = Set window 50% opacity
^!o::{
    WinSetTransparent 128, "A"
    ToolTip "Opacity: 50%"
    SetTimer () => ToolTip(), -1000
}

; Ctrl+Alt+P = Restore full opacity
^!p::{
    WinSetTransparent "Off", "A"
    ToolTip "Opacity: 100%"
    SetTimer () => ToolTip(), -1000
}

; Ctrl+Alt+H = Hide active window
^!h::{
    WinHide "A"
    ToolTip "Window hidden (Ctrl+Alt+S to show all)"
    SetTimer () => ToolTip(), -2000
}

; Ctrl+Alt+S = Show all hidden windows
^!s::{
    for hwnd in WinGetList() {
        if !WinGetTitle(hwnd) and WinExist("ahk_id " hwnd)
            try WinShow "ahk_id " hwnd
    }
    ToolTip "All windows shown"
    SetTimer () => ToolTip(), -1000
}

; Ctrl+Alt+I = Show window info
^!i::{
    if WinExist("A") {
        title := WinGetTitle("A")
        class := WinGetClass("A")
        pid := WinGetPID("A")
        process := WinGetProcessName("A")
        WinGetPos(&x, &y, &w, &h, "A")

        MsgBox "
        (
        Window Information:
        ==================
        Title: " title "
        Class: " class "
        Process: " process "
        PID: " pid "
        Position: X=" x " Y=" y "
        Size: W=" w " H=" h "
        )"
    }
}

Esc::ExitApp
