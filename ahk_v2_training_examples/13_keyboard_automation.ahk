/*
 * Script: 13_keyboard_automation.ahk
 * Description: Automated keyboard input and typing
 * Category: Automation - Keyboard
 * Version: AHK v2.0+
 *
 * Send, SendText, SendInput, ControlSend examples
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Basic Send Commands ===

; Ctrl+Alt+1 = Type a sentence
^!1::{
    Sleep 1000  ; Delay to switch windows
    SendText "This is automated typing from AutoHotkey v2!"
}

; Ctrl+Alt+2 = Type with special keys
^!2::{
    Sleep 1000
    Send "Hello{Space}World{!}"  ; ! = Enter
    Send "Line 2{Enter}"
    Send "Tab{Tab}Indented text"
}

; Ctrl+Alt+3 = Simulate keyboard shortcuts
^!3::{
    Sleep 1000
    Send "^a"      ; Ctrl+A (Select All)
    Sleep 100
    Send "^c"      ; Ctrl+C (Copy)
    Sleep 100
    Send "{End}"   ; Go to end
    Send "{Enter}" ; New line
    Send "^v"      ; Ctrl+V (Paste)
}

; === Form Filling Automation ===

; Ctrl+Alt+F = Fill sample form
^!f::FillForm()

FillForm() {
    MsgBox "Click OK, then click on a form field.`n`nThe script will fill the form automatically.", "Form Filler", "T5"

    Sleep 2000

    ; Sample form data
    SendText "John Doe"
    Send "{Tab}"

    SendText "john.doe@example.com"
    Send "{Tab}"

    SendText "+1-555-123-4567"
    Send "{Tab}"

    SendText "123 Main Street"
    Send "{Tab}"

    SendText "New York"
    Send "{Tab}"

    SendText "NY"
    Send "{Tab}"

    SendText "10001"
}

; === Typing Speed Simulation ===

; Ctrl+Alt+T = Type with realistic delays
^!t::TypeRealistic()

TypeRealistic() {
    MsgBox "Click OK to start typing simulation", , "T3"
    Sleep 2000

    text := "This is typed with realistic delays between keystrokes."

    for char in StrSplit(text) {
        SendText char
        Sleep Random(50, 150)  ; Random delay 50-150ms
    }
}

; === Repeat Actions ===

; Ctrl+Alt+R = Repeat key press
^!r::{
    MsgBox "Will press Down arrow 10 times (switch to target window)", , "T3"
    Sleep 2000

    Loop 10 {
        Send "{Down}"
        Sleep 200
    }
}

; Ctrl+Alt+E = Spam Enter key
^!e::{
    answer := MsgBox("Press Enter key 20 times?", "Confirm", "YesNo")

    if answer = "Yes" {
        Sleep 2000
        Loop 20 {
            Send "{Enter}"
            Sleep 100
        }
    }
}

; === Mouse + Keyboard Combo ===

; Ctrl+Alt+M = Click and type
^!m::{
    MsgBox "Will click at current position and type", , "T2"
    Sleep 1000

    Click
    Sleep 200
    SendText "Clicked and typed!"
}

; === Send to Specific Control ===

; Ctrl+Alt+N = Send to Notepad directly
^!n::{
    if WinExist("ahk_exe notepad.exe") {
        ; Activate and send
        WinActivate
        Sleep 100
        SendText "This was sent to Notepad specifically!`n"
    } else {
        ; Launch Notepad first
        Run "notepad.exe"
        WinWait "ahk_exe notepad.exe", , 5

        if WinExist("ahk_exe notepad.exe") {
            WinActivate
            Sleep 500
            SendText "Notepad launched and text inserted!`n"
        }
    }
}

; === Advanced Sequences ===

; Ctrl+Alt+S = Multi-step sequence
^!s::MultiStepSequence()

MultiStepSequence() {
    MsgBox "Starting multi-step sequence...`n`n1. Open Run dialog`n2. Type 'notepad'`n3. Press Enter", , "T3"

    Send "#r"  ; Win+R
    Sleep 500

    SendText "notepad"
    Sleep 300

    Send "{Enter}"
    Sleep 1000

    ; Type in Notepad
    SendText "=== Automated Sequence ===`n"
    SendText "Time: " FormatTime(, "HH:mm:ss") "`n"
    SendText "This was fully automated!`n"
}

; === Special Characters ===

; Ctrl+Alt+P = Type special characters
^!p::{
    Sleep 1000

    ; Curly braces need escaping
    Send "Curly braces: {{}{}}{Enter}"

    ; Special symbols
    SendText "Special: !@#$%^&*()"
    Send "{Enter}"

    ; Unicode characters
    SendText "Unicode: © ® ™ € £ ¥"
    Send "{Enter}"

    ; Emoji (if supported)
    SendText "Emoji: 😀 🚀 ✅"
}

; === Control Specific Window ===

; Ctrl+Alt+W = Send to background window
^!w::{
    if WinExist("ahk_exe notepad.exe") {
        ; Send without activating window
        ControlSend "This was sent to background Notepad!{Enter}", "Edit1", "ahk_exe notepad.exe"

        ToolTip "Sent to background Notepad"
        SetTimer () => ToolTip(), -2000
    } else {
        MsgBox "Notepad not found!"
    }
}

; === Keyboard State Detection ===

; Ctrl+Alt+K = Show keyboard state
^!k::{
    capsState := GetKeyState("CapsLock", "T") ? "ON" : "OFF"
    numState := GetKeyState("NumLock", "T") ? "ON" : "OFF"
    scrollState := GetKeyState("ScrollLock", "T") ? "ON" : "OFF"

    ctrlPressed := GetKeyState("Ctrl", "P") ? "Pressed" : "Not Pressed"
    shiftPressed := GetKeyState("Shift", "P") ? "Pressed" : "Not Pressed"
    altPressed := GetKeyState("Alt", "P") ? "Pressed" : "Not Pressed"

    MsgBox "
    (
    Lock Keys:
    CapsLock: " capsState "
    NumLock: " numState "
    ScrollLock: " scrollState "

    Modifier Keys:
    Ctrl: " ctrlPressed "
    Shift: " shiftPressed "
    Alt: " altPressed "
    )", "Keyboard State"
}

; === Toggle Locks ===

; Ctrl+Alt+CapsLock = Toggle CapsLock state
^!CapsLock::{
    SetCapsLockState !GetKeyState("CapsLock", "T")
    state := GetKeyState("CapsLock", "T") ? "ON" : "OFF"
    ToolTip "CapsLock: " state
    SetTimer () => ToolTip(), -1000
}

; === Input Blocker ===

blockInput := false

; Ctrl+Alt+B = Toggle input blocking (use carefully!)
^!b::{
    global blockInput := !blockInput

    if blockInput {
        BlockInput true
        TrayTip "Input Blocked", "Press Ctrl+Alt+B to unblock", 1
    } else {
        BlockInput false
        TrayTip "Input Unblocked", "Keyboard and mouse active", 1
    }

    SetTimer () => TrayTip(), -2000
}

; === Help ===
^!h::{
    MsgBox "
    (
    Keyboard Automation:
    ===================
    Ctrl+Alt+1: Simple typing
    Ctrl+Alt+2: Special keys
    Ctrl+Alt+3: Keyboard shortcuts
    Ctrl+Alt+F: Fill form
    Ctrl+Alt+T: Realistic typing
    Ctrl+Alt+R: Repeat Down key
    Ctrl+Alt+E: Spam Enter
    Ctrl+Alt+M: Click and type
    Ctrl+Alt+N: Send to Notepad
    Ctrl+Alt+S: Multi-step sequence
    Ctrl+Alt+P: Special characters
    Ctrl+Alt+W: Background window
    Ctrl+Alt+K: Keyboard state
    Ctrl+Alt+B: Block input
    Esc: Exit
    )", "Help"
}

Esc::ExitApp
