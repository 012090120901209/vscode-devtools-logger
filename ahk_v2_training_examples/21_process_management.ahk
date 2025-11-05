/*
 * Script: 21_process_management.ahk
 * Description: Process and application management
 * Category: System - Processes
 * Version: AHK v2.0+
 *
 * Run, ProcessExist, ProcessClose, WinWait, etc.
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Launch Applications ===

; Ctrl+Alt+1 = Run application
^!1::{
    Run "notepad.exe"
    ToolTip "Launched Notepad"
    SetTimer () => ToolTip(), -1000
}

; Ctrl+Alt+2 = Run with parameters
^!2::{
    Run "notepad.exe C:\Windows\System32\drivers\etc\hosts"
    ToolTip "Opened hosts file"
    SetTimer () => ToolTip(), -1000
}

; Ctrl+Alt+3 = Run and wait
^!3::RunAndWait()

RunAndWait() {
    MsgBox "Will run Calculator and wait for it to close", , "T2"

    RunWait "calc.exe"

    MsgBox "Calculator was closed!", "Process Ended"
}

; === Process Detection ===

; Ctrl+Alt+4 = Check if process exists
^!4::CheckProcess()

CheckProcess() {
    processName := InputBox("Enter process name (e.g., notepad.exe):", "Check Process", , "notepad.exe").Value

    if processName = ""
        return

    if ProcessExist(processName) {
        pid := ProcessExist(processName)
        MsgBox "✓ Process is running!`n`nPID: " pid, "Process Found", "Icon√"
    } else {
        MsgBox "✗ Process not found", "Not Running", "Iconx"
    }
}

; === Process Information ===

; Ctrl+Alt+5 = Get process list
^!5::GetProcessList()

GetProcessList() {
    ; Create GUI with ListView
    procGui := Gui("+Resize", "Process List")
    procGui.SetFont("s9", "Consolas")

    lv := procGui.Add("ListView", "x10 y10 w780 h400", ["Process Name", "PID", "Path"])
    lv.ModifyCol(1, 200)
    lv.ModifyCol(2, 80)
    lv.ModifyCol(3, 480)

    ; Get all process IDs
    processes := Map()

    ; Enumerate windows to get process info
    for hwnd in WinGetList() {
        try {
            pid := WinGetPID(hwnd)
            processName := WinGetProcessName(hwnd)
            processPath := WinGetProcessPath(hwnd)

            if !processes.Has(pid) and processName != "" {
                processes[pid] := {name: processName, path: processPath}
                lv.Add("", processName, pid, processPath)
            }
        }
    }

    btnRefresh := procGui.Add("Button", "x10 y420 w100", "Refresh")
    btnRefresh.OnEvent("Click", (*) => procGui.Destroy() || GetProcessList())

    btnClose := procGui.Add("Button", "x120 y420 w100", "Close")
    btnClose.OnEvent("Click", (*) => procGui.Destroy())

    countText := procGui.Add("Text", "x230 y425", "Processes: " lv.GetCount())

    procGui.Show("w800 h460")
}

; === Process Control ===

; Ctrl+Alt+6 = Close process by name
^!6::CloseProcess()

CloseProcess() {
    processName := InputBox("Enter process name to close:", "Close Process", , "notepad.exe").Value

    if processName = ""
        return

    if ProcessExist(processName) {
        result := MsgBox("Close " processName "?", "Confirm", "YesNo Icon!")

        if result = "Yes" {
            ProcessClose processName

            Sleep 500

            if !ProcessExist(processName)
                MsgBox "Process closed successfully", "Success", "Icon√"
            else
                MsgBox "Failed to close process", "Error", "Iconx"
        }
    } else {
        MsgBox "Process not found!", "Not Running", "Iconx"
    }
}

; Ctrl+Alt+7 = Set process priority
^!7::SetProcessPriority()

SetProcessPriority() {
    processName := InputBox("Enter process name:", "Set Priority", , "notepad.exe").Value

    if processName = ""
        return

    if !ProcessExist(processName) {
        MsgBox "Process not found!"
        return
    }

    priority := InputBox("
    (
    Enter priority:
    L = Low
    B = Below Normal
    N = Normal
    A = Above Normal
    H = High
    R = Realtime
    )", "Priority Level", , "N").Value

    try {
        ProcessSetPriority priority, processName
        MsgBox "Priority set to: " priority, "Success", "Icon√"
    } catch as err {
        MsgBox "Failed to set priority: " err.Message, "Error", "Iconx"
    }
}

; === Wait for Process ===

; Ctrl+Alt+8 = Wait for process
^!8::WaitForProcess()

WaitForProcess() {
    MsgBox "Will wait for Calculator to start...`n`nYou have 10 seconds to launch it.", , "T3"

    ; Wait for process (with timeout)
    startTime := A_TickCount

    while !ProcessExist("calc.exe") and (A_TickCount - startTime) < 10000 {
        Sleep 100
    }

    if ProcessExist("calc.exe")
        MsgBox "Calculator detected!", "Process Found", "Icon√"
    else
        MsgBox "Timeout - Calculator not started", "Timeout", "Icon!"
}

; === Run As Admin ===

; Ctrl+Alt+9 = Run as administrator
^!9::RunAsAdmin()

RunAsAdmin() {
    try {
        Run "*RunAs notepad.exe"
        MsgBox "Launched Notepad as Administrator", "Admin", "Icon√"
    } catch as err {
        MsgBox "Failed to run as admin: " err.Message, "Error", "Iconx"
    }
}

; === Run Command and Capture Output ===

; Ctrl+Alt+0 = Run command and get output
^!0::RunCommand()

RunCommand() {
    command := InputBox("Enter command:", "Run Command", , "ipconfig /all").Value

    if command = ""
        return

    ; Run command and capture output
    shell := ComObject("WScript.Shell")
    exec := shell.Exec(A_ComSpec " /c " command)

    ; Wait for completion
    exec.StdIn.Close()

    output := exec.StdOut.ReadAll()

    if output = ""
        output := "No output or command failed"

    ; Show in GUI
    outputGui := Gui("+Resize", "Command Output")
    outputGui.SetFont("s9", "Consolas")

    edit := outputGui.Add("Edit", "x10 y10 w580 h400 +ReadOnly +Multi", output)

    btnCopy := outputGui.Add("Button", "x10 y420 w100", "Copy All")
    btnCopy.OnEvent("Click", (*) => (A_Clipboard := output, ToolTip("Copied!"), SetTimer(() => ToolTip(), -1000)))

    btnClose := outputGui.Add("Button", "x120 y420 w100", "Close")
    btnClose.OnEvent("Click", (*) => outputGui.Destroy())

    outputGui.Show("w600 h460")
}

; === Monitor Process ===

; Ctrl+Alt+M = Monitor process
^!m::ToggleProcessMonitor()

monitorRunning := false
monitoredProcess := ""

ToggleProcessMonitor() {
    global monitorRunning, monitoredProcess

    if !monitorRunning {
        monitoredProcess := InputBox("Enter process to monitor:", "Process Monitor", , "notepad.exe").Value

        if monitoredProcess = ""
            return

        monitorRunning := true
        SetTimer CheckMonitoredProcess, 2000

        TrayTip "Process Monitor", "Monitoring: " monitoredProcess, 1
    } else {
        monitorRunning := false
        SetTimer CheckMonitoredProcess, 0
        ToolTip

        TrayTip "Process Monitor", "Stopped", 1
    }

    SetTimer () => TrayTip(), -2000
}

CheckMonitoredProcess() {
    global monitoredProcess

    if ProcessExist(monitoredProcess) {
        pid := ProcessExist(monitoredProcess)
        CoordMode "ToolTip", "Screen"
        ToolTip "✓ " monitoredProcess " is running (PID: " pid ")", 10, 50
    } else {
        CoordMode "ToolTip", "Screen"
        ToolTip "✗ " monitoredProcess " is NOT running", 10, 50
    }
}

; === Startup Programs ===

; Ctrl+Alt+S = Add to startup
^!s::AddToStartup()

AddToStartup() {
    scriptPath := A_ScriptFullPath

    result := MsgBox("
    (
    Add this script to Windows startup?

    " scriptPath "
    )", "Startup", "YesNo Icon?")

    if result = "Yes" {
        ; Create shortcut in Startup folder
        startupFolder := A_Startup
        shortcutPath := startupFolder "\" A_ScriptName ".lnk"

        try {
            FileCreateShortcut scriptPath, shortcutPath
            MsgBox "Added to startup folder!`n`n" shortcutPath, "Success", "Icon√"
        } catch as err {
            MsgBox "Failed: " err.Message, "Error", "Iconx"
        }
    }
}

; === System Shutdown Control ===

; Ctrl+Alt+Shift+S = System shutdown menu
^!+s::SystemControl()

SystemControl() {
    choice := MsgBox("
    (
    System Control:

    Yes = Shutdown
    No = Restart
    Cancel = Cancel
    )", "System", "YesNoCancel Icon!")

    if choice = "Yes" {
        Shutdown 1  ; Shutdown
    } else if choice = "No" {
        Shutdown 2  ; Restart
    }
}

; === Help ===
^!h::{
    MsgBox "
    (
    Process Management:
    ==================
    Ctrl+Alt+1: Run application
    Ctrl+Alt+2: Run with parameters
    Ctrl+Alt+3: Run and wait
    Ctrl+Alt+4: Check process
    Ctrl+Alt+5: Process list
    Ctrl+Alt+6: Close process
    Ctrl+Alt+7: Set priority
    Ctrl+Alt+8: Wait for process
    Ctrl+Alt+9: Run as admin
    Ctrl+Alt+0: Run command
    Ctrl+Alt+M: Monitor process
    Ctrl+Alt+S: Add to startup
    Ctrl+Alt+Shift+S: System control

    Esc: Exit
    )", "Help"
}

Esc::{
    SetTimer CheckMonitoredProcess, 0
    ExitApp
}
