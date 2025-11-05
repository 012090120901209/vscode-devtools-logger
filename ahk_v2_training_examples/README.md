# AutoHotkey v2 Training Examples

A comprehensive collection of 25 AutoHotkey v2 example scripts designed for LLM training and learning.

## 📚 Table of Contents

- [Overview](#overview)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Script Index](#script-index)
  - [Basic Hotkeys & Hotstrings](#basic-hotkeys--hotstrings-1-5)
  - [GUI & Window Manipulation](#gui--window-manipulation-6-10)
  - [Automation & File Operations](#automation--file-operations-11-15)
  - [Advanced Features](#advanced-features-16-20)
  - [System Integration](#system-integration-21-25)
- [Usage Notes](#usage-notes)
- [Learning Path](#learning-path)

---

## Overview

This collection contains 25 well-documented AutoHotkey v2 scripts covering all major features and use cases. Each script is:

- ✅ **Self-contained** - Can be run independently
- ✅ **Well-commented** - Detailed headers and inline documentation
- ✅ **Concise** - Focused on specific topics
- ✅ **Interactive** - Includes hotkeys to trigger demonstrations
- ✅ **Production-ready** - Real-world examples and best practices

**Total Lines of Code:** ~7,000+
**Coverage:** All major AHK v2 features
**Difficulty:** Beginner to Advanced

---

## Requirements

- **AutoHotkey v2.0+** ([Download](https://www.autohotkey.com/))
- **Windows 7 or later**
- **No external dependencies** (all scripts use built-in functions)

---

## Quick Start

1. **Download the examples:**
   ```bash
   git clone <repository-url>
   cd ahk_v2_training_examples
   ```

2. **Run any script:**
   - Double-click any `.ahk` file
   - Or right-click → "Run Script"

3. **View help:**
   - Press `Ctrl+Alt+H` in any running script to see available hotkeys

4. **Exit:**
   - Press `Esc` in any running script

---

## Script Index

### Basic Hotkeys & Hotstrings (1-5)

#### **01_basic_hotkeys.ahk**
**Category:** Hotkeys
**Concepts:** Simple hotkeys, modifier keys, function keys

**Features:**
- Single and multiple modifier combinations
- Function key hotkeys
- Window launching shortcuts
- Script reload functionality

**Example Hotkeys:**
- `Ctrl+J` → Open Notepad
- `Ctrl+Shift+N` → Open Calculator
- `F12` → Reload script

---

#### **02_hotstrings.ahk**
**Category:** Hotstrings
**Concepts:** Text expansion, auto-replace, triggers

**Features:**
- Basic text replacement
- Immediate triggers (asterisk option)
- Dynamic content (date/time insertion)
- Multi-line expansions
- Case-sensitive hotstrings
- Code snippet expansion

**Example Hotstrings:**
- `btw` → "by the way"
- `@@` → "myemail@example.com"
- `ddate` → Current date

---

#### **03_mouse_hotkeys.ahk**
**Category:** Hotkeys - Mouse
**Concepts:** Mouse button hotkeys, scroll wheel, combinations

**Features:**
- Left/right/middle mouse button combinations
- Mouse wheel up/down actions
- Extra mouse buttons (XButton1/2)
- Mouse position detection
- Window information retrieval
- Context-aware mouse actions

**Example Hotkeys:**
- `Ctrl+Right Click` → Show coordinates
- `Middle Button` → Paste
- `Ctrl+Wheel Up/Down` → Volume control

---

#### **04_context_sensitive_hotkeys.ahk**
**Category:** Hotkeys - Context
**Concepts:** Window-specific hotkeys, #HotIf directive

**Features:**
- Application-specific hotkeys
- Window class detection
- Custom condition functions
- Time-based hotkeys
- Negative conditions (NOT active)

**Example Contexts:**
- Notepad-only hotkeys
- Browser-specific shortcuts
- VS Code custom bindings
- Time-aware hotkeys

---

#### **05_remapping_keys.ahk**
**Category:** Hotkeys - Remapping
**Concepts:** Key remapping, custom keyboard layouts

**Features:**
- CapsLock as Ctrl
- Vim-style navigation (hjkl)
- Numpad remapping
- Function key shortcuts
- International character input
- Disable/remap Windows key

**Example Remaps:**
- `CapsLock` → `Ctrl`
- `CapsLock+H/J/K/L` → Arrow keys
- `Insert` → Toggle always-on-top

---

### GUI & Window Manipulation (6-10)

#### **06_simple_gui.ahk**
**Category:** GUI - Basics
**Concepts:** GUI creation, controls, events

**Features:**
- Text and Edit controls
- Buttons and event handlers
- DropDownList (ComboBox)
- CheckBox controls
- Form submission
- Data validation

**Controls Demonstrated:**
- Text labels
- Input fields
- Dropdowns
- Checkboxes
- Buttons

---

#### **07_window_manipulation.ahk**
**Category:** Window Management
**Concepts:** Window positioning, sizing, properties

**Features:**
- Window snapping (left/right)
- Maximize/minimize/restore
- Center window on screen
- Always-on-top toggle
- Transparency control
- Hide/show windows
- Window information display

**Example Hotkeys:**
- `Win+Left/Right` → Snap window
- `Ctrl+Alt+C` → Center window
- `Ctrl+Alt+T` → Always on top toggle

---

#### **08_advanced_gui.ahk**
**Category:** GUI - Advanced
**Concepts:** Tabs, ListView, Progress bars, Sliders

**Features:**
- Tabbed interface
- ListView with columns
- Progress bar animations
- Slider controls
- Add/delete list items
- Settings persistence

**Controls Demonstrated:**
- Tab control
- ListView
- Progress bar
- Slider
- Multiple buttons

---

#### **09_tray_menu.ahk**
**Category:** GUI - Tray
**Concepts:** System tray icon, context menus, notifications

**Features:**
- Custom tray icon
- Custom context menu
- Submenus
- Checkable menu items
- Tray notifications (TrayTip)
- Click event handling

**Menu Features:**
- Custom menu items
- Submenus (Tools)
- Checkboxes
- Default action (double-click)

---

#### **10_tooltip_overlay.ahk**
**Category:** GUI - Overlay
**Concepts:** Tooltips, overlays, on-screen displays

**Features:**
- Simple tooltips
- Multiple tooltips simultaneously
- Custom styled overlays
- System information display
- Progress overlays
- Mouse coordinate tracker
- Non-intrusive notifications

**Example Hotkeys:**
- `Ctrl+Alt+T` → Tooltip at mouse
- `Ctrl+Alt+O` → System info overlay
- `Ctrl+Alt+X` → Toggle coordinate tracker

---

### Automation & File Operations (11-15)

#### **11_file_operations.ahk**
**Category:** File I/O
**Concepts:** File read/write, directory operations

**Features:**
- Create/read/write files
- Append to files
- Line-by-line reading
- Copy/move files
- Delete files and folders
- File information (size, date, attributes)
- Directory enumeration
- Search files

**Operations:**
- FileAppend, FileRead
- FileCopy, FileMove, FileDelete
- DirCreate, DirDelete
- Loop Files
- FileGetSize, FileGetTime

---

#### **12_clipboard_operations.ahk**
**Category:** Clipboard
**Concepts:** Clipboard manipulation, history, transformations

**Features:**
- View clipboard contents
- Clear clipboard
- 10-item clipboard history
- Text transformations (uppercase, lowercase, title case)
- Remove line breaks
- Sort lines
- Save clipboard to file
- Append to log
- Load file to clipboard
- Text formatting (quotes, bullets, numbers)

**Transformations:**
- Case conversion
- Line manipulation
- Sorting
- Formatting

---

#### **13_keyboard_automation.ahk**
**Category:** Automation - Keyboard
**Concepts:** Send, SendText, automated typing

**Features:**
- Automated text typing
- Special key sequences
- Keyboard shortcuts simulation
- Form filling automation
- Realistic typing simulation
- Repeat key presses
- Send to specific windows
- Background window control
- Keyboard state detection
- Lock key toggling
- Input blocking

**Send Methods:**
- SendText (literal text)
- Send (with special keys)
- ControlSend (to specific window)

---

#### **14_mouse_automation.ahk**
**Category:** Automation - Mouse
**Concepts:** Click, MouseMove, dragging, patterns

**Features:**
- Left/right/middle/double clicks
- Mouse movement (absolute/relative)
- Click at coordinates
- Mouse dragging
- Auto-clicker
- Click patterns (square)
- Mouse recorder/playback
- Get mouse position
- Click and hold
- Pixel search
- Speed control

**Advanced:**
- Record mouse movements
- Playback recordings
- Find pixels by color

---

#### **15_web_automation.ahk**
**Category:** Automation - Web
**Concepts:** Browser control, web navigation, scraping

**Features:**
- Open URLs
- Multiple tabs
- COM browser automation
- Web form filling
- URL from clipboard
- Search operations (Google, YouTube)
- Download files
- HTTP requests
- Browser-specific hotkeys
- Copy URL
- Screenshot capture

**Browser Support:**
- Chrome
- Edge
- Internet Explorer (COM)

---

### Advanced Features (16-20)

#### **16_classes_oop.ahk**
**Category:** Advanced - OOP
**Concepts:** Classes, inheritance, methods, properties

**Features:**
- Class definition
- Constructor (__New)
- Methods and properties
- Getters/setters
- Inheritance (extends)
- Method overriding
- Static methods
- Array/Map management classes
- Event/callback systems
- Nested classes

**Classes Demonstrated:**
- Person (basic class)
- Employee (inheritance)
- TaskManager (data management)
- MathUtils (static utility class)
- Counter (with callbacks)
- Database (nested classes)

---

#### **17_error_handling.ahk**
**Category:** Advanced - Error Handling
**Concepts:** Try/catch/finally, custom errors

**Features:**
- Basic try/catch
- File operation error handling
- Finally blocks
- Custom error throwing
- Nested error handling
- Different error types (OSError, ValueError)
- Custom error classes
- Global error handler
- Safe function wrappers
- Input validation

**Error Types:**
- OSError
- ValueError
- MethodError
- Custom errors

---

#### **18_timers_loops.ahk**
**Category:** Advanced - Timing
**Concepts:** SetTimer, loops, scheduling

**Features:**
- Repeating timers
- One-time delayed timers
- Basic loops (Loop N)
- File loops (Loop Files)
- Parse loops (Loop Parse)
- Countdown timer
- Stopwatch
- Scheduled reminders
- Auto-save simulation
- Performance timing

**Loop Types:**
- Simple loops
- File loops
- Parse (string split) loops
- Conditional loops

---

#### **19_regex_parsing.ahk**
**Category:** Advanced - Regex
**Concepts:** Regular expressions, pattern matching

**Features:**
- Basic regex matching
- Capture groups (named)
- Find all matches
- Regex replace
- Email validation
- URL extraction
- Structured data parsing (logs)
- Text cleaning/sanitization
- Password strength checker
- Phone number formatting
- Code block extraction

**Patterns:**
- Email validation
- URL matching
- Phone numbers
- Log parsing
- Markdown code blocks

---

#### **20_ini_json_config.ahk**
**Category:** Advanced - Configuration
**Concepts:** INI files, JSON, config management

**Features:**
- INI file creation
- Read/write INI values
- Update INI values
- Delete sections
- JSON creation (serialization)
- JSON reading
- Custom config formats
- Config parsing
- Settings class wrapper
- Backup/restore configs

**File Formats:**
- INI (IniRead, IniWrite)
- JSON (custom serializer)
- Custom formats (parser)

---

### System Integration (21-25)

#### **21_process_management.ahk**
**Category:** System - Processes
**Concepts:** Running programs, process control

**Features:**
- Launch applications
- Run with parameters
- Run and wait (RunWait)
- Process existence check
- Process list (GUI)
- Close processes
- Set process priority
- Wait for process
- Run as administrator
- Capture command output
- Process monitoring
- Add to startup
- System shutdown/restart

**Functions:**
- Run, RunWait
- ProcessExist, ProcessClose
- ProcessSetPriority
- WinWait

---

#### **22_registry_operations.ahk**
**Category:** System - Registry
**Concepts:** Windows Registry read/write

**Features:**
- Create registry keys
- Read values (string, DWORD)
- Update values
- Delete values/keys
- Windows version info
- User preferences
- Application settings class
- File associations
- Environment variables (via registry)
- Registry browser

**⚠️ Warning:** Registry operations can affect system stability. Use test keys.

**Functions:**
- RegRead, RegWrite
- RegDelete, RegDeleteKey

---

#### **23_dll_calls.ahk**
**Category:** System - DLL/API
**Concepts:** Windows API via DllCall

**Features:**
- MessageBox API
- System beeps
- Low-level clipboard access
- Memory information
- Computer name/username
- Cursor position
- Monitor information
- Flash window
- Play system sounds
- Screen capture
- Keyboard state (API)
- Create directory (API)
- Sleep/hibernate system

**API Examples:**
- User32.dll (MessageBox, GetCursorPos)
- Kernel32.dll (GetComputerName, GlobalMemoryStatusEx)
- Winmm.dll (PlaySound)

---

#### **24_system_info.ahk**
**Category:** System - Information
**Concepts:** System diagnostics, information gathering

**Features:**
- System information
- Time/date info
- Directory paths
- Environment variables
- Script information
- Disk space information
- Network information (ipconfig)
- CPU information
- Memory statistics
- Full system report generation
- Resource monitoring

**Information Gathered:**
- Computer/user name
- OS version
- Hardware info
- Disk usage
- Memory usage
- Network config

---

#### **25_variables_arrays.ahk**
**Category:** Advanced - Data Structures
**Concepts:** Variables, arrays, maps, objects

**Features:**
- Variable types (string, number, boolean)
- Array operations (push, pop, insert, remove)
- Map operations (key-value pairs)
- Nested structures
- Object properties
- String operations (length, substring, case, split)
- Math operations (arithmetic, functions)
- Type conversion
- Reference vs. value semantics
- Variadic functions
- Ternary operator
- Variable scope (global/local)

**Data Types:**
- String
- Integer
- Float
- Array
- Map
- Object

---

## Usage Notes

### Running Scripts

Each script can be run independently:

```bash
# Double-click in Windows Explorer
# Or run from command line:
AutoHotkey.exe 01_basic_hotkeys.ahk
```

### Common Hotkeys

Most scripts use these standard hotkeys:

- **`Ctrl+Alt+H`** - Show help/hotkey list
- **`Esc`** - Exit script
- **`Ctrl+Alt+1-9`** - Trigger demonstrations

### Script Structure

All scripts follow this format:

```autohotkey
/*
 * Script: XX_script_name.ahk
 * Description: Brief description
 * Category: Category name
 * Version: AHK v2.0+
 *
 * Additional notes
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; Hotkey definitions and code...

; Help hotkey (usually Ctrl+Alt+H)
^!h::MsgBox "Help text..."

; Exit hotkey
Esc::ExitApp
```

---

## Learning Path

### Beginner Path

Start with these scripts to learn the basics:

1. **01_basic_hotkeys.ahk** - Hotkey fundamentals
2. **02_hotstrings.ahk** - Text expansion
3. **06_simple_gui.ahk** - Basic GUI creation
4. **11_file_operations.ahk** - File handling
5. **25_variables_arrays.ahk** - Data structures

### Intermediate Path

Build on the basics:

6. **04_context_sensitive_hotkeys.ahk** - Advanced hotkeys
7. **07_window_manipulation.ahk** - Window control
8. **12_clipboard_operations.ahk** - Clipboard manipulation
9. **13_keyboard_automation.ahk** - Automation basics
10. **18_timers_loops.ahk** - Timing and loops

### Advanced Path

Master complex features:

11. **16_classes_oop.ahk** - Object-oriented programming
12. **17_error_handling.ahk** - Error management
13. **19_regex_parsing.ahk** - Pattern matching
14. **21_process_management.ahk** - System interaction
15. **23_dll_calls.ahk** - Windows API

### Expert Path

System-level integration:

16. **22_registry_operations.ahk** - Registry access
17. **24_system_info.ahk** - System diagnostics
18. **08_advanced_gui.ahk** - Complex interfaces
19. **15_web_automation.ahk** - Browser automation
20. **14_mouse_automation.ahk** - Advanced mouse control

---

## Training Your LLM

### Recommended Approach

1. **Sequential Training:**
   - Feed scripts in order (01-25) for structured learning
   - Scripts build on previous concepts

2. **Category-Based Training:**
   - Train on categories (Hotkeys, GUI, Automation, etc.)
   - Good for specialized LLMs

3. **Full Corpus Training:**
   - Use all 25 scripts together
   - Best for general-purpose AHK v2 understanding

### Key Concepts Covered

- ✅ Hotkeys and hotstrings
- ✅ GUI creation and controls
- ✅ Window manipulation
- ✅ File I/O operations
- ✅ Clipboard management
- ✅ Mouse and keyboard automation
- ✅ Web automation
- ✅ Object-oriented programming
- ✅ Error handling
- ✅ Timers and loops
- ✅ Regular expressions
- ✅ Configuration files (INI, JSON)
- ✅ Process management
- ✅ Registry operations
- ✅ DLL calls and Windows API
- ✅ System information
- ✅ Data structures (arrays, maps, objects)

---

## Statistics

| Metric | Count |
|--------|-------|
| Total Scripts | 25 |
| Total Lines of Code | ~7,000+ |
| Categories | 5 |
| Hotkey Examples | 200+ |
| Functions Demonstrated | 150+ |
| GUI Examples | 15+ |
| Automation Examples | 50+ |

---

## File Size Reference

Each script averages 200-400 lines of well-commented code, totaling approximately:

- **Smallest:** ~150 lines
- **Largest:** ~550 lines
- **Average:** ~280 lines
- **Total:** ~7,000 lines

---

## License

These examples are provided for educational purposes. Feel free to use and modify them for your LLM training needs.

---

## Credits

Created for AutoHotkey v2 LLM training. All scripts are compatible with AutoHotkey v2.0 and later.

**AutoHotkey:** https://www.autohotkey.com/

---

## Support

For AutoHotkey v2 documentation and community support:

- **Official Docs:** https://www.autohotkey.com/docs/v2/
- **Forum:** https://www.autohotkey.com/boards/
- **GitHub:** https://github.com/AutoHotkey/AutoHotkey

---

**Happy Learning! 🚀**
