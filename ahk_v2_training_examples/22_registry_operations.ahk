/*
 * Script: 22_registry_operations.ahk
 * Description: Windows Registry read/write operations
 * Category: System - Registry
 * Version: AHK v2.0+
 *
 * RegRead, RegWrite, RegDelete operations
 * CAUTION: Modifying registry can affect system stability
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Test registry path (safe for testing)
testKeyPath := "HKEY_CURRENT_USER\Software\AHK_Test"

; === Create Registry Key ===

; Ctrl+Alt+1 = Create test key
^!1::CreateTestKey()

CreateTestKey() {
    try {
        ; Write various value types
        RegWrite "Test Value", "REG_SZ", testKeyPath, "StringValue"
        RegWrite 42, "REG_DWORD", testKeyPath, "NumberValue"
        RegWrite 1, "REG_DWORD", testKeyPath, "BooleanValue"

        MsgBox "
        (
        Test registry key created:

        " testKeyPath "

        Values:
        - StringValue = 'Test Value'
        - NumberValue = 42
        - BooleanValue = 1
        )", "Registry Created", "Icon√"
    } catch as err {
        MsgBox "Error: " err.Message, "Failed", "Iconx"
    }
}

; === Read Registry Values ===

; Ctrl+Alt+2 = Read values
^!2::ReadValues()

ReadValues() {
    try {
        stringVal := RegRead(testKeyPath, "StringValue")
        numberVal := RegRead(testKeyPath, "NumberValue")
        boolVal := RegRead(testKeyPath, "BooleanValue")

        result := "
        (
        Registry Values:

        String: " stringVal "
        Number: " numberVal "
        Boolean: " boolVal "
        )"

        MsgBox result, "Registry Read", "Icon√"
    } catch as err {
        MsgBox "Error reading registry: " err.Message "`n`nPress Ctrl+Alt+1 to create test key.", "Error", "Iconx"
    }
}

; === Update Registry Value ===

; Ctrl+Alt+3 = Update value
^!3::UpdateValue()

UpdateValue() {
    try {
        ; Update existing value
        newValue := InputBox("Enter new string value:", "Update Registry", , "Updated Value").Value

        if newValue != "" {
            RegWrite newValue, "REG_SZ", testKeyPath, "StringValue"
            MsgBox "Value updated to: " newValue, "Success", "Icon√"
        }
    } catch as err {
        MsgBox "Error: " err.Message, "Failed", "Iconx"
    }
}

; === Delete Registry Value ===

; Ctrl+Alt+4 = Delete value
^!4::DeleteValue()

DeleteValue() {
    result := MsgBox("Delete 'StringValue' from test key?", "Confirm Delete", "YesNo Icon!")

    if result = "Yes" {
        try {
            RegDelete testKeyPath, "StringValue"
            MsgBox "Value deleted successfully", "Deleted", "Icon√"
        } catch as err {
            MsgBox "Error: " err.Message, "Failed", "Iconx"
        }
    }
}

; === Delete Entire Key ===

; Ctrl+Alt+5 = Delete test key
^!5::DeleteTestKey()

DeleteTestKey() {
    result := MsgBox("
    (
    Delete entire test key?

    " testKeyPath "

    This will remove all values.
    )", "Confirm Delete", "YesNo Icon!")

    if result = "Yes" {
        try {
            RegDeleteKey testKeyPath
            MsgBox "Test key deleted successfully", "Deleted", "Icon√"
        } catch as err {
            MsgBox "Error: " err.Message, "Failed", "Iconx"
        }
    }
}

; === System Registry Information ===

; Ctrl+Alt+6 = Get Windows version
^!6::GetWindowsVersion()

GetWindowsVersion() {
    try {
        productName := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName")
        buildNumber := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentBuild")
        displayVersion := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DisplayVersion")

        result := "
        (
        Windows Version Information:

        Product: " productName "
        Build: " buildNumber "
        Version: " displayVersion "
        )"

        MsgBox result, "Windows Info", "Icon√"
    } catch as err {
        MsgBox "Error: " err.Message, "Error", "Iconx"
    }
}

; === User Preferences ===

; Ctrl+Alt+7 = Read user preferences
^!7::ReadUserPreferences()

ReadUserPreferences() {
    try {
        ; Desktop wallpaper
        wallpaper := RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "Wallpaper")

        ; Theme
        themePath := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes", "CurrentTheme")

        ; Mouse speed
        mouseSpeed := RegRead("HKEY_CURRENT_USER\Control Panel\Mouse", "MouseSpeed")

        result := "
        (
        User Preferences:

        Wallpaper:
        " wallpaper "

        Theme:
        " themePath "

        Mouse Speed: " mouseSpeed "
        )"

        MsgBox result, "User Settings", "Icon√"
    } catch as err {
        MsgBox "Error: " err.Message, "Error", "Iconx"
    }
}

; === Application Settings ===

class AppRegistry {
    static rootKey := "HKEY_CURRENT_USER\Software\MyApp"

    ; Save setting
    static SaveSetting(name, value, type := "REG_SZ") {
        try {
            RegWrite value, type, this.rootKey, name
            return true
        } catch {
            return false
        }
    }

    ; Load setting
    static LoadSetting(name, default := "") {
        try {
            return RegRead(this.rootKey, name)
        } catch {
            return default
        }
    }

    ; Remove setting
    static RemoveSetting(name) {
        try {
            RegDelete this.rootKey, name
            return true
        } catch {
            return false
        }
    }

    ; Check if setting exists
    static HasSetting(name) {
        try {
            RegRead this.rootKey, name
            return true
        } catch {
            return false
        }
    }

    ; Clear all settings
    static ClearAll() {
        try {
            RegDeleteKey this.rootKey
            return true
        } catch {
            return false
        }
    }
}

; Ctrl+Alt+8 = Test app registry class
^!8::TestAppRegistry()

TestAppRegistry() {
    ; Save settings
    AppRegistry.SaveSetting("Username", "JohnDoe")
    AppRegistry.SaveSetting("Theme", "Dark")
    AppRegistry.SaveSetting("AutoSave", 1, "REG_DWORD")
    AppRegistry.SaveSetting("Volume", 75, "REG_DWORD")

    ; Load settings
    username := AppRegistry.LoadSetting("Username", "Guest")
    theme := AppRegistry.LoadSetting("Theme", "Light")
    autoSave := AppRegistry.LoadSetting("AutoSave", 0)
    volume := AppRegistry.LoadSetting("Volume", 50)

    ; Check existence
    hasUsername := AppRegistry.HasSetting("Username")
    hasColor := AppRegistry.HasSetting("Color")

    result := "
    (
    App Registry Test:

    Saved and Loaded:
    Username: " username "
    Theme: " theme "
    AutoSave: " autoSave "
    Volume: " volume "

    Setting Exists:
    Username: " (hasUsername ? "Yes" : "No") "
    Color: " (hasColor ? "Yes" : "No") "
    )"

    MsgBox result, "App Registry", "Icon√"
}

; Ctrl+Alt+9 = Clear app settings
^!9::{
    result := MsgBox("Clear all app registry settings?", "Confirm", "YesNo Icon!")

    if result = "Yes" {
        if AppRegistry.ClearAll()
            MsgBox "App settings cleared", "Success", "Icon√"
        else
            MsgBox "No settings to clear", "Info", "Icon√"
    }
}

; === File Associations ===

; Ctrl+Alt+0 = Get file association
^!0::GetFileAssociation()

GetFileAssociation() {
    ext := InputBox("Enter file extension (e.g., .txt):", "File Association", , ".txt").Value

    if ext = ""
        return

    try {
        ; Get program ID
        progID := RegRead("HKEY_CLASSES_ROOT\" ext, "")

        ; Get command
        command := RegRead("HKEY_CLASSES_ROOT\" progID "\shell\open\command", "")

        result := "
        (
        File Association for " ext ":

        Program ID: " progID "

        Command:
        " command "
        )"

        MsgBox result, "File Association", "Icon√"
    } catch as err {
        MsgBox "Error: " err.Message "`n`nExtension may not be registered.", "Error", "Iconx"
    }
}

; === Environment Variables (via Registry) ===

; Ctrl+Alt+E = Show environment variables
^!e::ShowEnvironmentVars()

ShowEnvironmentVars() {
    try {
        ; User environment variables
        userPath := RegRead("HKEY_CURRENT_USER\Environment", "Path")
        userTemp := RegRead("HKEY_CURRENT_USER\Environment", "TEMP")

        result := "
        (
        User Environment Variables:

        TEMP:
        " userTemp "

        PATH:
        " userPath "
        )"

        MsgBox result, "Environment Variables", "Icon√"
    } catch as err {
        MsgBox "Error: " err.Message, "Error", "Iconx"
    }
}

; === Registry Browser ===

; Ctrl+Alt+B = Browse registry key
^!b::BrowseRegistry()

BrowseRegistry() {
    keyPath := InputBox("
    (
    Enter registry key path:

    Examples:
    HKEY_CURRENT_USER\Software
    HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft
    )", "Registry Browser", "W400", "HKEY_CURRENT_USER\Software").Value

    if keyPath = ""
        return

    try {
        ; Try to read a value to verify key exists
        ; This is a workaround as AHK v2 doesn't have a direct key enumeration function

        MsgBox "
        (
        Registry key path:
        " keyPath "

        To view values, use RegEdit or PowerShell:
        Get-ItemProperty -Path 'Registry::" keyPath "'
        )", "Registry Browser", "Icon√"
    } catch as err {
        MsgBox "Error accessing key: " err.Message, "Error", "Iconx"
    }
}

; === Warning and Help ===

^!h::{
    MsgBox "
    (
    Registry Operations:
    ===================
    ⚠️ WARNING: Be careful with registry operations!

    Test Operations (Safe):
    Ctrl+Alt+1: Create test key
    Ctrl+Alt+2: Read values
    Ctrl+Alt+3: Update value
    Ctrl+Alt+4: Delete value
    Ctrl+Alt+5: Delete test key

    System Information:
    Ctrl+Alt+6: Windows version
    Ctrl+Alt+7: User preferences
    Ctrl+Alt+0: File association
    Ctrl+Alt+E: Environment vars

    App Settings:
    Ctrl+Alt+8: Test app registry
    Ctrl+Alt+9: Clear app settings

    Tools:
    Ctrl+Alt+B: Browse registry

    Esc: Exit
    )", "Help"
}

Esc::ExitApp
