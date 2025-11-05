/*
 * Script: 18_timers_loops.ahk
 * Description: Timers, loops, and scheduling
 * Category: Advanced - Timing
 * Version: AHK v2.0+
 *
 * SetTimer, Loop variations, Sleep, timing control
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Basic Timers ===

; Ctrl+Alt+1 = Start repeating timer
^!1::StartRepeatingTimer()

timerRunning := false
timerCount := 0

StartRepeatingTimer() {
    global timerRunning, timerCount

    if !timerRunning {
        timerRunning := true
        timerCount := 0

        SetTimer ShowTime, 1000  ; Every 1 second

        TrayTip "Timer Started", "Running every 1 second (Ctrl+Alt+2 to stop)", 1
    } else {
        MsgBox "Timer already running!"
    }

    SetTimer () => TrayTip(), -2000
}

ShowTime() {
    global timerCount
    timerCount++

    CoordMode "ToolTip", "Screen"
    ToolTip "Timer tick: " timerCount "`nTime: " FormatTime(, "HH:mm:ss"), 10, 10
}

; Ctrl+Alt+2 = Stop timer
^!2::{
    global timerRunning

    SetTimer ShowTime, 0  ; Stop timer
    timerRunning := false
    ToolTip  ; Clear tooltip

    TrayTip "Timer Stopped", "Ticks: " timerCount, 1
    SetTimer () => TrayTip(), -2000
}

; === One-Time Delayed Timer ===

; Ctrl+Alt+3 = Delayed action (one-time)
^!3::{
    MsgBox "Action will execute in 3 seconds...", , "T2"

    ; Negative period = run once
    SetTimer DelayedAction, -3000
}

DelayedAction() {
    MsgBox "Delayed action executed!`nTime: " FormatTime(, "HH:mm:ss"), "Delayed Action"
}

; === Loop Variations ===

; Ctrl+Alt+4 = Basic loop
^!4::BasicLoops()

BasicLoops() {
    result := "Loop Examples:`n`n"

    ; Simple loop (10 iterations)
    result .= "Simple loop (1-10):`n"
    Loop 10 {
        result .= A_Index ", "
    }
    result .= "`n`n"

    ; Loop with custom start
    result .= "Loop 5 to 10:`n"
    Loop 6 {
        num := A_Index + 4
        result .= num ", "
    }
    result .= "`n`n"

    ; Loop until condition
    result .= "Loop until > 15:`n"
    counter := 0
    Loop {
        counter++
        result .= counter ", "

        if counter > 15
            break
    }

    MsgBox result, "Loop Examples"
}

; === Loop Files ===

; Ctrl+Alt+5 = File loop
^!5::FileLoop()

FileLoop() {
    ; Create test files
    DirCreate "loop_test"

    FileAppend "Test 1", "loop_test\file1.txt"
    FileAppend "Test 2", "loop_test\file2.txt"
    FileAppend "Test 3", "loop_test\file3.log"

    result := "Files in loop_test:`n`n"

    ; Loop through all files
    Loop Files "loop_test\*.*" {
        result .= A_LoopFileName " - " A_LoopFileSize " bytes`n"
    }

    result .= "`n`nText files only:`n`n"

    ; Loop specific pattern
    Loop Files "loop_test\*.txt" {
        result .= A_LoopFileName "`n"
    }

    MsgBox result, "File Loop"

    ; Cleanup
    FileDelete "loop_test\*.*"
    DirDelete "loop_test"
}

; === Loop Parse (String Splitting) ===

; Ctrl+Alt+6 = Parse loop
^!6::ParseLoop()

ParseLoop() {
    text := "apple,banana,cherry,date,elderberry"

    result := "Parse by comma:`n`n"

    Loop Parse text, "," {
        result .= A_Index ". " A_LoopField "`n"
    }

    result .= "`n`nLine-by-line parsing:`n`n"

    multiline := "
    (
    Line one
    Line two
    Line three
    )"

    Loop Parse multiline, "`n", "`r" {
        if A_LoopField != ""
            result .= A_Index ". " A_LoopField "`n"
    }

    MsgBox result, "Parse Loop"
}

; === Countdown Timer ===

; Ctrl+Alt+7 = Countdown
^!7::StartCountdown()

countdownValue := 0

StartCountdown() {
    global countdownValue

    ib := InputBox("Enter countdown seconds:", "Countdown Timer", , "10")

    if ib.Result = "OK" {
        countdownValue := Integer(ib.Value)

        SetTimer CountdownTick, 1000
        TrayTip "Countdown Started", countdownValue " seconds", 1
    }
}

CountdownTick() {
    global countdownValue

    if countdownValue > 0 {
        CoordMode "ToolTip", "Screen"
        ToolTip "Countdown: " countdownValue, A_ScreenWidth - 150, 50
        countdownValue--
    } else {
        SetTimer , 0  ; Stop this timer
        ToolTip
        MsgBox "Countdown finished!", "Done", "T3"
    }
}

; === Stopwatch ===

; Ctrl+Alt+8 = Start stopwatch
^!8::ToggleStopwatch()

stopwatchRunning := false
stopwatchStart := 0

ToggleStopwatch() {
    global stopwatchRunning, stopwatchStart

    if !stopwatchRunning {
        stopwatchRunning := true
        stopwatchStart := A_TickCount

        SetTimer UpdateStopwatch, 100
        TrayTip "Stopwatch", "Started (Ctrl+Alt+8 to stop)", 1
    } else {
        stopwatchRunning := false
        SetTimer UpdateStopwatch, 0

        elapsed := A_TickCount - stopwatchStart
        MsgBox "Elapsed time: " FormatMilliseconds(elapsed), "Stopwatch Stopped"
        ToolTip
    }

    SetTimer () => TrayTip(), -2000
}

UpdateStopwatch() {
    global stopwatchStart

    elapsed := A_TickCount - stopwatchStart

    CoordMode "ToolTip", "Screen"
    ToolTip "Stopwatch: " FormatMilliseconds(elapsed), A_ScreenWidth - 180, 50
}

FormatMilliseconds(ms) {
    seconds := Floor(ms / 1000)
    minutes := Floor(seconds / 60)
    hours := Floor(minutes / 60)

    ms := Mod(ms, 1000)
    seconds := Mod(seconds, 60)
    minutes := Mod(minutes, 60)

    return Format("{:02d}:{:02d}:{:02d}.{:03d}", hours, minutes, seconds, ms)
}

; === Scheduled Tasks ===

; Ctrl+Alt+9 = Schedule reminder
^!9::ScheduleReminder()

ScheduleReminder() {
    ib := InputBox("Enter reminder message:", "Schedule Reminder")

    if ib.Result = "OK" {
        message := ib.Value

        ib2 := InputBox("Remind in how many seconds?", "Schedule Reminder", , "10")

        if ib2.Result = "OK" {
            delay := Integer(ib2.Value) * 1000

            SetTimer () => MsgBox(message, "Reminder"), -delay

            MsgBox "Reminder scheduled for " ib2.Value " seconds from now"
        }
    }
}

; === Periodic Action ===

; Ctrl+Alt+0 = Auto-save simulation
^!0::ToggleAutoSave()

autoSaveRunning := false

ToggleAutoSave() {
    global autoSaveRunning := !autoSaveRunning

    if autoSaveRunning {
        SetTimer AutoSave, 5000  ; Every 5 seconds
        TrayTip "Auto-Save", "Enabled (every 5 seconds)", 1
    } else {
        SetTimer AutoSave, 0
        TrayTip "Auto-Save", "Disabled", 1
    }

    SetTimer () => TrayTip(), -2000
}

AutoSave() {
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")

    ToolTip "Auto-saved at " timestamp
    SetTimer () => ToolTip(), -2000

    ; Simulate save operation
    FileAppend "[" timestamp "] Auto-save performed`n", "autosave_log.txt"
}

; === Performance Timing ===

; Ctrl+Alt+P = Performance test
^!p::PerformanceTest()

PerformanceTest() {
    result := "Performance Test:`n`n"

    ; Test 1: Loop performance
    startTime := A_TickCount

    Loop 100000 {
        ; Empty loop
    }

    elapsed := A_TickCount - startTime
    result .= "100,000 iterations: " elapsed "ms`n`n"

    ; Test 2: String concatenation
    startTime := A_TickCount

    str := ""
    Loop 1000 {
        str .= "x"
    }

    elapsed := A_TickCount - startTime
    result .= "1,000 string concatenations: " elapsed "ms`n`n"

    ; Test 3: File operations
    startTime := A_TickCount

    FileDelete "perf_test.txt"
    Loop 100 {
        FileAppend "Line " A_Index "`n", "perf_test.txt"
    }

    elapsed := A_TickCount - startTime
    result .= "100 file writes: " elapsed "ms`n`n"

    FileDelete "perf_test.txt"

    MsgBox result, "Performance Results"
}

; === Sleep Variations ===

; Ctrl+Alt+S = Sleep demo
^!s::SleepDemo()

SleepDemo() {
    MsgBox "Will demonstrate different sleep durations", , "T2"

    ; Short sleep
    ToolTip "Sleep 500ms..."
    Sleep 500

    ; Medium sleep
    ToolTip "Sleep 1000ms..."
    Sleep 1000

    ; Long sleep
    ToolTip "Sleep 2000ms..."
    Sleep 2000

    ToolTip
    MsgBox "Sleep demo complete!", , "T2"
}

; === Help ===
^!h::{
    MsgBox "
    (
    Timers & Loops:
    ==============
    Ctrl+Alt+1: Start repeating timer
    Ctrl+Alt+2: Stop timer
    Ctrl+Alt+3: Delayed action
    Ctrl+Alt+4: Loop examples
    Ctrl+Alt+5: File loop
    Ctrl+Alt+6: Parse loop
    Ctrl+Alt+7: Countdown
    Ctrl+Alt+8: Stopwatch
    Ctrl+Alt+9: Schedule reminder
    Ctrl+Alt+0: Auto-save toggle
    Ctrl+Alt+P: Performance test
    Ctrl+Alt+S: Sleep demo

    Esc: Exit
    )", "Help"
}

Esc::{
    ; Stop all timers
    SetTimer ShowTime, 0
    SetTimer CountdownTick, 0
    SetTimer UpdateStopwatch, 0
    SetTimer AutoSave, 0

    ExitApp
}
