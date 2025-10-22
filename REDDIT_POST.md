# 📋 REDDIT POST FOR r/vscode

---

## 🎯 POST TITLE (Copy this):

**[Tool] Stop Copy-Pasting Console Errors to AI - Auto-Capture VS Code DevTools Logs for ChatGPT/Claude/Copilot**

---

## 📝 POST BODY (Copy this):

I got tired of copy-pasting console errors to ChatGPT every 5 minutes while debugging, so I built a tool that captures ALL VS Code DevTools Console output to log files.

## 🤖 The Problem

When debugging with AI assistants (ChatGPT, Claude, Copilot), you're constantly:
- Copy-pasting error messages one by one
- Losing context between debugging sessions
- Missing important warnings that came before the error
- Manually piecing together the debugging story for AI

## ✨ The Solution

**Let AI read your entire console log directly!**

This tool captures ALL VS Code DevTools Console output to timestamped files. Now you can tell your AI: *"Here's my complete log - analyze it and find the patterns."*

## 🚀 Quick Demo

**Before:**
```
You: *copies single error*
AI: "Can you show me the warnings before this?"
You: *scrolls back, copies more*
😫 Repeat forever...
```

**After:**
```
You: "Here's my complete console log"
AI: *analyzes everything* "I see the pattern..."
😎 Done in one shot!
```

## ⚡ Quick Start (60 Seconds)

1. Download from GitHub (link below)
2. Run: `$env:ELECTRON_ENABLE_LOGGING = "true"; code .` (Windows) or `export ELECTRON_ENABLE_LOGGING=1 && code .` (Mac/Linux)
3. Press **Ctrl+Shift+B**
4. Check `logs/console_capture.log` - share it with AI!

## ✅ Features

- **Cross-platform** - Windows, macOS, Linux
- **Zero dependencies** - Just PowerShell/Bash (built-in)
- **Real-time monitoring** - Captures as it happens
- **Timestamped logs** - Every line has HH:MM:SS YYYY-MM-DD
- **Color-coded output** - Errors in red, warnings in yellow
- **One keyboard shortcut** - Ctrl+Shift+B to start
- **AI-ready format** - Perfect for ChatGPT, Claude, Copilot

## 🔗 Links

- **📦 GitHub Repository:** https://github.com/ilan4ever/vscode-devtools-logger
- **💬 Discussion & Feedback:** https://github.com/ilan4ever/vscode-devtools-logger/discussions
- **📖 Full Documentation:** https://github.com/ilan4ever/vscode-devtools-logger#readme
- **🐛 Report Issues:** https://github.com/ilan4ever/vscode-devtools-logger/issues

## 💭 Feedback Welcome!

This is my first open-source tool! Would love to hear:
- ✅ Did it work on your setup?
- 🤖 Which AI assistant do you use?
- 💡 Feature ideas?
- 🐛 Found a bug?

**Drop a comment or join the discussion on GitHub!**

---

**Created by [Ilan Aviv](https://github.com/ilan4ever)** | MIT License | ⭐ Star if you find it useful!

---

## 🎯 ALTERNATIVE SHORTER TITLE (if title is too long):

**[Tool] Auto-Capture VS Code Console Logs for AI-Assisted Debugging (ChatGPT/Claude/Copilot)**

or

**[Open Source] VS Code DevTools Logger - Stop Copy-Pasting Errors to AI**

or

**I built a tool to capture VS Code console output for AI debugging - Feedback welcome!**

---

## 📌 POSTING TIPS:

1. **Flair:** Use "Extension" or "Tool" flair if available
2. **Best time:** Tuesday-Thursday, 9-11 AM EST
3. **Monitor:** Reply to comments within first hour for visibility
4. **Be helpful:** Answer questions, accept feedback gracefully
5. **Update:** Edit post with "EDIT: Thanks for feedback!" after 24 hours

---

## 🔥 IF POST GETS REMOVED (Some subs have rules):

Try this version (less promotional):

**Title:** "Looking for feedback: Tool to capture VS Code console for AI debugging"

**Body:** Start with "I've been working on..." instead of "I built..."

---

## 📊 TRACK ENGAGEMENT:

After posting, track:
- Upvotes (aim for 100+ in 24 hours)
- Comments (respond to ALL within 1 hour)
- GitHub stars (should increase 20-50 from good post)
- Discussion participation

Good luck! 🚀
