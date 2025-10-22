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
