/*
 * Script: 06_simple_gui.ahk
 * Description: Create a simple GUI with buttons and text input
 * Category: GUI - Basics
 * Version: AHK v2.0+
 *
 * GUI components: Button, Edit, Text, CheckBox, Radio, etc.
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Create main GUI
myGui := Gui("+AlwaysOnTop", "My First GUI")
myGui.SetFont("s10", "Segoe UI")

; Add controls
myGui.Add("Text", "x10 y10 w300", "Enter your name:")
nameEdit := myGui.Add("Edit", "x10 y35 w300 vUserName", "")

myGui.Add("Text", "x10 y70", "Select your favorite:")
favCombo := myGui.Add("DropDownList", "x10 y90 w300", ["Coffee", "Tea", "Water"])
favCombo.Choose(1)

enableCheck := myGui.Add("CheckBox", "x10 y125", "Enable notifications")
enableCheck.Value := 1

; Add buttons
submitBtn := myGui.Add("Button", "x10 y160 w145", "Submit")
submitBtn.OnEvent("Click", SubmitForm)

clearBtn := myGui.Add("Button", "x165 y160 w145", "Clear")
clearBtn.OnEvent("Click", ClearForm)

; Result display
resultText := myGui.Add("Text", "x10 y195 w300 h60 +Border")

; Show GUI
myGui.Show("w320 h265")

; Button handlers
SubmitForm(*) {
    savedGui := myGui.Submit(0)  ; 0 = don't hide GUI

    result := "
    (
    Name: " savedGui.UserName "
    Favorite: " favCombo.Text "
    Notifications: " (enableCheck.Value ? "Enabled" : "Disabled") "
    )"

    resultText.Text := result
}

ClearForm(*) {
    nameEdit.Value := ""
    favCombo.Choose(1)
    enableCheck.Value := 1
    resultText.Text := ""
}

; Close on Escape
myGui.OnEvent("Escape", (*) => ExitApp())
myGui.OnEvent("Close", (*) => ExitApp())
