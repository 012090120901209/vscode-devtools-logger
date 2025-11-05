/*
 * Script: 20_ini_json_config.ahk
 * Description: Configuration files (INI, JSON, custom)
 * Category: Advanced - Configuration
 * Version: AHK v2.0+
 *
 * INI file handling, JSON parsing, config management
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === INI File Operations ===

; Ctrl+Alt+1 = Create INI file
^!1::CreateINI()

CreateINI() {
    iniFile := "config.ini"

    ; Write INI sections and values
    IniWrite "John Doe", iniFile, "User", "Name"
    IniWrite "john@example.com", iniFile, "User", "Email"
    IniWrite "30", iniFile, "User", "Age"

    IniWrite "1920", iniFile, "Display", "Width"
    IniWrite "1080", iniFile, "Display", "Height"
    IniWrite "true", iniFile, "Display", "Fullscreen"

    IniWrite "en-US", iniFile, "Settings", "Language"
    IniWrite "Dark", iniFile, "Settings", "Theme"
    IniWrite "true", iniFile, "Settings", "AutoSave"

    MsgBox "INI file created: " A_ScriptDir "\" iniFile, "Success"
}

; Ctrl+Alt+2 = Read INI file
^!2::ReadINI()

ReadINI() {
    iniFile := "config.ini"

    if !FileExist(iniFile) {
        MsgBox "INI file not found! Press Ctrl+Alt+1 to create it."
        return
    }

    ; Read values
    userName := IniRead(iniFile, "User", "Name", "Unknown")
    userEmail := IniRead(iniFile, "User", "Email", "no-email")
    userAge := IniRead(iniFile, "User", "Age", "0")

    width := IniRead(iniFile, "Display", "Width", "1024")
    height := IniRead(iniFile, "Display", "Height", "768")
    fullscreen := IniRead(iniFile, "Display", "Fullscreen", "false")

    language := IniRead(iniFile, "Settings", "Language", "en-US")
    theme := IniRead(iniFile, "Settings", "Theme", "Light")

    result := "
    (
    [User]
    Name: " userName "
    Email: " userEmail "
    Age: " userAge "

    [Display]
    Resolution: " width "x" height "
    Fullscreen: " fullscreen "

    [Settings]
    Language: " language "
    Theme: " theme "
    )"

    MsgBox result, "INI File Contents"
}

; Ctrl+Alt+3 = Update INI value
^!3::UpdateINI()

UpdateINI() {
    iniFile := "config.ini"

    if !FileExist(iniFile) {
        MsgBox "INI file not found! Press Ctrl+Alt+1 to create it."
        return
    }

    ; Update a value
    IniWrite "Jane Smith", iniFile, "User", "Name"
    IniWrite "Light", iniFile, "Settings", "Theme"

    MsgBox "INI file updated!`n`nChanged:`n- User Name to 'Jane Smith'`n- Theme to 'Light'", "Updated"
}

; Ctrl+Alt+4 = Delete INI section
^!4::DeleteINISection()

DeleteINISection() {
    iniFile := "config.ini"

    if !FileExist(iniFile) {
        MsgBox "INI file not found!"
        return
    }

    IniDelete iniFile, "Display"

    MsgBox "Deleted [Display] section from INI file", "Deleted"
}

; === JSON Operations ===

; Ctrl+Alt+5 = Create JSON
^!5::CreateJSON()

CreateJSON() {
    ; Create JSON structure (as a Map)
    config := Map(
        "user", Map(
            "name", "John Doe",
            "email", "john@example.com",
            "age", 30,
            "premium", true
        ),
        "settings", Map(
            "theme", "dark",
            "language", "en-US",
            "notifications", true
        ),
        "recent_files", ["file1.txt", "file2.txt", "file3.txt"]
    )

    ; Convert to JSON string
    jsonStr := MapToJSON(config)

    ; Save to file
    FileDelete "config.json"
    FileAppend jsonStr, "config.json"

    MsgBox "JSON file created: " A_ScriptDir "\config.json`n`n" jsonStr, "JSON Created"
}

; Simple JSON serializer (basic implementation)
MapToJSON(obj, indent := "") {
    if obj is Map {
        result := "{`n"
        items := []

        for key, value in obj {
            items.Push(indent "  " Quote(key) ": " MapToJSON(value, indent "  "))
        }

        result .= StrJoin(items, ",`n") "`n" indent "}"
        return result
    }
    else if obj is Array {
        result := "[`n"
        items := []

        for value in obj {
            items.Push(indent "  " MapToJSON(value, indent "  "))
        }

        result .= StrJoin(items, ",`n") "`n" indent "]"
        return result
    }
    else if obj is String {
        return Quote(obj)
    }
    else if obj = true or obj = false {
        return obj ? "true" : "false"
    }
    else {
        return String(obj)
    }
}

Quote(str) {
    ; Escape special characters
    str := StrReplace(str, "\", "\\")
    str := StrReplace(str, '"', '\"')
    str := StrReplace(str, "`n", "\n")
    str := StrReplace(str, "`r", "\r")
    str := StrReplace(str, "`t", "\t")

    return '"' str '"'
}

StrJoin(arr, delimiter) {
    result := ""
    for index, item in arr {
        result .= item
        if index < arr.Length
            result .= delimiter
    }
    return result
}

; Ctrl+Alt+6 = Read JSON
^!6::ReadJSON()

ReadJSON() {
    if !FileExist("config.json") {
        MsgBox "JSON file not found! Press Ctrl+Alt+5 to create it."
        return
    }

    jsonStr := FileRead("config.json")

    MsgBox "JSON File Contents:`n`n" jsonStr, "JSON File", "W500"
}

; === Custom Config Format ===

; Ctrl+Alt+7 = Save custom config
^!7::SaveCustomConfig()

SaveCustomConfig() {
    config := "
    (
    # Application Configuration
    # Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "

    [Application]
    Name=MyApp
    Version=1.0.0

    [User]
    Username=admin
    Role=Administrator

    [Paths]
    DataDir=C:\Data
    LogDir=C:\Logs
    TempDir=C:\Temp

    [Features]
    EnableLogging=true
    EnableDebug=false
    MaxConnections=100
    )"

    FileDelete "custom_config.cfg"
    FileAppend config, "custom_config.cfg"

    MsgBox "Custom config saved to: custom_config.cfg", "Saved"
}

; Ctrl+Alt+8 = Parse custom config
^!8::ParseCustomConfig()

ParseCustomConfig() {
    if !FileExist("custom_config.cfg") {
        MsgBox "Config file not found!"
        return
    }

    config := Map()
    currentSection := ""

    Loop Read "custom_config.cfg" {
        line := Trim(A_LoopReadLine)

        ; Skip empty lines and comments
        if line = "" or SubStr(line, 1, 1) = "#"
            continue

        ; Check for section header
        if RegExMatch(line, "^\[(.*)\]$", &match) {
            currentSection := match[1]
            config[currentSection] := Map()
            continue
        }

        ; Parse key=value
        if RegExMatch(line, "^(.*?)=(.*)$", &match) {
            key := Trim(match[1])
            value := Trim(match[2])

            if currentSection != ""
                config[currentSection][key] := value
        }
    }

    ; Display parsed config
    result := "Parsed Configuration:`n`n"

    for section, values in config {
        result .= "[" section "]`n"

        for key, value in values {
            result .= "  " key " = " value "`n"
        }

        result .= "`n"
    }

    MsgBox result, "Custom Config Parsed"
}

; === Settings Class ===

class AppSettings {
    static filePath := "app_settings.ini"

    ; Load setting
    static Get(section, key, default := "") {
        return IniRead(this.filePath, section, key, default)
    }

    ; Save setting
    static Set(section, key, value) {
        IniWrite value, this.filePath, section, key
    }

    ; Get all section keys
    static GetSection(section) {
        return IniRead(this.filePath, section)
    }

    ; Check if setting exists
    static Has(section, key) {
        value := IniRead(this.filePath, section, key, "###DEFAULT###")
        return value != "###DEFAULT###"
    }

    ; Remove setting
    static Remove(section, key) {
        IniDelete this.filePath, section, key
    }
}

; Ctrl+Alt+9 = Test settings class
^!9::TestSettingsClass()

TestSettingsClass() {
    ; Save settings
    AppSettings.Set("Window", "Width", "1920")
    AppSettings.Set("Window", "Height", "1080")
    AppSettings.Set("User", "Name", "Alice")
    AppSettings.Set("User", "Theme", "Dark")

    ; Load settings
    width := AppSettings.Get("Window", "Width")
    height := AppSettings.Get("Window", "Height")
    name := AppSettings.Get("User", "Name")
    theme := AppSettings.Get("User", "Theme")

    ; Check existence
    hasWidth := AppSettings.Has("Window", "Width")
    hasColor := AppSettings.Has("Window", "Color")

    result := "
    (
    Settings Class Test:

    Window Size: " width "x" height "
    User: " name "
    Theme: " theme "

    Has Width setting: " (hasWidth ? "Yes" : "No") "
    Has Color setting: " (hasColor ? "Yes" : "No") "
    )"

    MsgBox result, "Settings Class"
}

; === Backup/Restore Config ===

; Ctrl+Alt+B = Backup config
^!b::BackupConfig()

BackupConfig() {
    timestamp := FormatTime(, "yyyy-MM-dd_HH-mm-ss")
    backupDir := "config_backup"

    DirCreate backupDir

    ; Backup all config files
    Loop Files "*.ini" {
        FileCopy A_LoopFilePath, backupDir "\" A_LoopFileNameNoExt "_" timestamp ".ini", 1
    }

    Loop Files "*.json" {
        FileCopy A_LoopFilePath, backupDir "\" A_LoopFileNameNoExt "_" timestamp ".json", 1
    }

    Loop Files "*.cfg" {
        FileCopy A_LoopFilePath, backupDir "\" A_LoopFileNameNoExt "_" timestamp ".cfg", 1
    }

    MsgBox "Config files backed up to: " A_ScriptDir "\" backupDir, "Backup Complete"
}

; === Help ===
^!h::{
    MsgBox "
    (
    Configuration Files:
    ===================
    INI Operations:
    Ctrl+Alt+1: Create INI
    Ctrl+Alt+2: Read INI
    Ctrl+Alt+3: Update INI
    Ctrl+Alt+4: Delete INI section

    JSON Operations:
    Ctrl+Alt+5: Create JSON
    Ctrl+Alt+6: Read JSON

    Custom Config:
    Ctrl+Alt+7: Save custom config
    Ctrl+Alt+8: Parse custom config

    Advanced:
    Ctrl+Alt+9: Settings class demo
    Ctrl+Alt+B: Backup configs

    Esc: Exit
    )", "Help"
}

Esc::ExitApp
