@echo off
setlocal

:: File to store the encrypted password
set "passwordFile=password.dat"

:: Check if update.bat exists
if not exist "update.bat" (
    echo Error: update.bat not found. The tool cannot run without it.
    timeout /t 5 >nul
    exit /b
)

:: Check for updates before running the main menu
call :check_updates

:: Main Menu
:main_menu
cls
title multool
echo.
echo ███╗   ███╗██╗   ██╗██╗  ████████╗ ██████╗  ██████╗ ██╗     
echo ████╗ ████║██║   ██║██║  ╚══██╔══╝██╔═══██╗██╔═══██╗██║     
echo ██╔████╔██║██║   ██║██║     ██║   ██║   ██║██║   ██║██║     
echo ██║╚██╔╝██║██║   ██║██║     ██║   ██║   ██║██║   ██║██║     
echo ██║ ╚═╝ ██║╚██████╔╝███████╗██║   ╚██████╔╝╚██████╔╝███████╗
echo ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝    ╚═════╝  ╚═════╝ ╚══════╝
echo.
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
    call update.bat
) else if "%choice%"=="5" (
    exit
) else (
    echo Invalid choice, please try again.
    timeout /t 2 >nul
    goto main_menu
)

goto main_menu

:: Check for updates function
:check_updates
echo Checking for updates...
set "currentVersion=0.0.1"
set "versionUrl=https://raw.githubusercontent.com/DVD404/DAV-Antivirus/main/version.txt"
for /f %%i in ('curl -s "%versionUrl%"') do set "latestVersion=%%i"

if "%currentVersion%"=="%latestVersion%" (
    echo The tool is up to date (Version: %currentVersion%).
    goto main_menu
) else (
    echo A newer version is available (Version: %latestVersion%). Updating...
    call update.bat
    goto main_menu
)

:: Lock/Unlock Tool
:lock
cls
if exist "%passwordFile%" (
    echo Tool is currently locked. Enter the current password to unlock it.
    set /p "inputPassword=Enter Password to Unlock: "
    call :hashPassword "%inputPassword%" inputPasswordHashed
    set /p "storedPasswordHashed="<"%passwordFile%"
    if "%inputPasswordHashed%"=="%storedPasswordHashed%" (
        del "%passwordFile%"
        echo Tool is now unlocked.
    ) else (
        echo Incorrect password. Returning to menu.
    )
    timeout /t 2 >nul
) else (
    echo Tool is currently unlocked. Enter a new password to lock it.
    set /p "newPassword=Set New Password: "
    call :hashPassword "%newPassword%" newPasswordHashed
    echo %newPasswordHashed%>"%passwordFile%"
    echo Tool is now locked with your new password.
    timeout /t 2 >nul
)
goto main_menu

:: Unlock Tool Function
:unlock
cls
echo Tool is locked. Please enter your password to continue.
set /p "unlockPassword=Password: "
call :hashPassword "%unlockPassword%" unlockPasswordHashed
set /p "storedPasswordHashed="<"%passwordFile%"
if not "%unlockPasswordHashed%"=="%storedPasswordHashed%" (
    echo Incorrect password. Exiting tool.
    timeout /t 3 >nul
    exit /b
) else (
    echo Access granted. Welcome!
    timeout /t 2 >nul
)
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

:: Hash Password Function
:hashPassword
:: XOR encryption to simulate hashing (for illustration purposes, not secure)
setlocal EnableDelayedExpansion
set "input=%~1"
set "hashed="
for /L %%i in (0,1,31) do (
    set /A "ch=(!input:~%%i,1! ^ 123) %% 256"
    for /F %%A in ('cmd /C echo(%%ch%%') do set "hashed=!hashed!!hashed:%%A!"
)
endlocal & set "%2=%hashed%"
exit /b
