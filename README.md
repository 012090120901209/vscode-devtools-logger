# VS Code DevTools Logger

A simple, powerful, **cross-platform** tool to capture and log all VS Code Developer Tools Console output to a file. Perfect for debugging VS Code extensions, tracking console messages, and monitoring extension behavior in production environments.

## 🚀 Super Quick Start (For Beginners)

**Just want to get started fast? Follow these 3 simple steps:**

### Step 1: Download the Files
1. Click the green **"Code"** button at the top of this page
2. Select **"Download ZIP"**
3. Extract the ZIP file to your VS Code workspace folder

### Step 2: Launch VS Code Differently
Close VS Code completely, then:

**On Windows:**
- Open PowerShell
- Type: `$env:ELECTRON_ENABLE_LOGGING = "true"; code .`
- Press Enter

**On Mac:**
- Open Terminal
- Type: `export ELECTRON_ENABLE_LOGGING=1 && code .`
- Press Enter

**On Linux:**
- Open Terminal  
- Type: `export ELECTRON_ENABLE_LOGGING=1 && code .`
- Press Enter

### Step 3: Start Logging
- In VS Code, press **`Ctrl+Shift+B`** (or **`Cmd+Shift+B`** on Mac)
- That's it! You'll see console logs appear in the terminal ✨

**Where are my logs saved?** Check the `logs/console_capture.log` file in your workspace folder.

---

## 🎯 What It Does

VS Code extensions log messages to the Developer Tools Console (accessible via `F12` or `Help > Toggle Developer Tools`), but these messages disappear when you close the DevTools or restart VS Code. This tool continuously monitors and saves all console output to a timestamped log file.

### Key Features

- ✅ **Cross-platform** - Works on Windows, macOS, and Linux
- ✅ **Real-time monitoring** - Captures all DevTools Console output as it happens
- ✅ **Timestamped logs** - Each log entry includes precise timestamp (`HH:MM:SS YYYY-MM-DD`)
- ✅ **Color-coded terminal output** - Errors in red, warnings in yellow
- ✅ **Persistent logging** - Saved to file for later analysis
- ✅ **Zero dependencies** - Uses only built-in shell scripts (PowerShell/Bash)
- ✅ **Works with all extensions** - Captures output from any VS Code extension
- ✅ **Integrated VS Code task** - Run with a single keyboard shortcut (`Ctrl+Shift+B`)

## 📋 Prerequisites

### Windows
- **PowerShell** (included with Windows)

### macOS / Linux  
- **Bash** (pre-installed on most systems)

### All Platforms
- **VS Code** (any recent version)

## 🚀 Quick Start

### 1. Copy Files to Your Workspace

Copy these files into your VS Code workspace:

```
your-workspace/
├── .vscode/
│   ├── tasks.json                    # VS Code task configuration (all platforms)
│   ├── capture-devtools.ps1          # PowerShell script (Windows)
│   ├── run-capture.bat               # Batch launcher (Windows)
│   └── capture-devtools.sh           # Bash script (macOS/Linux)
└── logs/                              # Output directory (auto-created)
```

### 2. Launch VS Code with Electron Logging

#### Windows (PowerShell)
```powershell
$env:ELECTRON_ENABLE_LOGGING = "true"
code .
```

#### macOS / Linux (Bash/Zsh)
```bash
export ELECTRON_ENABLE_LOGGING=1
code .
```

**Tip:** Create a launcher script so you don't have to type this every time!

### 3. Make Bash Script Executable (macOS/Linux only)

```bash
chmod +x .vscode/capture-devtools.sh
```

### 4. Start Capturing

**Easiest Way (Recommended):**
- Press **`Ctrl+Shift+B`** (or **`Cmd+Shift+B`** on macOS)
- The logging task will start automatically! ✨

**Alternative Way:**
- Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS)
- Type "Run Task"
- Select:
  - **Windows:** "Capture DevTools Console (Windows)"
  - **macOS/Linux:** "Capture DevTools Console (macOS/Linux)"

### 5. View the Output

- **Live output**: Watch in the VS Code terminal (color-coded)
- **Saved log**: Check `logs/console_capture.log` in your workspace

## 📁 Platform-Specific Details

### Windows

**DevTools Log Location:** `C:\logs\vscode-devtools.log`

**Scripts Used:**
- `.vscode/capture-devtools.ps1` - PowerShell monitoring script
- `.vscode/run-capture.bat` - Batch file launcher

**Task:** "Capture DevTools Console (Windows)"

### macOS

**DevTools Log Location:** `~/Library/Logs/Code/vscode-devtools.log`

**Scripts Used:**
- `.vscode/capture-devtools.sh` - Bash monitoring script

**Task:** "Capture DevTools Console (macOS/Linux)"

### Linux

**DevTools Log Location:** `~/.config/Code/logs/vscode-devtools.log`

**Scripts Used:**
- `.vscode/capture-devtools.sh` - Bash monitoring script

**Task:** "Capture DevTools Console (macOS/Linux)"

## 📊 Example Output

```
[10:00:46 2025-10-22] [DEVTOOLS] [Extension Host] Extension activated: my-extension
[10:00:47 2025-10-22] [DEVTOOLS] [Extension Host] Loading configuration...
[10:00:48 2025-10-22] [DEVTOOLS] ERROR: Failed to load config file
[10:00:49 2025-10-22] [DEVTOOLS] WARN: Using default settings
```

## 🎯 Use Cases

### Extension Development
Monitor your extension's console output during development without keeping DevTools open.

### Debugging Production Issues
Capture console logs from users experiencing issues - just have them run the task and send you the log file.

### Performance Monitoring
Track timing messages, warnings, and errors over extended periods.

### CI/CD Integration
Run as part of automated testing to capture all console output.

## 💡 Tips & Tricks

### Create a Launcher Script

#### Windows (`launch-vscode-logging.ps1`)
```powershell
#!/usr/bin/env pwsh
$env:ELECTRON_ENABLE_LOGGING = "true"
code .
```

#### macOS/Linux (`launch-vscode-logging.sh`)
```bash
#!/bin/bash
export ELECTRON_ENABLE_LOGGING=1
code .
```

Don't forget to make it executable on Unix systems:
```bash
chmod +x launch-vscode-logging.sh
```

### Filter Specific Extensions

Modify the monitoring script to filter for specific patterns.

**Windows (PowerShell) - Edit `.vscode/capture-devtools.ps1`:**
```powershell
if ($line -match 'your-extension-name') {
    # Only log lines matching your extension
    $output = "[$timestamp] [DEVTOOLS] $line"
    Write-Host $output -ForegroundColor Cyan
    Add-Content -Path $outputFile -Value $output
}
```

**macOS/Linux (Bash) - Edit `.vscode/capture-devtools.sh`:**
```bash
if echo "$line" | grep -q 'your-extension-name'; then
    # Only log lines matching your extension
    echo -e "\033[0;36m$OUTPUT\033[0m"  # Cyan
    echo "$OUTPUT" >> "$OUTPUT_FILE"
fi
```

## 🐛 Troubleshooting

### "ERROR: DevTools log not found!"

**Cause**: VS Code wasn't launched with Electron logging enabled.

**Solution**: Close VS Code completely and launch with the appropriate command for your OS (see step 2 above).

### Task not found (macOS/Linux)

**Cause**: Bash script isn't executable.

**Solution**: 
```bash
chmod +x .vscode/capture-devtools.sh
```

### Permission denied (macOS/Linux)

**Cause**: Script doesn't have execute permissions or wrong line endings.

**Solution**:
```bash
chmod +x .vscode/capture-devtools.sh
# Fix line endings if needed
dos2unix .vscode/capture-devtools.sh  # or use sed
```

### Log file is empty

**Cause**: Monitoring started before any console output was generated.

**Solution**: Trigger the action that generates console output (e.g., reload window, activate extension, use extension features).

### Log file grows too large

**Solution**: The script clears the log file each time it starts. You can also manually clear it:

**Windows:**
```powershell
Clear-Content .\logs\console_capture.log
```

**macOS/Linux:**
```bash
> logs/console_capture.log
```

## 🔐 Security Note

The Electron DevTools log may contain sensitive information from all extensions. Be cautious when sharing log files.

## 📝 Customization

### Change Log Location

**Windows** - Edit `capture-devtools.ps1`:
```powershell
$outputFile = Join-Path $PSScriptRoot '..\logs\console_capture.log'
```

**macOS/Linux** - Edit `capture-devtools.sh`:
```bash
OUTPUT_FILE="$SCRIPT_DIR/../logs/console_capture.log"
```

### Change Timestamp Format

**Windows:**
```powershell
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'  # Include milliseconds
```

**macOS/Linux:**
```bash
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S.%3N')  # Include milliseconds
```

### Add Log Rotation

Append timestamp to filename instead of clearing:

**Windows:**
```powershell
$timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm'
$outputFile = Join-Path $PSScriptRoot "..\logs\console_capture_$timestamp.log"
```

**macOS/Linux:**
```bash
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M')
OUTPUT_FILE="$SCRIPT_DIR/../logs/console_capture_$TIMESTAMP.log"
```

## 🏗️ How It Works

1. **Electron Logging**: When you launch VS Code with `ELECTRON_ENABLE_LOGGING=true` (or `=1`), Electron (the framework VS Code is built on) writes all renderer console output to a platform-specific log file

2. **File Monitoring**: The monitoring script continuously watches this log file, reading only new content as it's written

3. **Formatting**: Each line is timestamped and formatted for readability

4. **Dual Output**: Messages are displayed in the VS Code terminal (with colors) and saved to `logs/console_capture.log`

## 🤝 Contributing

Found a bug or have a feature request? Please open an issue or submit a pull request!

### Ideas for Contributions
- Support for other shells (Fish, Zsh-specific features)
- Automatic log rotation
- Log filtering UI
- Remote log shipping
- VS Code extension wrapper

## 📄 License

MIT License - feel free to use in your projects!

## 🌟 Star This Repo

If this tool helped you, please star the repository to help others find it!

---

**Created by developers, for developers** 🚀

*Happy debugging on all platforms!*
