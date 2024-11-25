@echo off
:: Check if two arguments are provided
if "%~2"=="" (
    echo Usage: script_name.bat ignored_argument path_to_exe
    exit /b
)

:: Define the target path in System32 and the executable path
set "targetFile=%SystemRoot%\System32\wljs.bat"
set "exePath=%~2"

:: Create the batch file in System32 with the desired content
(
    echo @echo off
    echo call "%exePath%" %%~dpnx1
) > "%targetFile%"

echo File created at %targetFile% with content:
type "%targetFile%"