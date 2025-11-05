/*
 * Script: 23_dll_calls.ahk
 * Description: DLL function calls and Windows API
 * Category: System - DLL/API
 * Version: AHK v2.0+
 *
 * DllCall for Windows API functions
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Message Box (Windows API) ===

; Ctrl+Alt+1 = MessageBox via API
^!1::APIMessageBox()

APIMessageBox() {
    ; Direct Windows API call
    ; MB_YESNO = 4, MB_ICONQUESTION = 32
    result := DllCall("MessageBox"
        , "Ptr", 0          ; hWnd
        , "Str", "This is a MessageBox created via Windows API DllCall!`n`nClick Yes or No."
        , "Str", "API MessageBox"
        , "UInt", 4 + 32)   ; uType (MB_YESNO | MB_ICONQUESTION)

    ; IDYES = 6, IDNO = 7
    if result = 6
        MsgBox "You clicked Yes!", "Result"
    else if result = 7
        MsgBox "You clicked No!", "Result"
}

; === System Beep ===

; Ctrl+Alt+2 = System beep
^!2::SystemBeep()

SystemBeep() {
    ; Beep types
    beeps := Map(
        "Simple", 0xFFFFFFFF,
        "OK", 0x00,
        "Error", 0x10,
        "Question", 0x20,
        "Warning", 0x30,
        "Information", 0x40
    )

    for name, type in beeps {
        ToolTip "Beep: " name
        DllCall("MessageBeep", "UInt", type)
        Sleep 1000
    }

    ToolTip
    MsgBox "Beep demo complete!", "Done"
}

; === Clipboard (Low-level) ===

; Ctrl+Alt+3 = Get clipboard via API
^!3::GetClipboardAPI()

GetClipboardAPI() {
    ; Open clipboard
    if !DllCall("OpenClipboard", "Ptr", 0)
        return MsgBox("Failed to open clipboard", "Error")

    ; Get clipboard data (CF_TEXT = 1)
    hData := DllCall("GetClipboardData", "UInt", 1, "Ptr")

    if hData {
        ; Lock memory
        pData := DllCall("GlobalLock", "Ptr", hData, "Ptr")

        if pData {
            ; Read string
            text := StrGet(pData, "CP0")

            ; Unlock memory
            DllCall("GlobalUnlock", "Ptr", hData)

            MsgBox "Clipboard text (via API):`n`n" text, "Clipboard"
        }
    } else {
        MsgBox "Clipboard is empty or contains non-text data", "Info"
    }

    ; Close clipboard
    DllCall("CloseClipboard")
}

; === Memory Information ===

; Ctrl+Alt+4 = Get memory status
^!4::GetMemoryStatus()

GetMemoryStatus() {
    ; MEMORYSTATUSEX structure
    memStatus := Buffer(64, 0)
    NumPut("UInt", 64, memStatus, 0)  ; dwLength

    ; Call GlobalMemoryStatusEx
    if DllCall("GlobalMemoryStatusEx", "Ptr", memStatus) {
        memoryLoad := NumGet(memStatus, 4, "UInt")
        totalPhys := NumGet(memStatus, 8, "UInt64")
        availPhys := NumGet(memStatus, 16, "UInt64")
        totalVirtual := NumGet(memStatus, 32, "UInt64")
        availVirtual := NumGet(memStatus, 40, "UInt64")

        totalPhysGB := Round(totalPhys / 1073741824, 2)
        availPhysGB := Round(availPhys / 1073741824, 2)
        usedPhysGB := Round((totalPhys - availPhys) / 1073741824, 2)

        result := "
        (
        Memory Status:

        Memory Load: " memoryLoad "%

        Physical Memory:
        Total: " totalPhysGB " GB
        Used: " usedPhysGB " GB
        Available: " availPhysGB " GB

        Virtual Memory:
        Total: " Round(totalVirtual / 1073741824, 2) " GB
        Available: " Round(availVirtual / 1073741824, 2) " GB
        )"

        MsgBox result, "Memory Information"
    }
}

; === System Information ===

; Ctrl+Alt+5 = Get computer name
^!5::GetComputerName()

GetComputerName() {
    ; Buffer for computer name
    size := 256
    nameBuffer := Buffer(size * 2, 0)
    sizeVar := size

    ; Get computer name
    if DllCall("GetComputerName", "Ptr", nameBuffer, "UInt*", &sizeVar) {
        computerName := StrGet(nameBuffer)

        ; Get username
        userBuffer := Buffer(size * 2, 0)
        sizeVar := size

        if DllCall("GetUserName", "Ptr", userBuffer, "UInt*", &sizeVar) {
            userName := StrGet(userBuffer)

            MsgBox "
            (
            System Information:

            Computer Name: " computerName "
            User Name: " userName "
            )", "Computer Info"
        }
    }
}

; === Cursor Position (API) ===

; Ctrl+Alt+6 = Get cursor position via API
^!6::GetCursorPosAPI()

GetCursorPosAPI() {
    ; POINT structure (x, y as Long)
    point := Buffer(8, 0)

    if DllCall("GetCursorPos", "Ptr", point) {
        x := NumGet(point, 0, "Int")
        y := NumGet(point, 4, "Int")

        MsgBox "
        (
        Cursor Position (via API):

        X: " x "
        Y: " y "
        )", "Cursor Info"
    }
}

; === Monitor Information ===

; Ctrl+Alt+7 = Get monitor info
^!7::GetMonitorInfo()

GetMonitorInfo() {
    ; Get primary monitor dimensions
    width := DllCall("GetSystemMetrics", "Int", 0)   ; SM_CXSCREEN
    height := DllCall("GetSystemMetrics", "Int", 1)  ; SM_CYSCREEN

    ; Virtual screen (all monitors)
    virtualWidth := DllCall("GetSystemMetrics", "Int", 78)  ; SM_CXVIRTUALSCREEN
    virtualHeight := DllCall("GetSystemMetrics", "Int", 79) ; SM_CYVIRTUALSCREEN

    ; Monitor count
    monitorCount := DllCall("GetSystemMetrics", "Int", 80)  ; SM_CMONITORS

    result := "
    (
    Monitor Information:

    Primary Monitor:
    " width " x " height "

    Virtual Screen (All Monitors):
    " virtualWidth " x " virtualHeight "

    Monitor Count: " monitorCount "
    )"

    MsgBox result, "Monitor Info"
}

; === Flash Window ===

; Ctrl+Alt+8 = Flash window
^!8::FlashActiveWindow()

FlashActiveWindow() {
    hwnd := WinExist("A")

    if !hwnd {
        MsgBox "No active window"
        return
    }

    ; FLASHWINFO structure
    flashInfo := Buffer(32, 0)
    NumPut("UInt", 32, flashInfo, 0)           ; cbSize
    NumPut("Ptr", hwnd, flashInfo, 8)          ; hwnd
    NumPut("UInt", 0xF, flashInfo, 16)         ; dwFlags (FLASHW_ALL | FLASHW_TIMERNOFG)
    NumPut("UInt", 5, flashInfo, 20)           ; uCount
    NumPut("UInt", 0, flashInfo, 24)           ; dwTimeout

    DllCall("FlashWindowEx", "Ptr", flashInfo)

    MsgBox "Window flashed!", "Done"
}

; === Play Sound ===

; Ctrl+Alt+9 = Play system sound
^!9::PlaySystemSound()

PlaySystemSound() {
    ; Play Windows sounds
    ; SND_ALIAS = 0x10000, SND_ASYNC = 0x1

    sounds := [
        "SystemAsterisk",
        "SystemExclamation",
        "SystemQuestion",
        "SystemHand",
        "SystemExit"
    ]

    for sound in sounds {
        ToolTip "Playing: " sound
        DllCall("winmm\PlaySound", "Str", sound, "Ptr", 0, "UInt", 0x10000 | 0x1)
        Sleep 1500
    }

    ToolTip
    MsgBox "Sound demo complete!", "Done"
}

; === Screen Capture ===

; Ctrl+Alt+0 = Capture screen to clipboard
^!0::CaptureScreen()

CaptureScreen() {
    ; Get screen DC
    screenDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    compatDC := DllCall("CreateCompatibleDC", "Ptr", screenDC, "Ptr")

    ; Get screen dimensions
    width := DllCall("GetSystemMetrics", "Int", 0)
    height := DllCall("GetSystemMetrics", "Int", 1)

    ; Create bitmap
    hBitmap := DllCall("CreateCompatibleBitmap", "Ptr", screenDC, "Int", width, "Int", height, "Ptr")

    ; Select bitmap into DC
    DllCall("SelectObject", "Ptr", compatDC, "Ptr", hBitmap)

    ; Copy screen to bitmap
    DllCall("BitBlt", "Ptr", compatDC, "Int", 0, "Int", 0, "Int", width, "Int", height
        , "Ptr", screenDC, "Int", 0, "Int", 0, "UInt", 0x00CC0020)  ; SRCCOPY

    ; Open clipboard and set bitmap
    DllCall("OpenClipboard", "Ptr", 0)
    DllCall("EmptyClipboard")
    DllCall("SetClipboardData", "UInt", 2, "Ptr", hBitmap)  ; CF_BITMAP = 2
    DllCall("CloseClipboard")

    ; Cleanup
    DllCall("DeleteDC", "Ptr", compatDC)
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", screenDC)

    MsgBox "Screenshot captured to clipboard!`n`nResolution: " width "x" height, "Screen Capture", "Icon√"
}

; === Keyboard State ===

; Ctrl+Alt+K = Get keyboard state
^!k::GetKeyboardState()

GetKeyboardState() {
    ; Check various key states
    capsLock := DllCall("GetKeyState", "Int", 0x14) & 1  ; VK_CAPITAL
    numLock := DllCall("GetKeyState", "Int", 0x90) & 1   ; VK_NUMLOCK
    scrollLock := DllCall("GetKeyState", "Int", 0x91) & 1 ; VK_SCROLL

    ; Check if keys are currently pressed
    shiftPressed := DllCall("GetAsyncKeyState", "Int", 0x10) & 0x8000  ; VK_SHIFT
    ctrlPressed := DllCall("GetAsyncKeyState", "Int", 0x11) & 0x8000   ; VK_CONTROL
    altPressed := DllCall("GetAsyncKeyState", "Int", 0x12) & 0x8000    ; VK_MENU

    result := "
    (
    Keyboard State (via API):

    Lock Keys:
    CapsLock: " (capsLock ? "ON" : "OFF") "
    NumLock: " (numLock ? "ON" : "OFF") "
    ScrollLock: " (scrollLock ? "ON" : "OFF") "

    Currently Pressed:
    Shift: " (shiftPressed ? "YES" : "NO") "
    Ctrl: " (ctrlPressed ? "YES" : "NO") "
    Alt: " (altPressed ? "YES" : "NO") "
    )"

    MsgBox result, "Keyboard State"
}

; === Create Directory (API) ===

; Ctrl+Alt+D = Create directory via API
^!d::CreateDirectoryAPI()

CreateDirectoryAPI() {
    dirName := InputBox("Enter directory name:", "Create Directory", , "TestDir_API").Value

    if dirName = "" {
        return
    }

    fullPath := A_ScriptDir "\" dirName

    if DllCall("CreateDirectory", "Str", fullPath, "Ptr", 0) {
        MsgBox "Directory created via API!`n`n" fullPath, "Success", "Icon√"
    } else {
        errorCode := DllCall("GetLastError")
        MsgBox "Failed to create directory.`n`nError code: " errorCode, "Error", "Iconx"
    }
}

; === Sleep System ===

; Ctrl+Alt+S = Sleep/Hibernate system
^!s::SleepSystem()

SleepSystem() {
    result := MsgBox("
    (
    System Power:

    Yes = Sleep
    No = Hibernate
    Cancel = Cancel
    )", "Power", "YesNoCancel Icon!")

    if result = "Yes" {
        ; Sleep
        DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
    } else if result = "No" {
        ; Hibernate
        DllCall("PowrProf\SetSuspendState", "Int", 1, "Int", 0, "Int", 0)
    }
}

; === Help ===
^!h::{
    MsgBox "
    (
    DLL Calls & Windows API:
    =======================
    Ctrl+Alt+1: MessageBox API
    Ctrl+Alt+2: System beeps
    Ctrl+Alt+3: Clipboard API
    Ctrl+Alt+4: Memory status
    Ctrl+Alt+5: Computer name
    Ctrl+Alt+6: Cursor position
    Ctrl+Alt+7: Monitor info
    Ctrl+Alt+8: Flash window
    Ctrl+Alt+9: Play sounds
    Ctrl+Alt+0: Screen capture
    Ctrl+Alt+K: Keyboard state
    Ctrl+Alt+D: Create directory
    Ctrl+Alt+S: Sleep system

    Esc: Exit
    )", "Help"
}

Esc::ExitApp
