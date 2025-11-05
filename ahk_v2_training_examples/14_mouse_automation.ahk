/*
 * Script: 14_mouse_automation.ahk
 * Description: Automated mouse movements and clicks
 * Category: Automation - Mouse
 * Version: AHK v2.0+
 *
 * Mouse functions: Click, MouseMove, MouseGetPos, etc.
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Basic Mouse Operations ===

; Ctrl+Alt+1 = Single left click at current position
^!1::{
    Click
    ToolTip "Left Click"
    SetTimer () => ToolTip(), -500
}

; Ctrl+Alt+2 = Right click
^!2::{
    Click "Right"
    ToolTip "Right Click"
    SetTimer () => ToolTip(), -500
}

; Ctrl+Alt+3 = Double click
^!3::{
    Click 2
    ToolTip "Double Click"
    SetTimer () => ToolTip(), -500
}

; Ctrl+Alt+4 = Middle click
^!4::{
    Click "Middle"
    ToolTip "Middle Click"
    SetTimer () => ToolTip(), -500
}

; === Mouse Movement ===

; Ctrl+Alt+M = Move to center of screen
^!m::{
    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2

    MouseMove centerX, centerY
    ToolTip "Mouse moved to center: " centerX ", " centerY
    SetTimer () => ToolTip(), -2000
}

; Ctrl+Alt+C = Move to coordinates
^!c::MoveToCoordinates()

MoveToCoordinates() {
    ib := InputBox("Enter X,Y coordinates (e.g., 500,300)", "Move Mouse")

    if ib.Result = "OK" {
        coords := StrSplit(ib.Value, ",")
        if coords.Length = 2 {
            x := Trim(coords[1])
            y := Trim(coords[2])

            MouseMove x, y
            ToolTip "Moved to: " x ", " y
            SetTimer () => ToolTip(), -2000
        }
    }
}

; Ctrl+Alt+R = Move relative to current position
^!r::{
    MouseGetPos &currentX, &currentY

    ; Move 100 pixels right and 50 down
    MouseMove currentX + 100, currentY + 50

    ToolTip "Moved +100, +50"
    SetTimer () => ToolTip(), -1000
}

; === Click at Specific Coordinates ===

; Ctrl+Alt+P = Click at position
^!p::{
    MsgBox "Will click at position (100, 100) in 2 seconds", , "T2"

    Sleep 2000
    Click 100, 100
}

; === Mouse Dragging ===

; Ctrl+Alt+D = Drag mouse
^!d::DragMouse()

DragMouse() {
    MsgBox "Will drag from (200,200) to (400,400)", , "T2"

    Sleep 2000

    ; Press and hold
    Click 200, 200, "Down"
    Sleep 500

    ; Move while holding
    MouseMove 400, 400, 50  ; 50 = speed

    ; Release
    Click "Up"

    ToolTip "Drag complete"
    SetTimer () => ToolTip(), -1000
}

; === Auto Clicker ===

autoClickerRunning := false

; Ctrl+Alt+A = Toggle auto clicker
^!a::ToggleAutoClicker()

ToggleAutoClicker() {
    global autoClickerRunning := !autoClickerRunning

    if autoClickerRunning {
        SetTimer AutoClick, 1000  ; Click every 1 second
        TrayTip "Auto Clicker", "Started (Ctrl+Alt+A to stop)", 1
    } else {
        SetTimer AutoClick, 0
        TrayTip "Auto Clicker", "Stopped", 1
    }

    SetTimer () => TrayTip(), -2000
}

AutoClick() {
    Click
    CoordMode "ToolTip", "Screen"
    ToolTip "Auto Click", A_ScreenWidth - 100, 50
}

; === Click Pattern ===

; Ctrl+Alt+S = Click in square pattern
^!s::ClickSquare()

ClickSquare() {
    MsgBox "Will click in a square pattern", , "T2"
    Sleep 2000

    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    offset := 100

    ; Top-left
    Click centerX - offset, centerY - offset
    Sleep 300

    ; Top-right
    Click centerX + offset, centerY - offset
    Sleep 300

    ; Bottom-right
    Click centerX + offset, centerY + offset
    Sleep 300

    ; Bottom-left
    Click centerX - offset, centerY + offset
    Sleep 300

    ToolTip "Square pattern complete"
    SetTimer () => ToolTip(), -1000
}

; === Mouse Recorder ===

recordedMoves := []
isRecording := false

; Ctrl+Alt+Shift+R = Start/Stop recording
^!+r::ToggleRecording()

; Ctrl+Alt+Shift+P = Playback recording
^!+p::PlaybackRecording()

ToggleRecording() {
    global isRecording := !isRecording
    global recordedMoves := []

    if isRecording {
        SetTimer RecordMouse, 100
        TrayTip "Mouse Recorder", "Recording... (Ctrl+Alt+Shift+R to stop)", 1
    } else {
        SetTimer RecordMouse, 0
        TrayTip "Mouse Recorder", "Recording stopped. " recordedMoves.Length " positions recorded.", 1
    }

    SetTimer () => TrayTip(), -2000
}

RecordMouse() {
    MouseGetPos &x, &y
    recordedMoves.Push({x: x, y: y})
}

PlaybackRecording() {
    if recordedMoves.Length = 0 {
        MsgBox "No recording found. Press Ctrl+Alt+Shift+R to record."
        return
    }

    MsgBox "Playback in 2 seconds...`n`nRecorded positions: " recordedMoves.Length, , "T2"

    Sleep 2000

    for move in recordedMoves {
        MouseMove move.x, move.y, 2  ; Speed = 2 (faster)
        Sleep 50
    }

    ToolTip "Playback complete"
    SetTimer () => ToolTip(), -2000
}

; === Get Mouse Position ===

; Ctrl+Alt+G = Get current position
^!g::{
    MouseGetPos &x, &y, &winID, &control

    winTitle := WinGetTitle(winID)
    winClass := WinGetClass(winID)

    MsgBox "
    (
    Mouse Position:
    X: " x "
    Y: " y "

    Window:
    Title: " winTitle "
    Class: " winClass "
    Control: " control "
    )", "Mouse Info"
}

; === Click & Hold ===

; Ctrl+Alt+H = Click and hold for 3 seconds
^!h::{
    MsgBox "Will hold left button for 3 seconds", , "T2"

    Sleep 2000

    Click "Down"
    ToolTip "Holding..."

    Sleep 3000

    Click "Up"
    ToolTip "Released"
    SetTimer () => ToolTip(), -1000
}

; === Pixel Search (Simple) ===

; Ctrl+Alt+F = Find and click red pixel
^!f::FindRedPixel()

FindRedPixel() {
    ; Search for red color (0xFF0000)
    if PixelSearch(&foundX, &foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, 0xFF0000, 30) {
        MsgBox "Red pixel found at: " foundX ", " foundY "`n`nClick OK to click it", , "T3"

        MouseMove foundX, foundY
        Click

        ToolTip "Clicked red pixel"
        SetTimer () => ToolTip(), -2000
    } else {
        MsgBox "No red pixel found on screen"
    }
}

; === Mouse Speed Control ===

; Ctrl+Alt+Fast = Fast movement
^!F1::{
    MouseMove 500, 500, 100  ; Speed 100 = instant
    ToolTip "Fast movement"
    SetTimer () => ToolTip(), -500
}

; Ctrl+Alt+Slow = Slow movement
^!F2::{
    MouseMove 500, 500, 10  ; Speed 10 = slow
    ToolTip "Slow movement"
    SetTimer () => ToolTip(), -500
}

; === Coordinate Mode ===

; Ctrl+Alt+I = Show coordinate info
^!i::{
    info := "
    (
    Screen Resolution: " A_ScreenWidth "x" A_ScreenHeight "
    Screen DPI: " A_ScreenDPI "

    Current CoordMode:
    Mouse: " A_CoordModeMouse "
    Pixel: " A_CoordModePixel "
    )"

    MsgBox info, "Coordinate Info"
}

; === Help ===
^!h::{
    MsgBox "
    (
    Mouse Automation:
    ================
    Ctrl+Alt+1: Left click
    Ctrl+Alt+2: Right click
    Ctrl+Alt+3: Double click
    Ctrl+Alt+4: Middle click
    Ctrl+Alt+M: Move to center
    Ctrl+Alt+C: Move to coordinates
    Ctrl+Alt+R: Move relative
    Ctrl+Alt+P: Click at position
    Ctrl+Alt+D: Drag mouse
    Ctrl+Alt+A: Auto clicker
    Ctrl+Alt+S: Square pattern
    Ctrl+Alt+G: Get position
    Ctrl+Alt+H: Click & hold
    Ctrl+Alt+F: Find red pixel
    Ctrl+Alt+Shift+R: Record
    Ctrl+Alt+Shift+P: Playback
    Esc: Exit
    )", "Help"
}

Esc::{
    SetTimer AutoClick, 0
    ExitApp
}
