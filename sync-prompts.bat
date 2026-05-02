@echo off
REM Script to copy Copilot prompts to VS Code roaming profile
REM Works on Windows with dynamic user profile path

setlocal enabledelayedexpansion

REM Get the roaming app data path (dynamic, not hardcoded)
set "ROAMING_PATH=%APPDATA%\Code\User\prompts"

REM Get current script directory
set "SCRIPT_DIR=%~dp0"

REM Verify source directory has prompt files
if not exist "%SCRIPT_DIR%*.prompt.md" (
    echo ❌ Error: No prompt files found in %SCRIPT_DIR%
    echo Please ensure you're running this script from the dev-ex-engine folder.
    exit /b 1
)

REM Create destination folder if it doesn't exist
if not exist "%ROAMING_PATH%" (
    echo 📁 Creating prompts directory: %ROAMING_PATH%
    mkdir "%ROAMING_PATH%"
    if errorlevel 1 (
        echo ❌ Error: Failed to create prompts directory
        exit /b 1
    )
)

REM Copy all prompt files
echo 📋 Copying prompt files to: %ROAMING_PATH%
setlocal enabledelayedexpansion
set "copy_count=0"

for %%F in ("%SCRIPT_DIR%*.prompt.md") do (
    echo   → Copying %%~nxF
    copy "%%F" "%ROAMING_PATH%\%%~nxF" >nul
    if errorlevel 1 (
        echo     ❌ Failed to copy %%~nxF
    ) else (
        set /a copy_count+=1
    )
)

REM Report results
echo.
echo ✅ Success! Copied !copy_count! prompt files.
echo.
echo 📍 Destination: %ROAMING_PATH%
echo.
echo 💡 Reload VS Code to see the prompts:
echo    Ctrl+Shift+P → Developer: Reload Window
echo.
pause
