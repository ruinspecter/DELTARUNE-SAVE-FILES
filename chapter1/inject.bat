@echo off
setlocal enabledelayedexpansion
title Deltarune Save Injector v1.0 Pre-Release
cls

:: ======== Version Info ========
set "CURRENT_VERSION=1.0"
set "VERSION_FILE_URL=https://raw.githubusercontent.com/ruinspecter/MYFILESAVEINJECTORVERSIONSMH/main/version.txt"
set "RELEASES_URL=https://github.com/ruinspecter/DELTARUNE-SAVE-FILES/releases/tag/deltarune"

:: ====== Paths ======
set "SCRIPT_DIR=%~dp0"
set "GAME_DIR=%LOCALAPPDATA%\DELTARUNE"
set "BACKUP_DIR=%SCRIPT_DIR%backup"

:: ====== 1. Chapter Detection ======
for %%A in ("%SCRIPT_DIR%.") do set "FOLDERNAME=%%~nxA"
set "CHAPTER="
for /l %%i in (0,1,9) do (
    echo %FOLDERNAME% | findstr /c:"%%i" >nul && set "CHAPTER=%%i"
)

if "%CHAPTER%"=="" (
    echo [ERROR] No chapter number found in folder name: "%FOLDERNAME%"
    pause
    exit /b
)

:: ====== 2. Version Check ======
echo Checking for updates...
for /f "usebackq delims=" %%v in (`powershell -NoProfile -Command "(New-Object Net.WebClient).DownloadString('%VERSION_FILE_URL%').Trim()"`) do set "LATEST_VERSION=%%v"

if not "%LATEST_VERSION%"=="" if not "%CURRENT_VERSION%"=="%LATEST_VERSION%" (
    cls
    echo ===========================================
    echo WARNING: VERSION OUTDATED!
    echo ===========================================
    choice /c ES /n /m "Press [E] to update or [S] to continue: "
    if errorlevel 2 goto START
    if errorlevel 1 start "" "%RELEASES_URL%" & exit
)

:START
cls
echo.
echo ==== Deltarune Chapter %CHAPTER% Injector ====
echo.

:: Ensure game folder exists
if not exist "%GAME_DIR%" (
    echo [ERROR] DELTARUNE folder not found!
    echo Launch the game at least once first.
    pause
    exit /b
)

:: Ensure backup folder exists
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

:: ====== 3. MOVE OLD FILES (BACKUP) ======
echo Step 1: Moving old saves to backup...
set "OLD_COUNT=0"

for %%F in ("%GAME_DIR%\filech%CHAPTER%*") do (
    if exist "%%F" (
        move /Y "%%F" "%BACKUP_DIR%\" >nul
        set /a OLD_COUNT+=1
        echo [BACKED UP] %%~nxF
    )
)

if !OLD_COUNT! EQU 0 echo [NOTE] No old saves found.

echo.

:: ====== 4. INJECT NEW FILES ======
echo Step 2: Injecting new saves...
set "INJECT_COUNT=0"

for %%F in ("%SCRIPT_DIR%filech%CHAPTER%*") do (
    if exist "%%F" (
        copy /Y "%%F" "%GAME_DIR%\" >nul
        set /a INJECT_COUNT+=1
        echo [INJECTED] %%~nxF
    )
)

if !INJECT_COUNT! EQU 0 echo [WARNING] No injection files found!

echo.
echo ===================================
echo Injection Complete!
echo Old files are in the "backup" folder.
echo ===================================
echo.
pause
