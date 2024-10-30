@echo off
setlocal

:: GitHub raw URL for the version file
set "versionUrl=https://raw.githubusercontent.com/DVD404/DAV-Antivirus/main/version.txt"
set "mainFileUrl=https://raw.githubusercontent.com/DVD404/DAV-Antivirus/main/main.bat"

:: File to store the current version
set "currentVersionFile=version.txt"

:: Download the version file
echo Checking for updates...
curl -s -o "%currentVersionFile%" "%versionUrl"

:: Read the latest version
set /p latestVersion=<"%currentVersionFile%"

:: Check if the latest version is different
if not exist "main.bat" (
    echo main.bat not found. Please make sure it exists in the same directory.
    exit /b
)

:: Get the current version from the main.bat file
for /F "tokens=2 delims=." %%a in ('findstr /C:"set currentVersion=" main.bat') do (
    set "currentVersion=0.0.1" 
)

if "%latestVersion%"=="%currentVersion%" (
    echo You are already using the latest version: %latestVersion%.
    exit /b
)

:: If the versions are different, download the latest main.bat
echo New version found: %latestVersion%. Downloading...
curl -s -o "main.bat" "%mainFileUrl%"
echo Update in progress...

:: Verification step
echo Verifying the update...
set "updatedVersionFile=main.bat"
for /F "tokens=2 delims=." %%a in ('findstr /C:"set currentVersion=" "%updatedVersionFile%"') do (
    set "updatedVersion=0.0.1"
)

if "%updatedVersion%"=="%latestVersion%" (
    echo Update successful to version %latestVersion%.
) else (
    echo Update failed. The versions do not match.
)

exit /b
