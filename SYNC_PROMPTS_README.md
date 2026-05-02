# Prompt Sync Scripts

Two companion scripts to synchronize Copilot prompts from this folder to your VS Code roaming profile.

## Files

- **`sync-prompts.bat`** — Windows batch script
- **`sync-prompts.sh`** — Bash script for Linux/macOS

## Usage

### Windows

1. Open Command Prompt or PowerShell
2. Navigate to this folder:
   ```cmd
   cd C:\MyProjects\dev-ex-engine
   ```
3. Run the script:
   ```cmd
   sync-prompts.bat
   ```
4. Wait for completion, then reload VS Code

### Linux / macOS

1. Open Terminal
2. Navigate to this folder:
   ```bash
   cd ~/path/to/dev-ex-engine
   ```
3. Make the script executable (first time only):
   ```bash
   chmod +x sync-prompts.sh
   ```
4. Run the script:
   ```bash
   ./sync-prompts.sh
   ```
5. Reload VS Code

## How It Works

Both scripts:
- ✅ **Auto-detect** your user profile (no hardcoded paths)
- ✅ **Find** all `*.prompt.md` files in this directory
- ✅ **Create** the roaming prompts folder if needed
- ✅ **Copy** each prompt file to the correct location
- ✅ **Report** success/failure for each file
- ✅ **Display** the destination path for reference

## Paths Used

**Windows:** `%APPDATA%\Code\User\prompts`

**macOS:** `~/Library/Application Support/Code/User/prompts`

**Linux:** `~/.config/Code/User/prompts`

## After Sync

Reload VS Code to activate the prompts:
- **Windows/Linux:** Ctrl+Shift+P → Developer: Reload Window
- **macOS:** Cmd+Shift+P → Developer: Reload Window

Then type `/` in Copilot Chat to see your prompts.

## Troubleshooting

**Script won't run on Linux/macOS?**
```bash
chmod +x sync-prompts.sh
./sync-prompts.sh
```

**Prompts not showing after sync?**
- Reload VS Code (Dev: Reload Window)
- Check that files were copied: `%APPDATA%\Code\User\prompts` (Windows)
- Restart VS Code completely if needed

**Permission denied on Linux/macOS?**
- Ensure you own the `~/.config/Code/User/prompts` directory
- Or run with `sudo` if necessary (not recommended)

## Automation

**Add to Git:**
```bash
git add sync-prompts.bat sync-prompts.sh
git commit -m "chore: add prompt sync scripts"
```

**Team Workflow:**
1. Team member clones dev-ex-engine
2. Runs `sync-prompts.bat` or `sync-prompts.sh`
3. All team members get the same prompts automatically
4. Updates are pulled via git and re-synced with the script

