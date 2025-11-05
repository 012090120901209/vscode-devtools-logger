/*
 * Script: 02_hotstrings.ahk
 * Description: Text expansion with hotstrings
 * Category: Hotstrings
 * Version: AHK v2.0+
 *
 * Hotstring Options:
 * * = No ending character needed
 * ? = Trigger in middle of word
 * C = Case-sensitive
 * O = Omit ending character
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Basic text replacement - type "btw" + space/enter
::btw::by the way

; Email expansion with asterisk option (triggers immediately)
:*:@@::myemail@example.com

; Current date insertion
:*:ddate::{
    SendText FormatTime(, "yyyy-MM-dd")
}

; Current time insertion
:*:ttime::{
    SendText FormatTime(, "HH:mm:ss")
}

; Multi-line expansion
::addr::{
    SendText "
    (
    John Doe
    123 Main Street
    Anytown, ST 12345
    )"
}

; Case-sensitive hotstring
:C:AHK::AutoHotkey v2

; Trigger in middle of word
:?*:func::{
    SendText "function() {}`n{Left 2}"
}

; Phone number formatting
::phone::+1 (555) 123-4567

; Code snippet
::clog::{
    SendText "console.log();"
    Send "{Left 2}"
}

; Exit with Esc
Esc::ExitApp
