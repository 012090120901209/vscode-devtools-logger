/*
 * Script: 19_regex_parsing.ahk
 * Description: Regular expressions and text parsing
 * Category: Advanced - Regex
 * Version: AHK v2.0+
 *
 * RegExMatch, RegExReplace, text parsing
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Basic RegEx Matching ===

; Ctrl+Alt+1 = Basic regex match
^!1::BasicRegex()

BasicRegex() {
    text := "My email is john.doe@example.com and my phone is 555-1234"

    ; Find email
    if RegExMatch(text, "[\w.]+@[\w.]+", &match) {
        email := match[0]
        result := "Found email: " email "`n`n"
    }

    ; Find phone number
    if RegExMatch(text, "\d{3}-\d{4}", &match) {
        phone := match[0]
        result .= "Found phone: " phone
    }

    MsgBox result, "Basic RegEx"
}

; === Capture Groups ===

; Ctrl+Alt+2 = Capture groups
^!2::CaptureGroups()

CaptureGroups() {
    text := "Name: John Doe, Age: 30, City: New York"

    ; Pattern with named groups
    pattern := "Name: (?P<name>.*?), Age: (?P<age>\d+), City: (?P<city>.*)"

    if RegExMatch(text, pattern, &match) {
        result := "
        (
        Captured Data:

        Full Match: " match[0] "
        Name: " match["name"] "
        Age: " match["age"] "
        City: " match["city"] "
        )"

        MsgBox result, "Capture Groups"
    }
}

; === Find All Matches ===

; Ctrl+Alt+3 = Find all matches
^!3::FindAllMatches()

FindAllMatches() {
    text := "The numbers are 42, 123, 7, and 999 in this sentence."

    result := "Numbers found:`n`n"

    pos := 1
    while pos := RegExMatch(text, "\d+", &match, pos) {
        result .= match[0] "`n"
        pos += StrLen(match[0])
    }

    MsgBox result, "Find All Matches"
}

; === RegEx Replace ===

; Ctrl+Alt+4 = Replace with regex
^!4::RegexReplace()

RegexReplace() {
    text := "Phone numbers: 555-1234, 555-5678, 555-9012"

    ; Replace all phone numbers with ***
    replaced := RegExReplace(text, "\d{3}-\d{4}", "***-****")

    result := "
    (
    Original:
    " text "

    Replaced:
    " replaced "
    )"

    MsgBox result, "RegEx Replace"
}

; === Email Validation ===

; Ctrl+Alt+5 = Validate email
^!5::ValidateEmail()

ValidateEmail() {
    email := InputBox("Enter email address:", "Email Validator").Value

    if email = ""
        return

    ; Email regex pattern
    pattern := "i)^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"

    if RegExMatch(email, pattern) {
        MsgBox "✓ Valid email address!", "Valid", "Icon√"
    } else {
        MsgBox "✗ Invalid email address!", "Invalid", "Iconx"
    }
}

; === URL Extraction ===

; Ctrl+Alt+6 = Extract URLs
^!6::ExtractURLs()

ExtractURLs() {
    text := "
    (
    Check out these sites:
    https://www.google.com
    http://github.com/user/repo
    Visit www.example.com for more info
    Email me at user@domain.com
    )"

    pattern := "https?://[^\s]+"

    result := "URLs found:`n`n"

    pos := 1
    count := 0
    while pos := RegExMatch(text, pattern, &match, pos) {
        count++
        result .= count ". " match[0] "`n"
        pos += StrLen(match[0])
    }

    if count = 0
        result .= "No URLs found"

    MsgBox result, "URL Extraction"
}

; === Data Parsing ===

; Ctrl+Alt+7 = Parse structured data
^!7::ParseData()

ParseData() {
    ; Sample log data
    log := "
    (
    [2024-01-15 10:30:45] ERROR: Connection failed
    [2024-01-15 10:31:02] INFO: Retrying connection
    [2024-01-15 10:31:15] ERROR: Timeout exceeded
    [2024-01-15 10:32:00] SUCCESS: Connected
    )"

    result := "Parsed Log Entries:`n`n"

    ; Pattern: [date time] LEVEL: message
    pattern := "\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\] (\w+): (.*)"

    pos := 1
    while pos := RegExMatch(log, pattern, &match, pos) {
        timestamp := match[1]
        level := match[2]
        message := match[3]

        result .= level " @ " timestamp "`n  " message "`n`n"

        pos += StrLen(match[0])
    }

    MsgBox result, "Data Parsing"
}

; === Clean Text ===

; Ctrl+Alt+8 = Clean/sanitize text
^!8::CleanText()

CleanText() {
    text := "  Hello   World!  Multiple    spaces   here.  "

    result := "Original:`n'" text "'`n`n"

    ; Remove extra spaces
    cleaned := RegExReplace(text, "\s+", " ")

    ; Trim
    cleaned := Trim(cleaned)

    result .= "Cleaned:`n'" cleaned "'`n`n"

    ; Remove special characters
    text2 := "Hello@World#123!Test$"
    alphanumeric := RegExReplace(text2, "[^\w\s]", "")

    result .= "Original: " text2 "`n"
    result .= "Alphanumeric only: " alphanumeric

    MsgBox result, "Clean Text"
}

; === Password Strength ===

; Ctrl+Alt+9 = Check password strength
^!9::CheckPassword()

CheckPassword() {
    password := InputBox("Enter password to check:", "Password Strength", "Password").Value

    if password = ""
        return

    score := 0
    feedback := "Password Analysis:`n`n"

    ; Check length
    if StrLen(password) >= 8 {
        score += 25
        feedback .= "✓ Length >= 8 characters (+25)`n"
    } else {
        feedback .= "✗ Length < 8 characters (0)`n"
    }

    ; Check for lowercase
    if RegExMatch(password, "[a-z]") {
        score += 15
        feedback .= "✓ Contains lowercase (+15)`n"
    } else {
        feedback .= "✗ No lowercase (0)`n"
    }

    ; Check for uppercase
    if RegExMatch(password, "[A-Z]") {
        score += 15
        feedback .= "✓ Contains uppercase (+15)`n"
    } else {
        feedback .= "✗ No uppercase (0)`n"
    }

    ; Check for numbers
    if RegExMatch(password, "\d") {
        score += 20
        feedback .= "✓ Contains numbers (+20)`n"
    } else {
        feedback .= "✗ No numbers (0)`n"
    }

    ; Check for special characters
    if RegExMatch(password, "[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]") {
        score += 25
        feedback .= "✓ Contains special chars (+25)`n"
    } else {
        feedback .= "✗ No special characters (0)`n"
    }

    ; Rating
    feedback .= "`n`nScore: " score "/100`n"

    if score >= 80
        feedback .= "Rating: Strong 💪"
    else if score >= 50
        feedback .= "Rating: Medium ⚠️"
    else
        feedback .= "Rating: Weak ❌"

    MsgBox feedback, "Password Strength"
}

; === Phone Number Formatting ===

; Ctrl+Alt+0 = Format phone number
^!0::FormatPhone()

FormatPhone() {
    phone := InputBox("Enter phone number (digits only):", "Phone Formatter", , "5551234567").Value

    if phone = "" {
        return
    }

    ; Remove non-digits
    digits := RegExReplace(phone, "\D", "")

    result := "Digits: " digits "`n`nFormatted versions:`n`n"

    ; Format as (555) 123-4567
    if StrLen(digits) = 10 {
        formatted1 := "(" SubStr(digits, 1, 3) ") " SubStr(digits, 4, 3) "-" SubStr(digits, 7, 4)
        result .= formatted1 "`n"

        ; Format as 555-123-4567
        formatted2 := SubStr(digits, 1, 3) "-" SubStr(digits, 4, 3) "-" SubStr(digits, 7, 4)
        result .= formatted2 "`n"

        ; Format as +1 (555) 123-4567
        formatted3 := "+1 (" SubStr(digits, 1, 3) ") " SubStr(digits, 4, 3) "-" SubStr(digits, 7, 4)
        result .= formatted3
    } else {
        result .= "Error: Phone number must be 10 digits"
    }

    MsgBox result, "Phone Formatting"
}

; === Extract Code Blocks ===

; Ctrl+Alt+C = Extract code blocks from markdown
^!c::ExtractCode()

ExtractCode() {
    markdown := "
    (
    Here's some text.

    ```javascript
    function hello() {
        console.log("Hello!");
    }
    ```

    More text here.

    ```python
    def greet():
        print("Hello!")
    ```

    End of document.
    )"

    result := "Code blocks found:`n`n"

    ; Pattern for code blocks with language
    pattern := "s)```(\w+)\s*(.*?)```"

    pos := 1
    count := 0
    while pos := RegExMatch(markdown, pattern, &match, pos) {
        count++
        language := match[1]
        code := Trim(match[2])

        result .= "Block " count " (" language "):`n"
        result .= code "`n`n"

        pos += StrLen(match[0])
    }

    MsgBox result, "Code Extraction"
}

; === Help ===
^!h::{
    MsgBox "
    (
    RegEx & Parsing:
    ===============
    Ctrl+Alt+1: Basic regex
    Ctrl+Alt+2: Capture groups
    Ctrl+Alt+3: Find all matches
    Ctrl+Alt+4: RegEx replace
    Ctrl+Alt+5: Email validation
    Ctrl+Alt+6: Extract URLs
    Ctrl+Alt+7: Parse structured data
    Ctrl+Alt+8: Clean text
    Ctrl+Alt+9: Password strength
    Ctrl+Alt+0: Format phone number
    Ctrl+Alt+C: Extract code blocks

    Esc: Exit
    )", "Help"
}

Esc::ExitApp
