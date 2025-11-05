/*
 * Script: 24_system_info.ahk
 * Description: System information and diagnostics
 * Category: System - Information
 * Version: AHK v2.0+
 *
 * Gather comprehensive system information
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Basic System Info ===

; Ctrl+Alt+1 = Show system info
^!1::ShowSystemInfo()

ShowSystemInfo() {
    info := "
    (
    === SYSTEM INFORMATION ===

    Computer Name: " A_ComputerName "
    User Name: " A_UserName "

    OS: " A_OSVersion "
    Is Admin: " (A_IsAdmin ? "Yes" : "No") "
    Is 64-bit: " (A_Is64bitOS ? "Yes" : "No") "

    Language: " A_Language "

    Screen: " A_ScreenWidth "x" A_ScreenHeight "
    DPI: " A_ScreenDPI "

    Working Directory: " A_WorkingDir "
    Temp Directory: " A_Temp "

    AHK Version: " A_AhkVersion "
    AHK Path: " A_AhkPath "
    )"

    MsgBox info, "System Information"
}

; === Time and Date ===

; Ctrl+Alt+2 = Time/date info
^!2::ShowTimeInfo()

ShowTimeInfo() {
    now := A_Now
    year := FormatTime(now, "yyyy")
    month := FormatTime(now, "MMMM")
    day := FormatTime(now, "dddd")

    weekNum := FormatTime(now, "WW")
    dayOfYear := FormatTime(now, "YDay")

    info := "
    (
    === DATE & TIME ===

    Current: " FormatTime(now, "yyyy-MM-dd HH:mm:ss") "

    Year: " year "
    Month: " month "
    Day: " day "

    Week of Year: " weekNum "
    Day of Year: " dayOfYear "

    Timestamp: " now "
    Tick Count: " A_TickCount " ms
    )"

    MsgBox info, "Time Information"
}

; === Directory Info ===

; Ctrl+Alt+3 = Directory paths
^!3::ShowDirectories()

ShowDirectories() {
    info := "
    (
    === IMPORTANT DIRECTORIES ===

    Script:
    " A_ScriptDir "

    Working:
    " A_WorkingDir "

    Windows:
    " A_WinDir "

    System32:
    " A_WinDir "\System32"

    Temp:
    " A_Temp "

    AppData:
    " A_AppData "

    Desktop:
    " A_Desktop "

    Documents:
    " A_MyDocuments "

    Startup:
    " A_Startup "

    Program Files:
    " A_ProgramFiles "
    )"

    MsgBox info, "Directory Paths", "W500"
}

; === Environment Variables ===

; Ctrl+Alt+4 = Environment variables
^!4::ShowEnvironment()

ShowEnvironment() {
    info := "
    (
    === ENVIRONMENT VARIABLES ===

    USERNAME: " EnvGet("USERNAME") "
    COMPUTERNAME: " EnvGet("COMPUTERNAME") "

    USERPROFILE: " EnvGet("USERPROFILE") "
    HOMEDRIVE: " EnvGet("HOMEDRIVE") "
    HOMEPATH: " EnvGet("HOMEPATH") "

    TEMP: " EnvGet("TEMP") "
    TMP: " EnvGet("TMP") "

    OS: " EnvGet("OS") "
    PROCESSOR_IDENTIFIER:
    " EnvGet("PROCESSOR_IDENTIFIER") "

    NUMBER_OF_PROCESSORS: " EnvGet("NUMBER_OF_PROCESSORS") "

    SYSTEMROOT: " EnvGet("SYSTEMROOT") "
    WINDIR: " EnvGet("WINDIR") "
    )"

    MsgBox info, "Environment Variables", "W500"
}

; === Script Information ===

; Ctrl+Alt+5 = Script info
^!5::ShowScriptInfo()

ShowScriptInfo() {
    ; Calculate uptime
    uptime := A_TickCount
    seconds := Floor(uptime / 1000)
    minutes := Floor(seconds / 60)
    hours := Floor(minutes / 60)

    seconds := Mod(seconds, 60)
    minutes := Mod(minutes, 60)

    info := "
    (
    === SCRIPT INFORMATION ===

    Name: " A_ScriptName "
    Full Path: " A_ScriptFullPath "
    Directory: " A_ScriptDir "

    Uptime: " hours "h " minutes "m " seconds "s

    Line Number: " A_LineNumber "
    Line File: " A_LineFile "

    Index: " A_Index "

    Is Compiled: " (A_IsCompiled ? "Yes" : "No") "
    Is Suspended: " (A_IsSuspended ? "Yes" : "No") "
    Is Paused: " (A_IsPaused ? "Yes" : "No") "
    )"

    MsgBox info, "Script Information", "W500"
}

; === Disk Information ===

; Ctrl+Alt+6 = Disk space
^!6::ShowDiskInfo()

ShowDiskInfo() {
    drives := DriveGetList()

    info := "=== DISK INFORMATION ===`n`n"

    for drive in StrSplit(drives) {
        drivePath := drive ":"

        try {
            type := DriveGetType(drivePath)
            label := DriveGetLabel(drivePath)
            filesystem := DriveGetFileSystem(drivePath)

            capacity := DriveGetCapacity(drivePath)
            free := DriveGetSpaceFree(drivePath)
            used := capacity - free

            capacityGB := Round(capacity / 1024, 2)
            freeGB := Round(free / 1024, 2)
            usedGB := Round(used / 1024, 2)
            usedPercent := capacity > 0 ? Round((used / capacity) * 100, 1) : 0

            info .= "Drive " drivePath "\`n"
            info .= "  Label: " (label ? label : "(No label)") "`n"
            info .= "  Type: " type "`n"
            info .= "  FileSystem: " filesystem "`n"
            info .= "  Capacity: " capacityGB " GB`n"
            info .= "  Used: " usedGB " GB (" usedPercent "%)`n"
            info .= "  Free: " freeGB " GB`n`n"
        } catch {
            info .= "Drive " drivePath "\ - Not accessible`n`n"
        }
    }

    ; Show in scrollable GUI
    diskGui := Gui(, "Disk Information")
    diskGui.SetFont("s9", "Consolas")

    edit := diskGui.Add("Edit", "x10 y10 w580 h400 +ReadOnly +Multi", info)

    btnClose := diskGui.Add("Button", "x10 y420 w100", "Close")
    btnClose.OnEvent("Click", (*) => diskGui.Destroy())

    diskGui.Show("w600 h460")
}

; === Network Information ===

; Ctrl+Alt+7 = Network info
^!7::ShowNetworkInfo()

ShowNetworkInfo() {
    ; Run ipconfig and capture output
    shell := ComObject("WScript.Shell")
    exec := shell.Exec(A_ComSpec " /c ipconfig /all")
    output := exec.StdOut.ReadAll()

    ; Show in GUI
    netGui := Gui(, "Network Information")
    netGui.SetFont("s9", "Consolas")

    edit := netGui.Add("Edit", "x10 y10 w780 h500 +ReadOnly +Multi", output)

    btnClose := netGui.Add("Button", "x10 y520 w100", "Close")
    btnClose.OnEvent("Click", (*) => netGui.Destroy())

    netGui.Show("w800 h560")
}

; === CPU Information ===

; Ctrl+Alt+8 = CPU info
^!8::ShowCPUInfo()

ShowCPUInfo() {
    ; Get from environment and WMI
    cpuName := EnvGet("PROCESSOR_IDENTIFIER")
    cpuCount := EnvGet("NUMBER_OF_PROCESSORS")

    info := "
    (
    === CPU INFORMATION ===

    Processor:
    " cpuName "

    Number of Processors: " cpuCount "
    )"

    MsgBox info, "CPU Information", "W500"
}

; === Memory Statistics ===

; Ctrl+Alt+9 = Memory usage
^!9::ShowMemoryStats()

ShowMemoryStats() {
    ; MEMORYSTATUSEX via DllCall
    memStatus := Buffer(64, 0)
    NumPut("UInt", 64, memStatus, 0)

    if DllCall("GlobalMemoryStatusEx", "Ptr", memStatus) {
        memoryLoad := NumGet(memStatus, 4, "UInt")
        totalPhys := NumGet(memStatus, 8, "UInt64")
        availPhys := NumGet(memStatus, 16, "UInt64")
        totalPage := NumGet(memStatus, 24, "UInt64")
        availPage := NumGet(memStatus, 32, "UInt64")
        totalVirtual := NumGet(memStatus, 40, "UInt64")
        availVirtual := NumGet(memStatus, 48, "UInt64")

        info := "
        (
        === MEMORY STATISTICS ===

        Memory Load: " memoryLoad "%

        Physical Memory:
        Total: " Round(totalPhys / 1073741824, 2) " GB
        Used: " Round((totalPhys - availPhys) / 1073741824, 2) " GB
        Available: " Round(availPhys / 1073741824, 2) " GB

        Page File:
        Total: " Round(totalPage / 1073741824, 2) " GB
        Available: " Round(availPage / 1073741824, 2) " GB

        Virtual Memory:
        Total: " Round(totalVirtual / 1073741824, 2) " GB
        Available: " Round(availVirtual / 1073741824, 2) " GB
        )"

        MsgBox info, "Memory Information"
    }
}

; === Full System Report ===

; Ctrl+Alt+0 = Generate full report
^!0::GenerateReport()

GenerateReport() {
    report := "
    (
    =====================================
    SYSTEM DIAGNOSTIC REPORT
    =====================================
    Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "

    --- COMPUTER ---
    Name: " A_ComputerName "
    User: " A_UserName "
    Is Admin: " (A_IsAdmin ? "Yes" : "No") "

    --- OPERATING SYSTEM ---
    OS: " A_OSVersion "
    Architecture: " (A_Is64bitOS ? "64-bit" : "32-bit") "
    Language: " A_Language "

    --- PROCESSOR ---
    " EnvGet("PROCESSOR_IDENTIFIER") "
    Cores: " EnvGet("NUMBER_OF_PROCESSORS") "

    --- DISPLAY ---
    Resolution: " A_ScreenWidth "x" A_ScreenHeight "
    DPI: " A_ScreenDPI "

    --- DIRECTORIES ---
    Windows: " A_WinDir "
    Temp: " A_Temp "
    Desktop: " A_Desktop "
    Documents: " A_MyDocuments "

    --- AUTOHOTKEY ---
    Version: " A_AhkVersion "
    Script: " A_ScriptName "
    Path: " A_ScriptDir "
    )"

    ; Add memory info
    memStatus := Buffer(64, 0)
    NumPut("UInt", 64, memStatus, 0)

    if DllCall("GlobalMemoryStatusEx", "Ptr", memStatus) {
        totalPhys := NumGet(memStatus, 8, "UInt64")
        availPhys := NumGet(memStatus, 16, "UInt64")

        report .= "
        (

        --- MEMORY ---
        Total RAM: " Round(totalPhys / 1073741824, 2) " GB
        Available: " Round(availPhys / 1073741824, 2) " GB
        Used: " Round((totalPhys - availPhys) / 1073741824, 2) " GB
        )"
    }

    ; Add disk info
    report .= "`n`n--- DRIVES ---`n"

    drives := DriveGetList()
    for drive in StrSplit(drives) {
        drivePath := drive ":"

        try {
            capacity := DriveGetCapacity(drivePath)
            free := DriveGetSpaceFree(drivePath)

            report .= drive ": - "
            report .= Round(capacity / 1024, 1) " GB total, "
            report .= Round(free / 1024, 1) " GB free`n"
        }
    }

    report .= "`n=====================================`n"

    ; Save to file
    timestamp := FormatTime(, "yyyy-MM-dd_HH-mm-ss")
    fileName := "system_report_" timestamp ".txt"

    FileDelete fileName
    FileAppend report, fileName

    MsgBox "
    (
    System report generated!

    Saved to:
    " A_ScriptDir "\" fileName "
    )", "Report Complete", "Icon√"

    ; Open report
    Run fileName
}

; === Monitor System Resources ===

; Ctrl+Alt+M = Monitor resources
^!m::ToggleResourceMonitor()

monitorActive := false

ToggleResourceMonitor() {
    global monitorActive := !monitorActive

    if monitorActive {
        SetTimer UpdateResourceMonitor, 2000
        TrayTip "Resource Monitor", "Started (Ctrl+Alt+M to stop)", 1
    } else {
        SetTimer UpdateResourceMonitor, 0
        ToolTip
        TrayTip "Resource Monitor", "Stopped", 1
    }

    SetTimer () => TrayTip(), -2000
}

UpdateResourceMonitor() {
    ; Get memory info
    memStatus := Buffer(64, 0)
    NumPut("UInt", 64, memStatus, 0)

    if DllCall("GlobalMemoryStatusEx", "Ptr", memStatus) {
        memLoad := NumGet(memStatus, 4, "UInt")
        totalPhys := NumGet(memStatus, 8, "UInt64")
        availPhys := NumGet(memStatus, 16, "UInt64")

        usedGB := Round((totalPhys - availPhys) / 1073741824, 2)
        totalGB := Round(totalPhys / 1073741824, 2)

        info := "
        (
        === RESOURCE MONITOR ===
        Time: " FormatTime(, "HH:mm:ss") "

        Memory: " memLoad "%
        " usedGB " / " totalGB " GB
        )"

        CoordMode "ToolTip", "Screen"
        ToolTip info, A_ScreenWidth - 250, 10
    }
}

; === Help ===
^!h::{
    MsgBox "
    (
    System Information:
    ==================
    Ctrl+Alt+1: System info
    Ctrl+Alt+2: Time/date info
    Ctrl+Alt+3: Directory paths
    Ctrl+Alt+4: Environment vars
    Ctrl+Alt+5: Script info
    Ctrl+Alt+6: Disk information
    Ctrl+Alt+7: Network info
    Ctrl+Alt+8: CPU info
    Ctrl+Alt+9: Memory stats
    Ctrl+Alt+0: Full report
    Ctrl+Alt+M: Resource monitor

    Esc: Exit
    )", "Help"
}

Esc::{
    SetTimer UpdateResourceMonitor, 0
    ExitApp
}
