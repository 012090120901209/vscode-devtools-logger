/*
 * Script: 01_basic_hotkeys.ahk
 * Description: Basic hotkey definitions with modifiers
 * Category: Hotkeys
 * Version: AHK v2.0+
 *
 * Key Modifiers:
 * ^ = Ctrl | ! = Alt | + = Shift | # = Win
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Simple hotkey - Ctrl+J opens Notepad
^j::Run "notepad.exe"

; Multiple modifiers - Ctrl+Shift+N opens Calculator
^+n::Run "calc.exe"

; Win key hotkey - Win+E opens Explorer (override default)
#e::{
    Run "explorer.exe"
    MsgBox "Custom Explorer launcher triggered"
}

; Alt+Space shows a message
!Space::{
    MsgBox "You pressed Alt+Space!`nTimestamp: " FormatTime(, "yyyy-MM-dd HH:mm:ss")
}

; Function key - F12 reloads this script
F12::{
    MsgBox "Reloading script..."
    Reload
}

; Escape to exit script
Esc::ExitApp
