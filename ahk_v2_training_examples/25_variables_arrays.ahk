/*
 * Script: 25_variables_arrays.ahk
 * Description: Variables, arrays, maps, and data structures
 * Category: Advanced - Data Structures
 * Version: AHK v2.0+
 *
 * Variables, Arrays, Maps, Objects
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Basic Variables ===

; Ctrl+Alt+1 = Variable types
^!1::VariableTypes()

VariableTypes() {
    ; String
    str := "Hello World"

    ; Number
    num := 42
    float := 3.14159

    ; Boolean (in AHK: 1 = true, 0 = false)
    isTrue := true
    isFalse := false

    ; Empty/Unset
    empty := ""

    result := "
    (
    Variable Types:

    String: " str " (Type: " Type(str) ")
    Integer: " num " (Type: " Type(num) ")
    Float: " float " (Type: " Type(float) ")
    True: " isTrue " (Type: " Type(isTrue) ")
    False: " isFalse " (Type: " Type(isFalse) ")
    Empty: '" empty "' (Type: " Type(empty) ")
    )"

    MsgBox result, "Variable Types"
}

; === Arrays ===

; Ctrl+Alt+2 = Array operations
^!2::ArrayOperations()

ArrayOperations() {
    ; Create array
    fruits := ["Apple", "Banana", "Cherry", "Date"]

    result := "Array Operations:`n`n"

    ; Access by index (1-based in AHK)
    result .= "First: " fruits[1] "`n"
    result .= "Last: " fruits[fruits.Length] "`n"
    result .= "Length: " fruits.Length "`n`n"

    ; Add elements
    fruits.Push("Elderberry")
    result .= "After Push: Length = " fruits.Length "`n`n"

    ; Remove last element
    removed := fruits.Pop()
    result .= "Popped: " removed "`n"
    result .= "Length: " fruits.Length "`n`n"

    ; Insert at position
    fruits.InsertAt(2, "Blueberry")
    result .= "After InsertAt(2): " fruits[2] "`n`n"

    ; Remove at position
    fruits.RemoveAt(2)
    result .= "After RemoveAt(2)`n`n"

    ; Iterate
    result .= "All items:`n"
    for index, fruit in fruits {
        result .= index ". " fruit "`n"
    }

    MsgBox result, "Array Operations"
}

; === Maps (Key-Value Pairs) ===

; Ctrl+Alt+3 = Map operations
^!3::MapOperations()

MapOperations() {
    ; Create map
    person := Map(
        "name", "John Doe",
        "age", 30,
        "email", "john@example.com",
        "active", true
    )

    result := "Map Operations:`n`n"

    ; Access values
    result .= "Name: " person["name"] "`n"
    result .= "Age: " person["age"] "`n`n"

    ; Check if key exists
    result .= "Has 'email': " (person.Has("email") ? "Yes" : "No") "`n"
    result .= "Has 'phone': " (person.Has("phone") ? "Yes" : "No") "`n`n"

    ; Add new key
    person["phone"] := "555-1234"
    result .= "Added phone: " person["phone"] "`n`n"

    ; Get count
    result .= "Count: " person.Count "`n`n"

    ; Iterate
    result .= "All key-value pairs:`n"
    for key, value in person {
        result .= key ": " value "`n"
    }

    MsgBox result, "Map Operations", "W400"
}

; === Nested Data Structures ===

; Ctrl+Alt+4 = Nested structures
^!4::NestedStructures()

NestedStructures() {
    ; Nested array and map
    users := [
        Map("name", "Alice", "age", 28, "role", "Developer"),
        Map("name", "Bob", "age", 32, "role", "Designer"),
        Map("name", "Charlie", "age", 25, "role", "Manager")
    ]

    result := "Nested Data Structures:`n`n"

    result .= "Users array:`n"
    for index, user in users {
        result .= index ". " user["name"] " (" user["age"] ") - " user["role"] "`n"
    }

    result .= "`n`nComplex structure:`n"

    config := Map(
        "database", Map(
            "host", "localhost",
            "port", 3306,
            "name", "mydb"
        ),
        "features", ["logging", "caching", "notifications"],
        "settings", Map(
            "debug", true,
            "timeout", 30
        )
    )

    result .= "DB Host: " config["database"]["host"] "`n"
    result .= "DB Port: " config["database"]["port"] "`n"
    result .= "Debug: " config["settings"]["debug"] "`n"
    result .= "Features: " StrJoin(config["features"], ", ") "`n"

    MsgBox result, "Nested Structures", "W400"
}

StrJoin(arr, delimiter) {
    result := ""
    for index, item in arr {
        result .= item
        if index < arr.Length
            result .= delimiter
    }
    return result
}

; === Object Properties ===

; Ctrl+Alt+5 = Object properties
^!5::ObjectProperties()

ObjectProperties() {
    ; Create object with properties
    person := {
        name: "John Doe",
        age: 30,
        email: "john@example.com",

        greet: () => "Hello, I'm " this.name
    }

    result := "
    (
    Object Properties:

    Name: " person.name "
    Age: " person.age "
    Email: " person.email "

    Has 'name': " person.HasOwnProp("name") "
    Has 'phone': " person.HasOwnProp("phone") "
    )"

    MsgBox result, "Object Properties"
}

; === String Operations ===

; Ctrl+Alt+6 = String operations
^!6::StringOperations()

StringOperations() {
    str := "Hello, AutoHotkey v2!"

    result := "String Operations:`n`n"

    ; Length
    result .= "Length: " StrLen(str) "`n`n"

    ; Substring
    result .= "SubStr(1, 5): " SubStr(str, 1, 5) "`n"
    result .= "SubStr(8): " SubStr(str, 8) "`n`n"

    ; Case conversion
    result .= "Upper: " StrUpper(str) "`n"
    result .= "Lower: " StrLower(str) "`n"
    result .= "Title: " StrTitle(str) "`n`n"

    ; Replace
    result .= "Replace: " StrReplace(str, "v2", "Version 2") "`n`n"

    ; Split
    parts := StrSplit(str, " ")
    result .= "Split by space:`n"
    for index, part in parts {
        result .= index ". " part "`n"
    }

    ; Trim
    spaced := "   Hello   "
    result .= "`nTrim('" spaced "'): '" Trim(spaced) "'`n"

    MsgBox result, "String Operations", "W400"
}

; === Number Operations ===

; Ctrl+Alt+7 = Math operations
^!7::MathOperations()

MathOperations() {
    a := 10
    b := 3

    result := "
    (
    Math Operations:

    a = " a ", b = " b "

    Addition: " a " + " b " = " (a + b) "
    Subtraction: " a " - " b " = " (a - b) "
    Multiplication: " a " * " b " = " (a * b) "
    Division: " a " / " b " = " (a / b) "
    Floor Division: " a " // " b " = " (a // b) "
    Modulo: " a " mod " b " = " Mod(a, b) "
    Power: " a " ** " b " = " (a ** b) "

    Functions:
    Abs(-42) = " Abs(-42) "
    Ceil(3.2) = " Ceil(3.2) "
    Floor(3.8) = " Floor(3.8) "
    Round(3.14159, 2) = " Round(3.14159, 2) "
    Sqrt(16) = " Sqrt(16) "
    Min(5, 10, 3) = " Min(5, 10, 3) "
    Max(5, 10, 3) = " Max(5, 10, 3) "
    )"

    MsgBox result, "Math Operations"
}

; === Type Conversion ===

; Ctrl+Alt+8 = Type conversion
^!8::TypeConversion()

TypeConversion() {
    result := "Type Conversion:`n`n"

    ; String to number
    strNum := "42"
    num := Integer(strNum)
    result .= "String '" strNum "' → Number " num "`n"

    ; Number to string
    numStr := String(123)
    result .= "Number 123 → String '" numStr "'`n`n"

    ; Float conversion
    floatStr := "3.14159"
    floatNum := Float(floatStr)
    result .= "String '" floatStr "' → Float " floatNum "`n`n"

    ; Format numbers
    result .= "Format:`n"
    result .= "Integer: " Format("{:d}", 42) "`n"
    result .= "Float (2 decimals): " Format("{:.2f}", 3.14159) "`n"
    result .= "Hex: " Format("{:#x}", 255) "`n"
    result .= "Padded: " Format("{:05d}", 42) "`n"

    MsgBox result, "Type Conversion"
}

; === Reference vs Value ===

; Ctrl+Alt+9 = Reference behavior
^!9::ReferenceBehavior()

ReferenceBehavior() {
    ; Arrays and Maps are reference types
    arr1 := [1, 2, 3]
    arr2 := arr1  ; Reference, not copy

    arr2[1] := 999

    result := "Reference vs Value:`n`n"
    result .= "After modifying arr2[1] = 999:`n"
    result .= "arr1[1]: " arr1[1] " (changed!)`n"
    result .= "arr2[1]: " arr2[1] "`n`n"

    ; Clone to create independent copy
    arr3 := [1, 2, 3]
    arr4 := arr3.Clone()

    arr4[1] := 888

    result .= "After cloning and modifying arr4[1] = 888:`n"
    result .= "arr3[1]: " arr3[1] " (unchanged)`n"
    result .= "arr4[1]: " arr4[1] "`n"

    MsgBox result, "Reference Behavior"
}

; === Variadic Functions ===

; Ctrl+Alt+0 = Variadic parameters
^!0::VariadicDemo()

VariadicDemo() {
    ; Function that accepts any number of parameters
    Sum(numbers*) {
        total := 0
        for num in numbers
            total += num
        return total
    }

    Average(numbers*) {
        if numbers.Length = 0
            return 0

        total := 0
        for num in numbers
            total += num

        return total / numbers.Length
    }

    result := "
    (
    Variadic Functions:

    Sum(1, 2, 3) = " Sum(1, 2, 3) "
    Sum(5, 10, 15, 20) = " Sum(5, 10, 15, 20) "

    Average(10, 20, 30) = " Average(10, 20, 30) "
    Average(5, 15, 25, 35, 45) = " Average(5, 15, 25, 35, 45) "
    )"

    MsgBox result, "Variadic Functions"
}

; === Ternary Operator ===

; Ctrl+Alt+T = Ternary examples
^!t::TernaryExamples()

TernaryExamples() {
    age := 25
    score := 85

    result := "Ternary Operator (condition ? true : false):`n`n"

    ; Simple ternary
    status := age >= 18 ? "Adult" : "Minor"
    result .= "Age " age " → " status "`n"

    ; Nested ternary
    grade := score >= 90 ? "A" : score >= 80 ? "B" : score >= 70 ? "C" : "F"
    result .= "Score " score " → Grade " grade "`n`n"

    ; In string
    result .= "You are " (age >= 21 ? "allowed" : "not allowed") " to drink`n"

    MsgBox result, "Ternary Operator"
}

; === Global vs Local ===

; Ctrl+Alt+G = Scope demo
^!g::ScopeDemo()

globalVar := "I'm global"

ScopeDemo() {
    localVar := "I'm local"

    ; Access global
    global globalVar

    TestFunc() {
        global globalVar

        result := "
        (
        Variable Scope:

        Global variable: " globalVar "
        Can't access local from here
        )"

        return result
    }

    result := TestFunc()
    result .= "`n`nLocal variable: " localVar

    MsgBox result, "Variable Scope"
}

; === Help ===
^!h::{
    MsgBox "
    (
    Variables & Data Structures:
    ============================
    Ctrl+Alt+1: Variable types
    Ctrl+Alt+2: Array operations
    Ctrl+Alt+3: Map operations
    Ctrl+Alt+4: Nested structures
    Ctrl+Alt+5: Object properties
    Ctrl+Alt+6: String operations
    Ctrl+Alt+7: Math operations
    Ctrl+Alt+8: Type conversion
    Ctrl+Alt+9: References
    Ctrl+Alt+0: Variadic functions
    Ctrl+Alt+T: Ternary operator
    Ctrl+Alt+G: Variable scope

    Esc: Exit
    )", "Help"
}

Esc::ExitApp
