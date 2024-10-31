@echo off
setlocal

:: URLs to check and download updates
set "versionURL=https://raw.githubusercontent.com/DWddeee/MULTOOL/main/version.txt"
set "scriptURL=https://raw.githubusercontent.com/DWddeee/MULTOOL/main/main.bat"
:: Local version file to track updates
set "localVersionFile=local_version.txt"

:: Function to get the current local version
if exist "%localVersionFile%" (
    set /p localVersion=<%localVersionFile%
) else (
    set "localVersion=0.0.1"
)

:: Check for updates before running the main menu
call :update_check

:: Display the Main Menu
:main_menu
cls
title MULTOOL
echo.
echo ^[95m███████╗██╗     ██╗████████╗███████╗ ██████╗ ██╗      ██████╗ ██╗
echo ^[95m██╔════╝██║     ██║╚══██╔══╝██╔════╝██╔═══██╗██║     ██╔═══██╗██║
echo ^[95m█████╗  ██║     ██║   ██║   █████╗  ██║   ██║██║     ██║   ██║██║
echo ^[95m██╔══╝  ██║     ██║   ██║   ██╔══╝  ██║   ██║██║     ██║   ██║██║
echo ^[95m███████╗███████╗██║   ██║   ██║     ╚██████╔╝███████╗╚██████╔╝███████╗
echo ^[95m╚══════╝╚══════╝╚═╝   ╚═╝   ╚═╝      ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝
echo.
echo WARNING: BE CAUTIOUS WITH THIS TOOL. THE CREATOR IS NOT RESPONSIBLE FOR ANY DAMAGES.
timeout /t 5 >nul
echo -----------------------------------
echo           Main Menu
echo -----------------------------------
echo 1. Check for Updates
echo 2. Delete a File
echo 3. Move a File
echo 4. Exit
echo -----------------------------------
set /p choice="Choose an option: "

if "%choice%"=="1" (
    call :update_check
    goto main_menu
) else if "%choice%"=="2" (
    call :delete_file
    goto main_menu
) else if "%choice%"=="3" (
    call :move_file
    goto main_menu
) else if "%choice%"=="4" (
    exit
) else (
    echo Invalid choice, please try again.
    timeout /t 2 >nul
    goto main_menu
)

:: Update Check Function
:update_check
echo Checking for updates...
curl -s -o "latest_version.txt" "%versionURL%"
set /p latestVersion=<latest_version.txt

if "%localVersion%"=="%latestVersion%" (
    echo You are up to date with version %localVersion%.
) else (
    echo New version %latestVersion% is available. Updating...
    curl -s -o "%~f0" "%scriptURL%"  :: Updates the main script itself
    echo %latestVersion% > "%localVersionFile%"  :: Update the local version
    echo Update complete. Restarting tool with version %latestVersion%...
    start "" "%~f0"  :: Restart script to load updated version
    exit
)
goto :eof

:: Delete a File
:delete_file
cls
echo -----------------------------------
echo         Delete a File
echo -----------------------------------
set /p filepath="Enter the full path of the file to delete: "
del "%filepath%" >nul 2>&1
if ERRORLEVEL 1 (
    echo Failed to delete the file. Please check the path and try again.
) else (
    echo File deleted successfully.
)
timeout /t 2 >nul
goto :eof

:: Move a File
:move_file
cls
echo -----------------------------------
echo         Move a File
echo -----------------------------------
set /p sourcepath="Enter the full path of the file to move: "
set /p destinationpath="Enter the destination path: "
move "%sourcepath%" "%destinationpath%" >nul 2>&1
if ERRORLEVEL 1 (
    echo Failed to move the file. Please check the paths and try again.
) else (
    echo File moved successfully.
)
timeout /t 2 >nul
goto :eof

:: End of Script
:eof
exit /b
