@echo off
setlocal enabledelayedexpansion
title MULTOOL

:: Remote Version Check URL
set "version_url=https://raw.githubusercontent.com/DVD404/DAV-Antivirus/main/version.txt"
set "script_url=https://raw.githubusercontent.com/DVD404/DAV-Antivirus/main/main.bat"
set "local_version=0.0.1"

:: Temporary File to Store Latest Version Code
set "temp_update_file=%temp%\main_update.bat"

:: Check for Internet Connection and Update Version File
:check_update
echo Checking for updates...
:: Download the version file from GitHub
curl -s -o "%temp%\remote_version.txt" %version_url%

if %errorlevel% neq 0 (
    echo Unable to connect to GitHub. The tool will not function without a connection.
    timeout /t 3 >nul
    exit /b
)

set /p "remote_version="<"%temp%\remote_version.txt"

if not "!local_version!"=="!remote_version!" (
    echo Update available! Version: !remote_version!
    set /p choice="Do you want to update? (Y/N): "
    if /i "!choice!"=="Y" (
        echo Downloading new version...
        curl -s -o "%temp_update_file%" %script_url%
        
        if %errorlevel% neq 0 (
            echo Update failed: Could not download the latest version.
            timeout /t 3 >nul
            exit /b
        )

        echo Verifying and applying update...
        > "%~f0" (
            for /f "usebackq delims=" %%a in ("%temp_update_file%") do (
                echo %%a
            )
        )

        echo Update applied successfully to version !remote_version!.
        timeout /t 3 >nul
        goto main_menu
    ) else (
        echo Update skipped. Using local version: !local_version!.
    )
) else (
    echo The tool is up to date.
)
timeout /t 2 >nul

:: Banner
:main_menu
cls
title MULTOOL
echo.
echo [35m███████╗██╗   ██╗████████╗ ██████╗  ██████╗ ██╗     
echo ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔═══██╗██║     
echo ███████║██║   ██║   ██║   ██║   ██║██║   ██║██║     
echo ██╔══██║██║   ██║   ██║   ██║   ██║██║   ██║██║     
echo ██║  ██║╚██████╔╝   ██║   ╚██████╔╝╚██████╔╝███████╗
echo ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝
echo [31mBE CAUTIOUS WITH THIS TOOL, CREATOR IS NOT RESPONSIBLE FOR ANY DAMAGES[0m
echo.

timeout /t 5 >nul

:: Main Menu Options
echo -----------------------------------
echo           Main Menu
echo -----------------------------------
echo 1. Lock/Unlock Tool
echo 2. Delete a File
echo 3. Move a File
echo 4. Update Tool
echo 5. Exit
echo -----------------------------------
set /p choice="Choose an option: "

if "%choice%"=="1" (
    call :lock
) else if "%choice%"=="2" (
    call :delete_file
) else if "%choice%"=="3" (
    call :move_file
) else if "%choice%"=="4" (
    goto check_update
) else if "%choice%"=="5" (
    exit
) else (
    echo Invalid choice, please try again.
    timeout /t 2 >nul
    goto main_menu
)

goto main_menu

:: Lock/Unlock Tool
:lock
cls
echo Lock/Unlock feature is under development.
timeout /t 2 >nul
goto main_menu

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
goto main_menu

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
goto main_menu
