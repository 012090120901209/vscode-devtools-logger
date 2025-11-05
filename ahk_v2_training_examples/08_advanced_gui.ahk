/*
 * Script: 08_advanced_gui.ahk
 * Description: Advanced GUI with ListView, Progress, Tabs
 * Category: GUI - Advanced
 * Version: AHK v2.0+
 *
 * Advanced controls: ListView, TreeView, Tab, Progress, Slider
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Create tabbed GUI
mainGui := Gui("+Resize", "Advanced GUI Demo")
mainGui.SetFont("s9", "Segoe UI")

; Create tabs
tabCtrl := mainGui.Add("Tab3", "x10 y10 w580 h400", ["List View", "Progress", "Settings"])

; === TAB 1: ListView ===
tabCtrl.UseTab(1)
lv := mainGui.Add("ListView", "x20 y40 w560 h300", ["Name", "Email", "Status"])
lv.ModifyCol(1, 180)
lv.ModifyCol(2, 200)
lv.ModifyCol(3, 150)

; Add sample data
lv.Add("", "John Doe", "john@example.com", "Active")
lv.Add("", "Jane Smith", "jane@example.com", "Inactive")
lv.Add("", "Bob Johnson", "bob@example.com", "Active")

addBtn := mainGui.Add("Button", "x20 y350 w100", "Add Row")
addBtn.OnEvent("Click", AddRow)

delBtn := mainGui.Add("Button", "x130 y350 w100", "Delete Row")
delBtn.OnEvent("Click", DeleteRow)

; === TAB 2: Progress ===
tabCtrl.UseTab(2)
mainGui.Add("Text", "x20 y40", "Progress Bar Demo:")
progressBar := mainGui.Add("Progress", "x20 y65 w560 h30 -Smooth", 0)
progressText := mainGui.Add("Text", "x20 y100 w560 Center", "0%")

startBtn := mainGui.Add("Button", "x20 y130 w100", "Start")
startBtn.OnEvent("Click", StartProgress)

stopBtn := mainGui.Add("Button", "x130 y130 w100", "Stop")
stopBtn.OnEvent("Click", StopProgress)

; Slider control
mainGui.Add("Text", "x20 y170", "Manual Progress (Slider):")
slider := mainGui.Add("Slider", "x20 y190 w560 h30 Range0-100 TickInterval10")
slider.OnEvent("Change", UpdateSlider)

; === TAB 3: Settings ===
tabCtrl.UseTab(3)
mainGui.Add("Text", "x20 y40", "Application Settings:")
mainGui.Add("CheckBox", "x20 y65 vAutoStart", "Start with Windows")
mainGui.Add("CheckBox", "x20 y90 vMinimizeTray Checked", "Minimize to tray")
mainGui.Add("CheckBox", "x20 y115 vShowNotifications Checked", "Show notifications")

mainGui.Add("Text", "x20 y150", "Theme:")
themeCombo := mainGui.Add("DropDownList", "x20 y170 w200", ["Light", "Dark", "Auto"])
themeCombo.Choose(1)

mainGui.Add("Text", "x20 y210", "Update frequency (seconds):")
freqEdit := mainGui.Add("Edit", "x20 y230 w100 Number", "60")
mainGui.Add("UpDown", "Range10-600", 60)

saveBtn := mainGui.Add("Button", "x20 y270 w100", "Save Settings")
saveBtn.OnEvent("Click", SaveSettings)

; Show GUI
tabCtrl.UseTab()  ; End tab control
mainGui.Show("w600 h420")

; === Functions ===
AddRow(*) {
    static counter := 1
    lv.Add("", "User " counter, "user" counter "@example.com", "Active")
    counter++
}

DeleteRow(*) {
    if lv.GetNext() {
        lv.Delete(lv.GetNext())
    } else {
        MsgBox "Please select a row to delete"
    }
}

progressRunning := false
StartProgress(*) {
    global progressRunning := true
    SetTimer UpdateProgress, 100
}

StopProgress(*) {
    global progressRunning := false
    SetTimer UpdateProgress, 0
}

UpdateProgress() {
    static value := 0
    if progressRunning {
        value := Mod(value + 2, 101)
        progressBar.Value := value
        progressText.Text := value "%"
    }
}

UpdateSlider(*) {
    progressBar.Value := slider.Value
    progressText.Text := slider.Value "%"
}

SaveSettings(*) {
    saved := mainGui.Submit(0)
    MsgBox "Settings saved!`n`nAutoStart: " saved.AutoStart "`nMinimize to Tray: " saved.MinimizeTray
}

mainGui.OnEvent("Close", (*) => ExitApp())
