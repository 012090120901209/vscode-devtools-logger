/*
 * Script: 17_error_handling.ahk
 * Description: Error handling with try/catch/finally
 * Category: Advanced - Error Handling
 * Version: AHK v2.0+
 *
 * Exception handling, custom errors, validation
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Basic Try/Catch ===

; Ctrl+Alt+1 = Basic error handling
^!1::BasicErrorHandling()

BasicErrorHandling() {
    try {
        ; This will cause an error
        result := 10 / 0  ; Division by zero

        MsgBox "Result: " result
    } catch as err {
        MsgBox "
        (
        An error occurred!

        Message: " err.Message "
        What: " err.What "
        Line: " err.Line "
        )", "Error Caught", "Icon!"
    }
}

; === File Operations with Error Handling ===

; Ctrl+Alt+2 = Safe file read
^!2::SafeFileRead()

SafeFileRead() {
    filePath := "nonexistent_file.txt"

    try {
        content := FileRead(filePath)
        MsgBox "File content: " content
    } catch OSError as err {
        MsgBox "
        (
        Failed to read file!

        File: " filePath "
        Error: " err.Message "
        Error Code: " err.Number "
        )", "File Error", "Icon!"
    } catch as err {
        MsgBox "Unexpected error: " err.Message
    }
}

; === Try/Catch/Finally ===

; Ctrl+Alt+3 = Try with finally
^!3::TryFinally()

TryFinally() {
    logMsg := "Starting operation...`n"

    try {
        logMsg .= "Processing data...`n"

        ; Simulate random error (50% chance)
        if Random(0, 1)
            throw Error("Random error occurred!")

        logMsg .= "Operation completed successfully!`n"
    } catch as err {
        logMsg .= "ERROR: " err.Message "`n"
    } finally {
        ; Always executes, even if error
        logMsg .= "Cleanup completed.`n"
        logMsg .= "End time: " FormatTime(, "HH:mm:ss")
    }

    MsgBox logMsg, "Try/Finally Example"
}

; === Custom Error Throwing ===

; Ctrl+Alt+4 = Throw custom errors
^!4::CustomErrors()

CustomErrors() {
    age := InputBox("Enter your age (must be 18-100):", "Age Validation").Value

    try {
        ValidateAge(age)
        MsgBox "Age " age " is valid!", "Success", "Icon√"
    } catch ValueError as err {
        MsgBox "
        (
        Validation Error!

        " err.Message "

        Extra info: " err.Extra "
        )", "Invalid Input", "Icon!"
    } catch as err {
        MsgBox "Unexpected error: " err.Message, "Error", "Icon!"
    }
}

ValidateAge(age) {
    ; Type check
    if !IsNumber(age)
        throw ValueError("Age must be a number", -1, "Received: " age)

    ; Range check
    ageNum := Integer(age)

    if ageNum < 18
        throw ValueError("Age must be at least 18", -1, "Too young: " ageNum)

    if ageNum > 100
        throw ValueError("Age must be 100 or less", -1, "Too old: " ageNum)

    return true
}

; === Nested Try/Catch ===

; Ctrl+Alt+5 = Nested error handling
^!5::NestedErrorHandling()

NestedErrorHandling() {
    result := ""

    try {
        result .= "Outer try block started`n"

        try {
            result .= "Inner try block started`n"

            ; Throw error from inner block
            throw Error("Inner error!")

            result .= "This won't execute`n"
        } catch as innerErr {
            result .= "Inner catch: " innerErr.Message "`n"

            ; Re-throw to outer catch
            throw Error("Re-thrown from inner catch")
        }
    } catch as outerErr {
        result .= "Outer catch: " outerErr.Message "`n"
    }

    result .= "Execution continued`n"

    MsgBox result, "Nested Try/Catch"
}

; === Error Types ===

; Ctrl+Alt+6 = Different error types
^!6::ErrorTypes()

ErrorTypes() {
    choice := MsgBox("
    (
    Choose error type to test:

    Yes = OSError (file operation)
    No = ValueError (type mismatch)
    Cancel = Generic Error
    )", "Error Types", "YesNoCancel")

    try {
        if choice = "Yes" {
            ; Trigger OSError
            FileRead "Z:\nonexistent\file.txt"
        } else if choice = "No" {
            ; Trigger type error
            obj := {}
            obj.nonexistentMethod()
        } else {
            ; Generic error
            throw Error("This is a generic error")
        }
    } catch OSError as err {
        MsgBox "OSError caught!`n`nCode: " err.Number "`nMessage: " err.Message, "OS Error"
    } catch ValueError as err {
        MsgBox "ValueError caught!`n`nMessage: " err.Message, "Value Error"
    } catch MethodError as err {
        MsgBox "MethodError caught!`n`nMessage: " err.Message, "Method Error"
    } catch as err {
        MsgBox "Generic error caught!`n`nType: " Type(err) "`nMessage: " err.Message, "Error"
    }
}

; === Custom Error Class ===

class DatabaseError extends Error {
    query := ""
    errorCode := 0

    __New(message, query := "", errorCode := 0) {
        super.__New(message)
        this.query := query
        this.errorCode := errorCode
    }

    ToString() {
        return "
        (
        Database Error (Code " this.errorCode "):
        " this.Message "

        Query: " this.query "
        )"
    }
}

; Ctrl+Alt+7 = Custom error class
^!7::TestCustomError()

TestCustomError() {
    try {
        ; Simulate database operation
        ExecuteQuery("SELECT * FROM users WHERE id = 999")
    } catch DatabaseError as err {
        MsgBox err.ToString(), "Database Error", "Icon!"
    }
}

ExecuteQuery(sql) {
    ; Simulate error
    throw DatabaseError("Table 'users' does not exist", sql, 1146)
}

; === Global Error Handler ===

OnError LogError

LogError(thrown, mode) {
    errorLog := "
    (
    ==================== ERROR LOG ====================
    Time: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "
    Message: " thrown.Message "
    File: " thrown.File "
    Line: " thrown.Line "
    What: " thrown.What "
    Extra: " thrown.Extra "
    Stack:
    " thrown.Stack "
    ===================================================
    )"

    ; Log to file
    FileAppend errorLog "`n`n", "error_log.txt"

    ; Show to user
    result := MsgBox("
    (
    An error occurred and has been logged.

    " thrown.Message "

    View error log?
    )", "Error", "YesNo Icon!")

    if result = "Yes" {
        try {
            Run "notepad.exe error_log.txt"
        }
    }

    ; Return -1 to suppress default error dialog
    ; Return 0 to show default dialog
    return -1
}

; === Safe Function Wrapper ===

; Ctrl+Alt+8 = Safe function execution
^!8::SafeExecution()

SafeExecution() {
    ; Execute function safely with error handling
    SafeCall(RiskyFunction, 10, 2)
    SafeCall(RiskyFunction, 10, 0)  ; Will cause error
}

SafeCall(fn, params*) {
    try {
        result := fn(params*)
        MsgBox "Success! Result: " result, "Safe Call", "Icon√"
    } catch as err {
        MsgBox "
        (
        Function execution failed!

        Function: " fn.Name "
        Error: " err.Message "

        Execution continued safely.
        )", "Safe Call - Error", "Iconx"
    }
}

RiskyFunction(a, b) {
    if b = 0
        throw ValueError("Cannot divide by zero!")

    return a / b
}

; === Validation Helper ===

; Ctrl+Alt+9 = Input validation
^!9::ValidateInput()

ValidateInput() {
    email := InputBox("Enter email address:", "Email Validator").Value

    try {
        ValidateEmail(email)
        MsgBox "Email '" email "' is valid!", "Valid", "Icon√"
    } catch as err {
        MsgBox err.Message, "Invalid Email", "Iconx"
    }
}

ValidateEmail(email) {
    if email = ""
        throw ValueError("Email cannot be empty")

    if !InStr(email, "@")
        throw ValueError("Email must contain @ symbol")

    if !RegExMatch(email, "i)^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$")
        throw ValueError("Email format is invalid")

    return true
}

; === Help ===
^!h::{
    MsgBox "
    (
    Error Handling Examples:
    =======================
    Ctrl+Alt+1: Basic try/catch
    Ctrl+Alt+2: File error handling
    Ctrl+Alt+3: Try/finally
    Ctrl+Alt+4: Custom errors
    Ctrl+Alt+5: Nested handling
    Ctrl+Alt+6: Error types
    Ctrl+Alt+7: Custom error class
    Ctrl+Alt+8: Safe execution
    Ctrl+Alt+9: Input validation

    Note: Errors are logged to error_log.txt

    Esc: Exit
    )", "Help"
}

Esc::ExitApp
