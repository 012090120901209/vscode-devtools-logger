# VS Code DevTools Logger

A simple, powerful tool to capture and log all VS Code Developer Tools Console output to a file. Perfect for debugging VS Code extensions, tracking console messages, and monitoring extension behavior in production environments.

## 🎯 What It Does

VS Code extensions log messages to the Developer Tools Console (accessible via `F12` or `Help > Toggle Developer Tools`), but these messages disappear when you close the DevTools or restart VS Code. This tool continuously monitors and saves all console output to a timestamped log file.

### Key Features

- ✅ **Real-time monitoring** - Captures all DevTools Console output as it happens
- ✅ **Timestamped logs** - Each log entry includes precise timestamp (`HH:MM:SS YYYY-MM-DD`)
- ✅ **Color-coded terminal output** - Errors in red, warnings in yellow
- ✅ **Persistent logging** - Saved to file for later analysis
- ✅ **Zero dependencies** - Uses only PowerShell (built into Windows)
- ✅ **Works with all extensions** - Captures output from any VS Code extension
- ✅ **Integrated VS Code task** - Run with a single keyboard shortcut

## 📋 Prerequisites

- **Windows** (uses PowerShell and Electron logging)
- **VS Code** (any recent version)
- **PowerShell** (included with Windows)

## 🚀 Quick Start

### 1. Copy Files to Your Workspace

Copy these files into your VS Code workspace:

```
your-workspace/
├── .vscode/
│   ├── tasks.json              # VS Code task configuration
│   ├── capture-devtools.ps1    # Main monitoring script
│   └── run-capture.bat         # Launcher script
└── logs/                        # Output directory (auto-created)
```

### 2. Launch VS Code with Electron Logging

Close VS Code completely, then launch it from PowerShell with:

```powershell
$env:ELECTRON_ENABLE_LOGGING = "true"
code .
```

Or create a shortcut/launcher script that does this automatically.

### 3. Start Capturing

In VS Code:
- Press `Ctrl+Shift+B` (default build task)
- Or press `Ctrl+Shift+P` → type "Run Task" → select "Capture DevTools Console"

### 4. View the Output

- **Live output**: Watch in the VS Code terminal (color-coded)
- **Saved log**: Check `logs/console_capture.log` in your workspace

## 📁 File Contents

### `.vscode/tasks.json`

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Capture DevTools Console",
      "type": "process",
      "command": "cmd.exe",
      "args": [
        "/c",
        "${workspaceFolder}\\.vscode\\run-capture.bat"
      ],
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "isBackground": true,
      "problemMatcher": [],
      "presentation": {
        "echo": false,
        "reveal": "always",
        "focus": false,
        "panel": "new"
      },
      "options": {
        "cwd": "${workspaceFolder}"
      }
    }
  ]
}
```

### `.vscode/run-capture.bat`

```batch
@echo off
powershell.exe -NoProfile -NoLogo -ExecutionPolicy Bypass -File "%~dp0capture-devtools.ps1"
```

### `.vscode/capture-devtools.ps1`

```powershell
# Monitor VS Code DevTools Console Log
$devToolsLog = 'C:\logs\vscode-devtools.log'
$outputFile = Join-Path $PSScriptRoot '..\logs\console_capture.log'

# Create logs directory if it doesn't exist
$logsDir = Join-Path $PSScriptRoot '..\logs'
if (!(Test-Path $logsDir)) {
    New-Item -ItemType Directory -Path $logsDir | Out-Null
}

# Clear previous output
if (Test-Path $outputFile) {
    Clear-Content $outputFile
}

Write-Host 'Monitoring DevTools Console...' -ForegroundColor Green
Write-Host "Source: $devToolsLog" -ForegroundColor Gray
Write-Host "Output: $outputFile" -ForegroundColor Gray
Write-Host 'Press Ctrl+C to stop' -ForegroundColor Yellow
Write-Host ''

# Check if DevTools log exists
if (!(Test-Path $devToolsLog)) {
    Write-Host 'ERROR: DevTools log not found!' -ForegroundColor Red
    Write-Host 'VS Code must be launched with Electron logging enabled.' -ForegroundColor Red
    Write-Host ''
    Write-Host 'Close VS Code and run this from PowerShell:' -ForegroundColor Yellow
    Write-Host '  $env:ELECTRON_ENABLE_LOGGING = "true"' -ForegroundColor White
    Write-Host '  code .' -ForegroundColor White
    Write-Host ''
    Write-Host 'Then reopen VS Code and run this task again.' -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    exit 1
}

# Monitor the log file
$lastPosition = 0

while ($true) {
    if (Test-Path $devToolsLog) {
        $file = Get-Item $devToolsLog
        $currentSize = $file.Length
        
        if ($currentSize -gt $lastPosition) {
            # Read only new content
            $stream = [System.IO.File]::Open($devToolsLog, 'Open', 'Read', 'ReadWrite')
            $stream.Position = $lastPosition
            $reader = New-Object System.IO.StreamReader($stream)
            $newContent = $reader.ReadToEnd()
            $reader.Close()
            $stream.Close()
            
            if ($newContent) {
                $lines = $newContent -split "`r?`n" | Where-Object { $_.Trim() -ne '' }
                
                foreach ($line in $lines) {
                    $timestamp = Get-Date -Format 'HH:mm:ss yyyy-MM-dd'
                    
                    # Color code based on content
                    if ($line -match '\[Extension Host\]' -or $line -match '@continuedev' -or $line -match 'error|Error|ERROR') {
                        $output = "[$timestamp] [DEVTOOLS] $line"
                        Write-Host $output -ForegroundColor Red
                    }
                    elseif ($line -match 'warning|Warning|WARN') {
                        $output = "[$timestamp] [DEVTOOLS] $line"
                        Write-Host $output -ForegroundColor Yellow
                    }
                    else {
                        $output = "[$timestamp] [DEVTOOLS] $line"
                        Write-Host $output
                    }
                    
                    # Write to file
                    Add-Content -Path $outputFile -Value $output
                }
            }
            
            $lastPosition = $currentSize
        }
    }
    
    Start-Sleep -Milliseconds 500
}
```

## 🔧 How It Works

1. **Electron Logging**: When you launch VS Code with `ELECTRON_ENABLE_LOGGING=true`, Electron (the framework VS Code is built on) writes all renderer console output to `C:\logs\vscode-devtools.log`

2. **File Monitoring**: The PowerShell script continuously monitors this log file, reading only new content as it's written

3. **Formatting**: Each line is timestamped and formatted for readability

4. **Dual Output**: Messages are displayed in the VS Code terminal (with colors) and saved to `logs/console_capture.log`

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

## 💡 Tips

### Make It Easier - Create a Launch Script

Create `launch-vscode-with-logging.ps1` in your workspace:

```powershell
$env:ELECTRON_ENABLE_LOGGING = "true"
code .
```

Then just run this script instead of typing the command each time.

### Auto-start on VS Code Launch

Add this to your workspace's `.vscode/settings.json`:

```json
{
  "tasks.autoRun": "on",
  "tasks.runInTerminal": true
}
```

### Filter Specific Extensions

Modify the PowerShell script to filter for specific patterns:

```powershell
if ($line -match 'your-extension-name') {
    # Only log lines matching your extension
    $output = "[$timestamp] [DEVTOOLS] $line"
    Write-Host $output -ForegroundColor Cyan
    Add-Content -Path $outputFile -Value $output
}
```

## 🐛 Troubleshooting

### "ERROR: DevTools log not found!"

**Cause**: VS Code wasn't launched with Electron logging enabled.

**Solution**: Close VS Code completely and launch with:
```powershell
$env:ELECTRON_ENABLE_LOGGING = "true"
code .
```

### Task shows Conda errors

**Cause**: Conda PowerShell integration interfering with task execution.

**Solution**: The batch file wrapper should bypass this. If issues persist, the task is configured to use `cmd.exe` directly which avoids PowerShell environments.

### Log file is empty

**Cause**: Monitoring started before any console output was generated.

**Solution**: Trigger the action that generates console output (e.g., reload window, activate extension).

### Log file grows too large

**Solution**: The script clears the log file each time it starts. You can also manually clear it:
```powershell
Clear-Content .\logs\console_capture.log
```

## 🔐 Security Note

The Electron DevTools log at `C:\logs\vscode-devtools.log` may contain sensitive information from all extensions. Be cautious when sharing log files.

## 📝 Customization

### Change Log Location

Edit `capture-devtools.ps1` and modify:
```powershell
$outputFile = Join-Path $PSScriptRoot '..\logs\console_capture.log'
```

### Change Timestamp Format

Modify the timestamp line:
```powershell
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'  # Include milliseconds
```

### Add Log Rotation

Append to filename instead of clearing:
```powershell
$timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm'
$outputFile = Join-Path $PSScriptRoot "..\logs\console_capture_$timestamp.log"
```

## 🤝 Contributing

Found a bug or have a feature request? Please open an issue or submit a pull request!

## 📄 License

MIT License - feel free to use in your projects!

## 🌟 Star This Repo

If this tool helped you, please star the repository to help others find it!

---

**Created by developers, for developers** 🚀

*Happy debugging!*
