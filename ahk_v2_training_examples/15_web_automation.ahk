/*
 * Script: 15_web_automation.ahk
 * Description: Web browser automation and scraping
 * Category: Automation - Web
 * Version: AHK v2.0+
 *
 * COM automation with Internet Explorer / Edge
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Basic Web Navigation ===

; Ctrl+Alt+1 = Open webpage
^!1::{
    Run "https://www.example.com"
}

; Ctrl+Alt+2 = Open multiple tabs
^!2::{
    Run "https://www.google.com"
    Sleep 500
    Run "https://www.github.com"
    Sleep 500
    Run "https://www.stackoverflow.com"

    ToolTip "Opened 3 websites"
    SetTimer () => ToolTip(), -2000
}

; === Browser Control with COM ===

; Ctrl+Alt+3 = Open with Edge/IE object
^!3::OpenWithCOM()

OpenWithCOM() {
    try {
        ; Create Edge/IE COM object
        wb := ComObject("InternetExplorer.Application")
        wb.Visible := true

        ; Navigate to URL
        wb.Navigate("https://www.example.com")

        ; Wait for page load
        while wb.Busy or wb.ReadyState != 4
            Sleep 100

        MsgBox "Page loaded successfully!`n`nTitle: " wb.Document.Title
    } catch as err {
        MsgBox "Error: " err.Message "`n`nNote: COM automation requires IE mode."
    }
}

; === Form Filling ===

; Ctrl+Alt+F = Fill web form
^!f::FillWebForm()

FillWebForm() {
    MsgBox "
    (
    This will fill a web form.

    1. Open a webpage with a form
    2. Click OK
    3. Click on the first input field
    )", "Web Form Filler", "T5"

    Sleep 3000

    ; Fill form fields (simulate Tab navigation)
    SendText "John Doe"
    Send "{Tab}"

    SendText "john.doe@example.com"
    Send "{Tab}"

    SendText "MyPassword123"
    Send "{Tab}"

    SendText "MyPassword123"
    Send "{Tab}"

    Send "{Space}"  ; Check checkbox
    Send "{Tab}"

    ; Submit (if button is focused)
    ; Send "{Enter}"

    ToolTip "Form filled (verify before submitting)"
    SetTimer () => ToolTip(), -3000
}

; === URL from Clipboard ===

; Ctrl+Alt+U = Open URL from clipboard
^!u::{
    url := A_Clipboard

    ; Basic URL validation
    if RegExMatch(url, "i)^https?://") {
        Run url
        ToolTip "Opened: " url
    } else {
        ; Try adding https://
        Run "https://" url
        ToolTip "Opened: https://" url
    }

    SetTimer () => ToolTip(), -2000
}

; === Search Operations ===

; Ctrl+Alt+G = Google search selected text
^!g::GoogleSearch()

GoogleSearch() {
    ; Save clipboard
    savedClip := ClipboardAll()

    ; Copy selected text
    A_Clipboard := ""
    Send "^c"
    ClipWait 1

    if A_Clipboard != "" {
        searchTerm := A_Clipboard
        encodedTerm := UriEncode(searchTerm)

        Run "https://www.google.com/search?q=" encodedTerm

        ToolTip "Searching Google for: " searchTerm
        SetTimer () => ToolTip(), -2000
    } else {
        MsgBox "No text selected!"
    }

    ; Restore clipboard
    A_Clipboard := savedClip
}

; URI encoding function
UriEncode(str) {
    encoded := ""
    for char in StrSplit(str) {
        code := Ord(char)
        if (code >= 48 and code <= 57) or (code >= 65 and code <= 90) or (code >= 97 and code <= 122) or InStr("-_.~", char)
            encoded .= char
        else
            encoded .= "%" Format("{:02X}", code)
    }
    return encoded
}

; Ctrl+Alt+Y = YouTube search
^!y::{
    savedClip := ClipboardAll()
    A_Clipboard := ""
    Send "^c"
    ClipWait 1

    if A_Clipboard != "" {
        searchTerm := UriEncode(A_Clipboard)
        Run "https://www.youtube.com/results?search_query=" searchTerm
    } else {
        MsgBox "No text selected!"
    }

    A_Clipboard := savedClip
}

; === Download URL ===

; Ctrl+Alt+D = Download file from URL
^!d::DownloadFile()

DownloadFile() {
    ib := InputBox("Enter URL to download:", "File Downloader")

    if ib.Result = "OK" {
        url := ib.Value

        ; Get filename from URL
        fileName := SubStr(url, InStr(url, "/", , -1) + 1)
        if fileName = ""
            fileName := "download.html"

        savePath := A_ScriptDir "\" fileName

        try {
            Download url, savePath
            MsgBox "Downloaded to:`n" savePath
        } catch as err {
            MsgBox "Download failed: " err.Message
        }
    }
}

; === HTTP Request (Simple) ===

; Ctrl+Alt+R = Make HTTP request
^!r::MakeRequest()

MakeRequest() {
    try {
        ; Download to variable
        content := Download("https://api.github.com/")

        ; Show first 500 chars
        preview := SubStr(content, 1, 500)
        MsgBox "Response (first 500 chars):`n`n" preview, "HTTP Response"

        ; Save full response
        FileDelete "response.json"
        FileAppend content, "response.json"

        ToolTip "Full response saved to response.json"
        SetTimer () => ToolTip(), -3000
    } catch as err {
        MsgBox "Request failed: " err.Message
    }
}

; === Browser-Specific Actions ===

#HotIf WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe")

    ; Ctrl+Shift+C = Copy URL
    ^+c::{
        Send "!d"  ; Alt+D (focus address bar)
        Sleep 100
        Send "^c"  ; Copy
        Sleep 100
        Send "{Esc}"  ; Unfocus

        ToolTip "URL copied"
        SetTimer () => ToolTip(), -1000
    }

    ; Ctrl+Shift+N = New incognito window
    ^+n::Send "^+n"

    ; Alt+Q = Close all tabs except current
    !q::{
        Loop 20 {  ; Close up to 20 tabs to the right
            Send "^w"
            Sleep 50
        }
    }

#HotIf

; === Website Shortcuts ===

; Ctrl+Alt+Shift+G = GitHub
^!+g::Run "https://github.com"

; Ctrl+Alt+Shift+S = Stack Overflow
^!+s::Run "https://stackoverflow.com"

; Ctrl+Alt+Shift+R = Reddit
^!+r::Run "https://reddit.com"

; Ctrl+Alt+Shift+T = Twitter/X
^!+t::Run "https://twitter.com"

; === Page Actions ===

; Ctrl+Alt+P = Print page
^!p::{
    Send "^p"
}

; Ctrl+Alt+S = Save page
^!s::{
    Send "^s"
}

; Ctrl+Alt+Z = Zoom in
^!z::{
    Send "^{+}"
    ToolTip "Zoom In"
    SetTimer () => ToolTip(), -500
}

; Ctrl+Alt+X = Zoom out
^!x::{
    Send "^-"
    ToolTip "Zoom Out"
    SetTimer () => ToolTip(), -500
}

; === Screenshot Web Element ===

; Ctrl+Alt+C = Capture screenshot
^!c::{
    timestamp := FormatTime(, "yyyy-MM-dd_HH-mm-ss")
    fileName := "screenshot_" timestamp ".png"

    ; Take screenshot of active window
    Send "!{PrintScreen}"  ; Alt+PrintScreen (window only)

    Sleep 500

    ; Save from clipboard
    if DllCall("IsClipboardFormatAvailable", "uint", 2) {  ; CF_BITMAP
        ; Clipboard contains image
        ToolTip "Screenshot captured. Paste to save."
        SetTimer () => ToolTip(), -2000
    }
}

; === Help ===
^!h::{
    MsgBox "
    (
    Web Automation:
    ===============
    Ctrl+Alt+1: Open webpage
    Ctrl+Alt+2: Open multiple tabs
    Ctrl+Alt+3: Open with COM
    Ctrl+Alt+F: Fill web form
    Ctrl+Alt+U: Open URL from clipboard
    Ctrl+Alt+G: Google search
    Ctrl+Alt+Y: YouTube search
    Ctrl+Alt+D: Download file
    Ctrl+Alt+R: HTTP request
    Ctrl+Alt+P: Print page
    Ctrl+Alt+S: Save page

    Website Shortcuts:
    Ctrl+Alt+Shift+G: GitHub
    Ctrl+Alt+Shift+S: Stack Overflow
    Ctrl+Alt+Shift+R: Reddit

    Browser (Chrome/Edge):
    Ctrl+Shift+C: Copy URL
    Alt+Q: Close other tabs

    Esc: Exit
    )", "Help"
}

Esc::ExitApp
