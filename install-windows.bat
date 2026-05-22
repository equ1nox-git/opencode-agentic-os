@echo off
REM OpenCode Agentic Education OS - Windows Installer
REM Double-click this file to install

echo ========================================
echo OpenCode Agentic Education OS Installer
echo ========================================
echo.

REM Get the directory where this batch file is located
set "SOURCE_DIR=%~dp0"
set "DEST_DIR=%USERPROFILE%\.config\opencode"

echo Source: %SOURCE_DIR%
echo Destination: %DEST_DIR%
echo.

REM Create destination directory if it doesn't exist
if not exist "%DEST_DIR%" (
    echo Creating config directory...
    mkdir "%DEST_DIR%"
)

REM Copy opencode.json
echo Copying config files...
copy /Y "%SOURCE_DIR%opencode.json" "%DEST_DIR%\opencode.json" >nul
copy /Y "%SOURCE_DIR%rate-limit-fallback.json" "%DEST_DIR%\rate-limit-fallback.json" >nul

REM Create ai directory
echo Copying AI workspace...
if not exist "%DEST_DIR%\ai" mkdir "%DEST_DIR%\ai"
xcopy /E /I /Y "%SOURCE_DIR%ai\*" "%DEST_DIR%\ai\" >nul

REM Create agents directory
echo Copying agent definitions...
if not exist "%DEST_DIR%\agents" mkdir "%DEST_DIR%\agents"
xcopy /E /I /Y "%SOURCE_DIR%agents\*" "%DEST_DIR%\agents\" >nul

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Your machine profile: DESKTOP
echo Strategy: Hybrid (local 7B model + cloud)
echo.
echo Next steps:
echo 1. Install Ollama from https://ollama.com/download/windows
echo 2. Run: ollama pull qwen2.5-coder:7b
echo 3. Open PowerShell and run: opencode
echo.
echo Test commands:
echo   sqrt 196                    - instant
echo   cbrt -125                   - instant
echo   convert 5 miles to km       - instant
echo   explain derivative          - college tutor
echo   python for loop             - coding tutor
echo.
pause