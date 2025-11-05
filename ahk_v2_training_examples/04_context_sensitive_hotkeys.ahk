/*
 * Script: 04_context_sensitive_hotkeys.ahk
 * Description: Hotkeys that change based on active window
 * Category: Hotkeys - Context
 * Version: AHK v2.0+
 *
 * #HotIf creates context-sensitive hotkeys
 * Different behavior based on active window
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Global hotkey - works everywhere
^!h::MsgBox "This works everywhere!"

; Only in Notepad
#HotIf WinActive("ahk_exe notepad.exe")
    ^s::{
        Send "^s"  ; Save
        MsgBox "Notepad file saved!"
    }

    ^w::WinClose "A"  ; Close active window
#HotIf

; Only in Chrome/Edge
#HotIf WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe")
    ^+t::{
        Send "^+t"  ; Reopen closed tab
        ToolTip "Reopened last tab"
        SetTimer () => ToolTip(), -2000
    }

    ; Alt+1 through Alt+9 for tab switching
    !1::Send "^1"
    !2::Send "^2"
    !3::Send "^3"
#HotIf

; Only in VS Code
#HotIf WinActive("ahk_exe Code.exe")
    ^!t::Send "^``"  ; Toggle terminal
    ^!b::Send "^+b"  ; Toggle sidebar
    F5::Send "^{F5}"  ; Debug
#HotIf

; Only when Excel is active
#HotIf WinActive("ahk_exe EXCEL.EXE")
    ^!f::Send "^f"  ; Find
    ^+s::MsgBox "Saving Excel file with custom action"
#HotIf

; Hotkey that works only when Notepad is NOT active
#HotIf !WinActive("ahk_exe notepad.exe")
    ^n::Run "notepad.exe"
#HotIf

; Custom condition function
#HotIf IsWorkHours()
    ^!w::MsgBox "Work mode active - it's " FormatTime(, "HH:mm")
#HotIf

IsWorkHours() {
    hour := FormatTime(, "H")
    return (hour >= 9 and hour < 17)  ; 9 AM to 5 PM
}

Esc::ExitApp
