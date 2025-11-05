/*
 * Script: 11_file_operations.ahk
 * Description: File and directory operations
 * Category: File I/O
 * Version: AHK v2.0+
 *
 * Functions: FileRead, FileAppend, FileDelete, DirCreate, etc.
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Set working directory
SetWorkingDir A_ScriptDir

; === Create Test Files ===
^!1::CreateTestFiles()

CreateTestFiles() {
    try {
        ; Create directory
        DirCreate("test_folder")

        ; Write text file
        FileAppend "This is a test file`nLine 2`nLine 3", "test_folder\test.txt"

        ; Write with timestamp
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        FileAppend "`n[" timestamp "] File created", "test_folder\test.txt"

        ; Create CSV file
        csvContent := "Name,Email,Age`nJohn,john@example.com,30`nJane,jane@example.com,25"
        FileAppend csvContent, "test_folder\data.csv"

        ; Create JSON file
        jsonContent := '{"name": "Test", "version": "1.0", "enabled": true}'
        FileAppend jsonContent, "test_folder\config.json"

        MsgBox "Test files created in: " A_ScriptDir "\test_folder"
    } catch as err {
        MsgBox "Error: " err.Message
    }
}

; === Read File ===
^!2::ReadFile()

ReadFile() {
    try {
        if !FileExist("test_folder\test.txt") {
            MsgBox "File not found! Press Ctrl+Alt+1 to create test files."
            return
        }

        content := FileRead("test_folder\test.txt")
        MsgBox "File Contents:`n`n" content, "test.txt"
    } catch as err {
        MsgBox "Error reading file: " err.Message
    }
}

; === Append to File ===
^!3::AppendToFile()

AppendToFile() {
    try {
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        FileAppend "`n[" timestamp "] New entry added", "test_folder\test.txt"

        MsgBox "Appended to file. Press Ctrl+Alt+2 to view."
    } catch as err {
        MsgBox "Error: " err.Message
    }
}

; === Read File Line by Line ===
^!4::ReadFileLines()

ReadFileLines() {
    try {
        if !FileExist("test_folder\test.txt")
            return MsgBox("File not found!")

        lines := []
        Loop Read "test_folder\test.txt" {
            lines.Push("Line " A_Index ": " A_LoopReadLine)
        }

        result := ""
        for line in lines
            result .= line "`n"

        MsgBox result, "Line by Line Reading"
    } catch as err {
        MsgBox "Error: " err.Message
    }
}

; === Copy Files ===
^!5::CopyFiles()

CopyFiles() {
    try {
        if !DirExist("test_folder")
            return MsgBox("Source folder not found!")

        ; Create backup directory
        DirCreate("backup_folder")

        ; Copy single file
        FileCopy "test_folder\test.txt", "backup_folder\test_backup.txt", 1

        ; Copy all files from folder
        Loop Files "test_folder\*.*" {
            FileCopy A_LoopFilePath, "backup_folder\" A_LoopFileName, 1
        }

        MsgBox "Files copied to: " A_ScriptDir "\backup_folder"
    } catch as err {
        MsgBox "Error: " err.Message
    }
}

; === Move/Rename Files ===
^!6::MoveFiles()

MoveFiles() {
    try {
        if !FileExist("test_folder\test.txt")
            return MsgBox("File not found!")

        ; Rename file
        FileMove "test_folder\test.txt", "test_folder\renamed.txt", 1

        MsgBox "File renamed: test.txt → renamed.txt"
    } catch as err {
        MsgBox "Error: " err.Message
    }
}

; === Delete Files ===
^!7::DeleteFiles()

DeleteFiles() {
    result := MsgBox("Delete test folders and files?", "Confirm", "YesNo Icon!")

    if result = "Yes" {
        try {
            ; Delete files
            FileDelete "test_folder\*.*"
            FileDelete "backup_folder\*.*"

            ; Delete directories
            DirDelete "test_folder"
            DirDelete "backup_folder"

            MsgBox "Test files deleted!"
        } catch as err {
            MsgBox "Error: " err.Message
        }
    }
}

; === File Information ===
^!8::ShowFileInfo()

ShowFileInfo() {
    try {
        if !FileExist("test_folder\test.txt") and !FileExist("test_folder\renamed.txt")
            return MsgBox("File not found!")

        filePath := FileExist("test_folder\test.txt") ? "test_folder\test.txt" : "test_folder\renamed.txt"

        ; Get file attributes
        size := FileGetSize(filePath)
        time := FileGetTime(filePath, "M")  ; Modification time
        attrib := FileGetAttrib(filePath)

        timeFormatted := FormatTime(time, "yyyy-MM-dd HH:mm:ss")

        info := "
        (
        File: " filePath "
        Size: " size " bytes
        Modified: " timeFormatted "
        Attributes: " attrib "
        )"

        MsgBox info, "File Information"
    } catch as err {
        MsgBox "Error: " err.Message
    }
}

; === Search Files ===
^!9::SearchFiles()

SearchFiles() {
    try {
        results := "Files in test_folder:`n`n"
        count := 0

        Loop Files "test_folder\*.*", "R"  ; R = Recursive
        {
            count++
            results .= A_LoopFileName " (" A_LoopFileSize " bytes)`n"
        }

        results .= "`nTotal: " count " file(s)"

        if count > 0
            MsgBox results, "Search Results"
        else
            MsgBox "No files found"
    } catch {
        MsgBox "Folder not found"
    }
}

; === Help ===
^!h::{
    help := "
    (
    File Operations Hotkeys:
    ========================
    Ctrl+Alt+1: Create test files
    Ctrl+Alt+2: Read file
    Ctrl+Alt+3: Append to file
    Ctrl+Alt+4: Read line by line
    Ctrl+Alt+5: Copy files
    Ctrl+Alt+6: Move/rename files
    Ctrl+Alt+7: Delete files
    Ctrl+Alt+8: Show file info
    Ctrl+Alt+9: Search files
    Ctrl+Alt+H: Show this help
    Esc: Exit script
    )"

    MsgBox help, "Help"
}

Esc::ExitApp
