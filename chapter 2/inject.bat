@echo off
echo Copying Chapter 2 save files to DELTARUNE folder...
echo.

set "target=%LOCALAPPDATA%\DELTARUNE"
set "source=%~dp0"

if not exist "%target%" (
    echo DELTARUNE folder not found!
    echo Make sure the game has been launched at least once.
    pause
    exit /b
)

echo Source: %source%
echo Target: %target%
echo.

xcopy "%source%*" "%target%\" /E /I /Y

echo.
echo Copy complete!
pause
