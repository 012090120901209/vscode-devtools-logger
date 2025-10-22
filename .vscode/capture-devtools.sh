#!/bin/bash
# Monitor VS Code DevTools Console Log (macOS/Linux)

# Determine the DevTools log location based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    DEVTOOLS_LOG="$HOME/Library/Logs/Code/vscode-devtools.log"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    DEVTOOLS_LOG="$HOME/.config/Code/logs/vscode-devtools.log"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT_FILE="$SCRIPT_DIR/../logs/console_capture.log"
LOGS_DIR="$SCRIPT_DIR/../logs"

# Create logs directory if it doesn't exist
mkdir -p "$LOGS_DIR"

# Clear previous output
> "$OUTPUT_FILE"

echo -e "\033[0;32mMonitoring DevTools Console...\033[0m"
echo -e "\033[0;37mSource: $DEVTOOLS_LOG\033[0m"
echo -e "\033[0;37mOutput: $OUTPUT_FILE\033[0m"
echo -e "\033[0;33mPress Ctrl+C to stop\033[0m"
echo ""

# Check if DevTools log exists
if [ ! -f "$DEVTOOLS_LOG" ]; then
    echo -e "\033[0;31mERROR: DevTools log not found!\033[0m"
    echo -e "\033[0;31mVS Code must be launched with Electron logging enabled.\033[0m"
    echo ""
    echo -e "\033[0;33mClose VS Code and run this from terminal:\033[0m"
    echo -e "\033[0;37m  export ELECTRON_ENABLE_LOGGING=1\033[0m"
    echo -e "\033[0;37m  code .\033[0m"
    echo ""
    echo -e "\033[0;33mThen reopen VS Code and run this task again.\033[0m"
    sleep 5
    exit 1
fi

# Monitor the log file
LAST_POSITION=0

while true; do
    if [ -f "$DEVTOOLS_LOG" ]; then
        CURRENT_SIZE=$(stat -f%z "$DEVTOOLS_LOG" 2>/dev/null || stat -c%s "$DEVTOOLS_LOG" 2>/dev/null)
        
        if [ "$CURRENT_SIZE" -gt "$LAST_POSITION" ]; then
            # Read only new content
            NEW_CONTENT=$(tail -c +$((LAST_POSITION + 1)) "$DEVTOOLS_LOG")
            
            if [ -n "$NEW_CONTENT" ]; then
                while IFS= read -r line; do
                    if [ -n "$line" ]; then
                        TIMESTAMP=$(date '+%H:%M:%S %Y-%m-%d')
                        OUTPUT="[$TIMESTAMP] [DEVTOOLS] $line"
                        
                        # Color code based on content
                        if echo "$line" | grep -qiE '\[Extension Host\]|@continuedev|error|Error|ERROR'; then
                            echo -e "\033[0;31m$OUTPUT\033[0m"  # Red
                        elif echo "$line" | grep -qiE 'warning|Warning|WARN'; then
                            echo -e "\033[0;33m$OUTPUT\033[0m"  # Yellow
                        else
                            echo "$OUTPUT"
                        fi
                        
                        # Write to file
                        echo "$OUTPUT" >> "$OUTPUT_FILE"
                    fi
                done <<< "$NEW_CONTENT"
            fi
            
            LAST_POSITION=$CURRENT_SIZE
        fi
    fi
    
    sleep 0.5
done
