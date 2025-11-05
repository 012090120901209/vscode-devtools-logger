/*
 * Script: 09_tray_menu.ahk
 * Description: Custom tray icon menu and notifications
 * Category: GUI - Tray
 * Version: AHK v2.0+
 *
 * Create custom system tray menu and show notifications
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Configure tray icon
A_IconTip := "My Custom AHK Script`nDouble-click for options"
TraySetIcon "shell32.dll", 174  ; Custom icon from system DLL

; Remove default menu items
A_TrayMenu.Delete()

; Add custom menu items
A_TrayMenu.Add("Show Message", ShowMessage)
A_TrayMenu.Add("Show Notification", ShowNotification)
A_TrayMenu.Add()  ; Separator

; Add submenu
toolsMenu := Menu()
toolsMenu.Add("Calculator", (*) => Run("calc.exe"))
toolsMenu.Add("Notepad", (*) => Run("notepad.exe"))
toolsMenu.Add("Command Prompt", (*) => Run("cmd.exe"))

A_TrayMenu.Add("Tools", toolsMenu)
A_TrayMenu.Add()  ; Separator

; Add checkable items
A_TrayMenu.Add("Enable Feature 1", ToggleFeature1)
A_TrayMenu.Add("Enable Feature 2", ToggleFeature2)
A_TrayMenu.Add()  ; Separator

; Standard items
A_TrayMenu.Add("Reload Script", (*) => Reload())
A_TrayMenu.Add("Edit Script", (*) => Edit())
A_TrayMenu.Add("Exit", (*) => ExitApp())

; Set default action (double-click)
A_TrayMenu.Default := "Show Message"

; Single click behavior
OnMessage(0x404, AHK_NOTIFYICON)  ; 0x404 = WM_TRAYICON

; === Functions ===
ShowMessage(*) {
    MsgBox "
    (
    This is a custom tray menu!

    Current Time: " FormatTime(, "HH:mm:ss") "
    Script: " A_ScriptName "
    )", "Tray Menu Action"
}

ShowNotification(*) {
    TrayTip "Hello from AHK!", "This is a system notification.`nClick to dismiss.", 1

    ; Auto-hide after 3 seconds
    SetTimer () => TrayTip(), -3000
}

feature1Enabled := false
ToggleFeature1(itemName, itemPos, myMenu) {
    global feature1Enabled := !feature1Enabled

    if feature1Enabled {
        myMenu.Check(itemName)
        TrayTip "Feature 1 Enabled", "Feature 1 is now active", 1
    } else {
        myMenu.Uncheck(itemName)
        TrayTip "Feature 1 Disabled", "Feature 1 is now inactive", 1
    }

    SetTimer () => TrayTip(), -2000
}

feature2Enabled := false
ToggleFeature2(itemName, itemPos, myMenu) {
    global feature2Enabled := !feature2Enabled

    if feature2Enabled {
        myMenu.Check(itemName)
    } else {
        myMenu.Uncheck(itemName)
    }
}

; Handle tray icon clicks
AHK_NOTIFYICON(wParam, lParam, *) {
    if lParam = 0x202  ; WM_LBUTTONUP (left click)
        TrayTip "Script Status", "Running normally`nHotkeys active", 1

    ; Auto-hide tooltip
    SetTimer () => TrayTip(), -2000
}

; Show startup notification
TrayTip "Script Started", A_ScriptName " is now running`nCheck the tray icon", 1
SetTimer () => TrayTip(), -3000

; Hotkey to show custom balloon
^!n::{
    TrayTip "Custom Notification", "Triggered by Ctrl+Alt+N`nTime: " FormatTime(, "HH:mm:ss"), 1
    SetTimer () => TrayTip(), -3000
}
