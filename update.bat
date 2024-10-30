@echo off
setlocal

:: Set the URLs for the current and remote files
set "localFile=main.bat"
set "remoteFile=https://raw.githubusercontent.com/DVD404/DAV-Antivirus/main/main.bat"

:: Set the version file URL
set "versionFile=https://raw.githubusercontent.com/DVD404/DAV-Antivirus/main/version.txt"

:: Current version number
set "currentVersion=0.0.1"

:: Get the latest version number from GitHub
for /f %%i in ('curl -s "%versionFile%"') do set "latestVersion=%%i"

:: Compare versions
if "%latestVersion%"=="%currentVersion%" (
    echo You are already using the latest version.
    exit /b
)

:: Download the latest version
echo Downloading latest version...
curl -o "%localFile%" "%remoteFile%"

:: Verify the update
echo Verifying the update...
:: Create a temporary file to store the downloaded content
set "tempFile=temp_main.bat"
curl -o "%tempFile%" "%remoteFile%"

:: Compare the downloaded file with the local file
fc /b "%localFile%" "%tempFile%" >nul
if %errorlevel%==0 (
    echo Update verified successfully!
    del "%tempFile%"
    exit /b
) else (
    echo Update verification failed. Please check the update process.
    del "%tempFile%"
    exit /b
)
