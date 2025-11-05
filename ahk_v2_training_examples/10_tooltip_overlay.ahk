/*
 * Script: 10_tooltip_overlay.ahk
 * Description: Create custom tooltips and on-screen displays
 * Category: GUI - Overlay
 * Version: AHK v2.0+
 *
 * Show information overlays without interrupting work
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Simple Tooltips ===

; Ctrl+Alt+T = Show tooltip at mouse
^!t::{
    MouseGetPos &x, &y
    ToolTip "Position: " x ", " y "`n" FormatTime(, "HH:mm:ss"), x + 10, y + 10
    SetTimer () => ToolTip(), -3000
}

; Ctrl+Alt+M = Show multiple tooltips
^!m::{
    ToolTip "Tooltip 1", 100, 100, 1
    ToolTip "Tooltip 2", 100, 150, 2
    ToolTip "Tooltip 3", 100, 200, 3

    SetTimer ClearTooltips, -5000
}

ClearTooltips() {
    Loop 3
        ToolTip(,,,A_Index)
}

; === Custom Styled GUI Overlay ===

; Ctrl+Alt+O = Show custom overlay
^!o::CreateOverlay()

CreateOverlay() {
    static overlayGui := ""

    ; Destroy existing overlay
    if overlayGui
        overlayGui.Destroy()

    ; Create borderless GUI
    overlayGui := Gui("-Caption +AlwaysOnTop +ToolWindow +E0x20")
    overlayGui.BackColor := "000000"
    overlayGui.SetFont("s12 cWhite Bold", "Segoe UI")

    ; Add content
    overlayGui.Add("Text", "x10 y10 w300", "System Information")
    overlayGui.SetFont("s10 cLime Normal")

    cpuText := overlayGui.Add("Text", "x10 y40 w280", "CPU: Loading...")
    memText := overlayGui.Add("Text", "x10 y65 w280", "Memory: Loading...")
    timeText := overlayGui.Add("Text", "x10 y90 w280", "Time: " FormatTime(, "HH:mm:ss"))

    ; Position at top-right corner
    overlayGui.Show("x" (A_ScreenWidth - 320) " y20 w300 h120 NoActivate")
    WinSetTransparent 200, overlayGui

    ; Update information periodically
    SetTimer UpdateOverlayInfo, 1000

    ; Auto-close after 10 seconds
    SetTimer () => CloseOverlay(), -10000

    UpdateOverlayInfo() {
        if !WinExist(overlayGui)
            return SetTimer(, 0)

        timeText.Value := "Time: " FormatTime(, "HH:mm:ss")
        cpuText.Value := "CPU: " GetCPUUsage() "%"
        memText.Value := "Memory: " GetMemUsage() "%"
    }

    CloseOverlay() {
        SetTimer UpdateOverlayInfo, 0
        if overlayGui
            overlayGui.Destroy()
    }
}

; === Progress Overlay ===

; Ctrl+Alt+P = Show progress overlay
^!p::ShowProgress()

ShowProgress() {
    ; Create overlay
    progGui := Gui("-Caption +AlwaysOnTop +ToolWindow")
    progGui.BackColor := "White"
    progGui.SetFont("s10", "Segoe UI")

    progGui.Add("Text", "x20 y20 w260 Center", "Processing...")
    progBar := progGui.Add("Progress", "x20 y50 w260 h20", 0)
    progText := progGui.Add("Text", "x20 y75 w260 Center", "0%")

    ; Center on screen
    progGui.Show("w300 h110 Center")

    ; Simulate progress
    Loop 100 {
        progBar.Value := A_Index
        progText.Value := A_Index "%"
        Sleep 50
    }

    Sleep 500
    progGui.Destroy()

    MsgBox "Process complete!", "Done", "T1"
}

; === Helper Functions ===

GetCPUUsage() {
    static LastIdleTime := 0, LastKernelTime := 0, LastUserTime := 0

    DllCall("GetSystemTimes", "Int64*", &IdleTime := 0, "Int64*", &KernelTime := 0, "Int64*", &UserTime := 0)

    if LastIdleTime {
        IdleDelta := IdleTime - LastIdleTime
        KernelDelta := KernelTime - LastKernelTime
        UserDelta := UserTime - LastUserTime
        TotalDelta := KernelDelta + UserDelta

        usage := TotalDelta > 0 ? Round(100 - (IdleDelta / TotalDelta * 100)) : 0
    } else {
        usage := 0
    }

    LastIdleTime := IdleTime
    LastKernelTime := KernelTime
    LastUserTime := UserTime

    return usage
}

GetMemUsage() {
    memStatus := Buffer(64, 0)
    NumPut("UInt", 64, memStatus)
    DllCall("GlobalMemoryStatusEx", "Ptr", memStatus)
    return Round(NumGet(memStatus, 4, "UInt"))
}

; === Mouse Coordinate Tracker ===

; Ctrl+Alt+X = Toggle coordinate display
^!x::ToggleCoordinateTracker()

coordinateTracking := false
ToggleCoordinateTracker() {
    global coordinateTracking := !coordinateTracking

    if coordinateTracking {
        SetTimer ShowCoordinates, 100
        TrayTip "Coordinate Tracker", "Enabled - Press Ctrl+Alt+X to disable", 1
    } else {
        SetTimer ShowCoordinates, 0
        ToolTip
        TrayTip "Coordinate Tracker", "Disabled", 1
    }

    SetTimer () => TrayTip(), -2000
}

ShowCoordinates() {
    MouseGetPos &x, &y, &winID
    winTitle := WinGetTitle(winID)

    ToolTip "
    (
    X: " x " | Y: " y "
    Window: " (winTitle ? winTitle : "Desktop") "
    )", 10, 10
}

Esc::ExitApp
