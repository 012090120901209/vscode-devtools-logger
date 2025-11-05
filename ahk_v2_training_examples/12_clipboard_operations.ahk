/*
 * Script: 12_clipboard_operations.ahk
 * Description: Advanced clipboard manipulation
 * Category: Clipboard
 * Version: AHK v2.0+
 *
 * Clipboard management: copy, paste, history, formatting
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Clipboard history (stores last 10 items)
global clipHistory := []
global maxHistorySize := 10

; Monitor clipboard changes
OnClipboardChange ClipboardMonitor

; === Basic Clipboard Operations ===

; Ctrl+Alt+C = Show clipboard content
^!c::{
    if A_Clipboard = ""
        MsgBox "Clipboard is empty"
    else
        MsgBox "Clipboard Content:`n`n" A_Clipboard, "Clipboard", "T10"
}

; Ctrl+Alt+X = Clear clipboard
^!x::{
    A_Clipboard := ""
    ToolTip "Clipboard cleared"
    SetTimer () => ToolTip(), -1000
}

; Ctrl+Alt+V = Show clipboard history
^!v::ShowClipboardHistory()

; === Clipboard Transformations ===

; Ctrl+Shift+U = Convert clipboard to UPPERCASE
^+u::{
    if A_Clipboard != "" {
        A_Clipboard := StrUpper(A_Clipboard)
        ToolTip "Converted to UPPERCASE"
        SetTimer () => ToolTip(), -1000
    }
}

; Ctrl+Shift+L = Convert clipboard to lowercase
^+l::{
    if A_Clipboard != "" {
        A_Clipboard := StrLower(A_Clipboard)
        ToolTip "Converted to lowercase"
        SetTimer () => ToolTip(), -1000
    }
}

; Ctrl+Shift+T = Title Case
^+t::{
    if A_Clipboard != "" {
        A_Clipboard := StrTitle(A_Clipboard)
        ToolTip "Converted to Title Case"
        SetTimer () => ToolTip(), -1000
    }
}

; Ctrl+Shift+R = Remove line breaks
^+r::{
    if A_Clipboard != "" {
        A_Clipboard := StrReplace(A_Clipboard, "`r`n", " ")
        A_Clipboard := StrReplace(A_Clipboard, "`n", " ")
        ToolTip "Line breaks removed"
        SetTimer () => ToolTip(), -1000
    }
}

; Ctrl+Shift+S = Sort lines alphabetically
^+s::{
    if A_Clipboard != "" {
        lines := Sort(A_Clipboard)
        A_Clipboard := lines
        ToolTip "Lines sorted"
        SetTimer () => ToolTip(), -1000
    }
}

; === Advanced Operations ===

; Ctrl+Alt+1 = Save clipboard to file
^!1::{
    if A_Clipboard = ""
        return MsgBox("Clipboard is empty!")

    timestamp := FormatTime(, "yyyy-MM-dd_HH-mm-ss")
    fileName := "clipboard_" timestamp ".txt"

    FileAppend A_Clipboard, fileName
    MsgBox "Clipboard saved to:`n" A_WorkingDir "\" fileName
}

; Ctrl+Alt+2 = Append clipboard to file
^!2::{
    if A_Clipboard = "" {
        MsgBox "Clipboard is empty!"
        return
    }

    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    entry := "`n========== [" timestamp "] ==========`n" A_Clipboard "`n"

    FileAppend entry, "clipboard_log.txt"
    ToolTip "Appended to clipboard_log.txt"
    SetTimer () => ToolTip(), -2000
}

; Ctrl+Alt+3 = Copy file contents to clipboard
^!3::{
    selectedFile := FileSelect(3, , "Select a text file", "Text Files (*.txt; *.log; *.md)")

    if selectedFile {
        try {
            A_Clipboard := FileRead(selectedFile)
            MsgBox "File contents copied to clipboard!`n`nFile: " selectedFile
        } catch as err {
            MsgBox "Error reading file: " err.Message
        }
    }
}

; === Clipboard History ===

ClipboardMonitor(dataType) {
    if dataType = 1 {  ; Text data
        ; Add to history if not empty and different from last
        if A_Clipboard != "" and (clipHistory.Length = 0 or A_Clipboard != clipHistory[1]) {
            clipHistory.InsertAt(1, A_Clipboard)

            ; Limit history size
            if clipHistory.Length > maxHistorySize
                clipHistory.RemoveAt(maxHistorySize + 1)
        }
    }
}

ShowClipboardHistory() {
    if clipHistory.Length = 0 {
        MsgBox "Clipboard history is empty"
        return
    }

    ; Create GUI
    historyGui := Gui("+AlwaysOnTop", "Clipboard History")
    historyGui.SetFont("s9", "Consolas")

    historyGui.Add("Text", "x10 y10", "Select an item to restore to clipboard:")

    lv := historyGui.Add("ListView", "x10 y35 w600 h300", ["#", "Preview"])
    lv.ModifyCol(1, 40)
    lv.ModifyCol(2, 540)

    ; Populate list
    for index, item in clipHistory {
        preview := StrReplace(item, "`r`n", " ")
        preview := StrReplace(preview, "`n", " ")
        if StrLen(preview) > 80
            preview := SubStr(preview, 1, 80) "..."

        lv.Add("", index, preview)
    }

    lv.OnEvent("DoubleClick", RestoreClipboard)

    btnRestore := historyGui.Add("Button", "x10 y345 w100", "Restore")
    btnRestore.OnEvent("Click", RestoreClipboard)

    btnDelete := historyGui.Add("Button", "x120 y345 w100", "Delete")
    btnDelete.OnEvent("Click", DeleteHistoryItem)

    btnClear := historyGui.Add("Button", "x230 y345 w100", "Clear All")
    btnClear.OnEvent("Click", ClearHistory)

    historyGui.Show("w620 h380")

    RestoreClipboard(*) {
        row := lv.GetNext()
        if row {
            A_Clipboard := clipHistory[row]
            ToolTip "Restored to clipboard"
            SetTimer () => ToolTip(), -1500
            historyGui.Destroy()
        }
    }

    DeleteHistoryItem(*) {
        row := lv.GetNext()
        if row {
            clipHistory.RemoveAt(row)
            lv.Delete(row)
        }
    }

    ClearHistory(*) {
        clipHistory := []
        historyGui.Destroy()
    }
}

; === Clipboard Formatting ===

; Ctrl+Alt+Q = Quote clipboard text
^!q::{
    if A_Clipboard != "" {
        lines := StrSplit(A_Clipboard, "`n")
        quoted := ""

        for line in lines
            quoted .= "> " line "`n"

        A_Clipboard := RTrim(quoted, "`n")
        ToolTip "Text quoted"
        SetTimer () => ToolTip(), -1000
    }
}

; Ctrl+Alt+B = Add bullet points
^!b::{
    if A_Clipboard != "" {
        lines := StrSplit(A_Clipboard, "`n")
        bulleted := ""

        for line in lines {
            trimmed := Trim(line)
            if trimmed != ""
                bulleted .= "• " trimmed "`n"
        }

        A_Clipboard := RTrim(bulleted, "`n")
        ToolTip "Bullets added"
        SetTimer () => ToolTip(), -1000
    }
}

; Ctrl+Alt+N = Number lines
^!n::{
    if A_Clipboard != "" {
        lines := StrSplit(A_Clipboard, "`n")
        numbered := ""

        for index, line in lines {
            trimmed := Trim(line)
            if trimmed != ""
                numbered .= index ". " trimmed "`n"
        }

        A_Clipboard := RTrim(numbered, "`n")
        ToolTip "Lines numbered"
        SetTimer () => ToolTip(), -1000
    }
}

; === Help ===
^!h::{
    MsgBox "
    (
    Clipboard Operations:
    ====================
    Ctrl+Alt+C: Show clipboard
    Ctrl+Alt+V: Show history
    Ctrl+Alt+X: Clear clipboard

    Transformations:
    Ctrl+Shift+U: UPPERCASE
    Ctrl+Shift+L: lowercase
    Ctrl+Shift+T: Title Case
    Ctrl+Shift+R: Remove line breaks
    Ctrl+Shift+S: Sort lines

    Formatting:
    Ctrl+Alt+Q: Quote text
    Ctrl+Alt+B: Add bullets
    Ctrl+Alt+N: Number lines

    File Operations:
    Ctrl+Alt+1: Save to file
    Ctrl+Alt+2: Append to log
    Ctrl+Alt+3: Load from file

    Esc: Exit
    )", "Help"
}

Esc::ExitApp
