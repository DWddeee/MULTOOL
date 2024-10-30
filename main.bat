@echo off
setlocal

:: Discord webhook URL for logging client connection
set "webhookUrl=https://discord.com/api/webhooks/1275128627532664936/Q-TdnNCAkb4Sl-jCdVxTGhg5hlXkheevBSBMDsiMA8Z-TIJG_KF5xV2TTHSSEjykQfYP"
set "messageContent={\"content\": \"A client has connected to the tool.\"}"

:: Send the connection log to Discord
curl -H "Content-Type: application/json" -X POST -d "%messageContent%" "%webhookUrl%" >nul 2>&1

:: Locking mechanism check (if applicable)
set "passwordFile=password.dat"
if exist "%passwordFile%" (
    call :unlock
) else (
    echo No password is set. You can lock the tool from the menu.
)

:: Check for updates before running the main menu
call update.bat

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
echo ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝    ╚═════╝  ╚══════╝ ╚══════╝
echo.
echo -----------------------------------
echo           Main Menu
echo -----------------------------------
echo 1. Lock/Unlock Tool
echo 2. Delete a File
echo 3. Move a File
echo 4. Exit
echo -----------------------------------
set /p choice="Choose an option: "

if "%choice%"=="1" (
    call :lock
) else if "%choice%"=="2" (
    call :delete_file
) else if "%choice%"=="3" (
    call :move_file
) else if "%choice%"=="4" (
    exit
) else (
    echo Invalid choice, please try again.
    timeout /t 2 >nul
    goto main_menu
)

goto main_menu

:: Lock function
:lock
if exist "%passwordFile%" (
    set /p "password=Enter the password to unlock: "
    set /p storedPassword=<%passwordFile%
    if "%password%"=="%storedPassword%" (
        del %passwordFile%
        echo Tool unlocked successfully.
    ) else (
        echo Incorrect password.
    )
) else (
    set /p "newPassword=Enter a new password to lock the tool: "
    echo %newPassword%>%passwordFile%
    echo Tool locked successfully.
)
timeout /t 2 >nul
goto main_menu

:: Delete file function
:delete_file
set /p "fileToDelete=Enter the file path to delete: "
if exist "%fileToDelete%" (
    del "%fileToDelete%"
    echo File deleted successfully.
) else (
    echo File not found.
)
timeout /t 2 >nul
goto main_menu

:: Move file function
:move_file
set /p "sourceFile=Enter the file path to move: "
set /p "destination=Enter the destination path: "
if exist "%sourceFile%" (
    move "%sourceFile%" "%destination%"
    echo File moved successfully.
) else (
    echo Source file not found.
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
