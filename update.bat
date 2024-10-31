@echo off
title DAV Antivirus - Update Check
setlocal

:: URL of the remote version file and local version setting
set "versionUrl=https://raw.githubusercontent.com/DWddeee/MULTOOL/main/version.txt"
set "localVersionFile=local_version.txt"
set "mainFileUrl=https://raw.githubusercontent.com/DWddeee/MULTOOL/main/main.bat"

:: Load local version or set to 0.0.0 if file doesn't exist
if exist "%localVersionFile%" (
    set /p "localVersion="<"%localVersionFile%"
) else (
    set "localVersion=0.0.0"
    echo 0.0.0 > "%localVersionFile%"
)

:: Fetch latest version from GitHub
echo Checking for updates...
curl -s -o "temp_version.txt" "%versionUrl%"
set /p "githubVersion="<"temp_version.txt"
del "temp_version.txt"

:: Check for connection issues
if "%githubVersion%"=="" (
    echo Failed to connect to GitHub to check for updates.
    echo Please check your internet connection or try again later.
    pause
    exit /b
)

echo Current version: %localVersion%
echo Latest version on GitHub: %githubVersion%

:: Compare versions and update if needed
if "%githubVersion%"=="%localVersion%" (
    echo Your version is up to date. No update needed.
) else (
    echo New version found: %githubVersion%. Updating now...
    curl -s -o "main.bat" "%mainFileUrl%"
    if exist "main.bat" (
        echo Update successful! Running updated version...
        echo %githubVersion% > "%localVersionFile%"
    ) else (
        echo Update failed. Could not download the latest version.
    )
)

:: Pause so the user can see the output
echo.
echo Update check complete. Press any key to close.
pause

