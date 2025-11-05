/*
 * Script: 16_classes_oop.ahk
 * Description: Object-Oriented Programming with classes
 * Category: Advanced - OOP
 * Version: AHK v2.0+
 *
 * Classes, methods, properties, inheritance
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; === Basic Class Definition ===

class Person {
    ; Properties
    name := ""
    age := 0
    email := ""

    ; Constructor
    __New(name, age, email := "") {
        this.name := name
        this.age := age
        this.email := email
    }

    ; Method
    Introduce() {
        return "Hi, I'm " this.name " and I'm " this.age " years old."
    }

    ; Method with parameters
    SetEmail(newEmail) {
        this.email := newEmail
    }

    ; Getter/Setter using property
    BirthYear {
        get => A_Year - this.age
    }

    ; Static method (class method)
    static CreateDefault() {
        return Person("Unknown", 0, "no-email@example.com")
    }
}

; Ctrl+Alt+1 = Test basic class
^!1::{
    person1 := Person("John Doe", 30, "john@example.com")
    person2 := Person("Jane Smith", 25)

    msg := "
    (
    Person 1:
    " person1.Introduce() "
    Email: " person1.email "
    Birth Year: " person1.BirthYear "

    Person 2:
    " person2.Introduce() "
    )"

    MsgBox msg, "Class Example"
}

; === Inheritance ===

class Employee extends Person {
    position := ""
    salary := 0

    __New(name, age, email, position, salary) {
        ; Call parent constructor
        super.__New(name, age, email)

        this.position := position
        this.salary := salary
    }

    ; Override parent method
    Introduce() {
        return super.Introduce() " I work as a " this.position "."
    }

    ; New method
    GetDetails() {
        return "
        (
        Name: " this.name "
        Age: " this.age "
        Position: " this.position "
        Salary: $" this.salary "
        Email: " this.email "
        )"
    }
}

; Ctrl+Alt+2 = Test inheritance
^!2::{
    emp := Employee("Alice Johnson", 28, "alice@company.com", "Developer", 75000)

    MsgBox emp.Introduce() "`n`n" emp.GetDetails(), "Inheritance Example"
}

; === Class with Array/Map Management ===

class TaskManager {
    tasks := []

    __New() {
        this.tasks := []
    }

    AddTask(title, priority := "Normal") {
        task := {
            title: title,
            priority: priority,
            completed: false,
            created: FormatTime(, "yyyy-MM-dd HH:mm:ss")
        }

        this.tasks.Push(task)
        return this.tasks.Length
    }

    CompleteTask(index) {
        if index > 0 and index <= this.tasks.Length {
            this.tasks[index].completed := true
            return true
        }
        return false
    }

    GetAllTasks() {
        result := "Tasks:`n`n"

        for index, task in this.tasks {
            status := task.completed ? "[X]" : "[ ]"
            result .= index ". " status " " task.title " (" task.priority ")`n"
        }

        return result
    }

    GetPendingCount() {
        count := 0
        for task in this.tasks {
            if !task.completed
                count++
        }
        return count
    }
}

; Ctrl+Alt+3 = Test task manager
^!3::TestTaskManager()

TestTaskManager() {
    tm := TaskManager()

    tm.AddTask("Write documentation", "High")
    tm.AddTask("Review code", "Normal")
    tm.AddTask("Fix bugs", "High")
    tm.AddTask("Update dependencies", "Low")

    ; Complete some tasks
    tm.CompleteTask(1)
    tm.CompleteTask(3)

    msg := tm.GetAllTasks()
    msg .= "`nPending: " tm.GetPendingCount() " tasks"

    MsgBox msg, "Task Manager"
}

; === Static Class (Utility Class) ===

class MathUtils {
    static PI := 3.14159265359

    static Add(a, b) => a + b

    static Subtract(a, b) => a - b

    static Multiply(a, b) => a * b

    static Divide(a, b) => b != 0 ? a / b : "Error: Division by zero"

    static Average(numbers*) {
        if numbers.Length = 0
            return 0

        sum := 0
        for num in numbers
            sum += num

        return sum / numbers.Length
    }

    static Max(numbers*) {
        if numbers.Length = 0
            return 0

        maxVal := numbers[1]
        for num in numbers {
            if num > maxVal
                maxVal := num
        }

        return maxVal
    }

    static Min(numbers*) {
        if numbers.Length = 0
            return 0

        minVal := numbers[1]
        for num in numbers {
            if num < minVal
                minVal := num
        }

        return minVal
    }

    static CircleArea(radius) {
        return this.PI * radius * radius
    }
}

; Ctrl+Alt+4 = Test static class
^!4::{
    result := "
    (
    Math Utilities:

    Add(5, 3) = " MathUtils.Add(5, 3) "
    Multiply(4, 7) = " MathUtils.Multiply(4, 7) "
    Average(10, 20, 30) = " MathUtils.Average(10, 20, 30) "
    Max(5, 12, 8, 15, 3) = " MathUtils.Max(5, 12, 8, 15, 3) "
    Min(5, 12, 8, 15, 3) = " MathUtils.Min(5, 12, 8, 15, 3) "
    Circle Area (r=5) = " Round(MathUtils.CircleArea(5), 2) "
    )"

    MsgBox result, "Static Class Example"
}

; === Class with Events/Callbacks ===

class Counter {
    value := 0
    onChangeCallback := ""

    __New(initialValue := 0, changeCallback := "") {
        this.value := initialValue
        this.onChangeCallback := changeCallback
    }

    Increment() {
        this.value++
        this._NotifyChange()
    }

    Decrement() {
        this.value--
        this._NotifyChange()
    }

    Reset() {
        this.value := 0
        this._NotifyChange()
    }

    _NotifyChange() {
        if this.onChangeCallback
            this.onChangeCallback.Call(this.value)
    }
}

; Ctrl+Alt+5 = Test counter with callback
^!5::TestCounter()

global counterDisplay := ""

TestCounter() {
    global counterDisplay

    ; Create GUI
    counterGui := Gui("+AlwaysOnTop", "Counter Class Demo")
    counterGui.SetFont("s12")

    counterDisplay := counterGui.Add("Text", "x10 y10 w200 h30 Center", "Count: 0")

    incBtn := counterGui.Add("Button", "x10 y50 w65", "+")
    decBtn := counterGui.Add("Button", "x80 y50 w65", "-")
    resetBtn := counterGui.Add("Button", "x145 y50 w65", "Reset")

    ; Create counter with callback
    counter := Counter(0, UpdateDisplay)

    incBtn.OnEvent("Click", (*) => counter.Increment())
    decBtn.OnEvent("Click", (*) => counter.Decrement())
    resetBtn.OnEvent("Click", (*) => counter.Reset())

    counterGui.Show("w220 h90")

    UpdateDisplay(value) {
        global counterDisplay
        counterDisplay.Value := "Count: " value
    }
}

; === Nested Classes ===

class Database {
    class Connection {
        host := ""
        port := 0
        connected := false

        __New(host, port) {
            this.host := host
            this.port := port
        }

        Connect() {
            this.connected := true
            return "Connected to " this.host ":" this.port
        }

        Disconnect() {
            this.connected := false
            return "Disconnected"
        }
    }

    connection := ""

    __New(host, port) {
        this.connection := Database.Connection(host, port)
    }

    Query(sql) {
        if !this.connection.connected
            return "Error: Not connected"

        return "Executing: " sql
    }
}

; Ctrl+Alt+6 = Test nested class
^!6::{
    db := Database("localhost", 3306)

    msg := db.connection.Connect() "`n`n"
    msg .= db.Query("SELECT * FROM users") "`n`n"
    msg .= db.connection.Disconnect()

    MsgBox msg, "Nested Class Example"
}

; === Help ===
^!h::{
    MsgBox "
    (
    Classes & OOP Examples:
    ======================
    Ctrl+Alt+1: Basic class
    Ctrl+Alt+2: Inheritance
    Ctrl+Alt+3: Task manager
    Ctrl+Alt+4: Static class
    Ctrl+Alt+5: Class with events
    Ctrl+Alt+6: Nested classes

    Esc: Exit
    )", "Help"
}

Esc::ExitApp
