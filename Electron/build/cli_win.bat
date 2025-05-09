@echo off
:: Check if both arguments are provided
if "%~2"=="" (
    echo Usage: %~nx0 ^<target_wljs_path^> ^<path_to_exe^>
    exit /b 1
)

:: Use argument 1 as target path, argument 2 as executable path
set "targetFile=%~1"
set "exePath=%~2"

:: Create the batch launcher script
(
    echo @echo off
    echo setlocal enabledelayedexpansion
    echo set "APP_PATH=%exePath%"

    echo rem Handle no argument
    echo if "%%~1"=="" ^(
    echo     call "%%APP_PATH%%"
    echo     goto :eof
    echo ^)

    echo rem Handle version flag
    echo if "%%~1"=="-v" ^(
    echo     echo v0.1
    echo     goto :eof
    echo ^)
    echo if "%%~1"=="--version" ^(
    echo     echo v0.1
    echo     goto :eof
    echo ^)

    echo rem Handle current directory call
    echo if "%%~1"=="." ^(
    echo     set "TARGET_PATH=!CD!"
    echo     call "!APP_PATH!" "!TARGET_PATH!"
    echo     goto :eof
    echo ^)

echo :: Handle -c with URL encoding
echo if "%%~1"=="-c" ^(
echo     shift
echo     set CMD_STRING=
echo     :buildcmd
echo     if "%%~1"=="" goto endcmd
echo     set CMD_STRING=!CMD_STRING! "%%~1"
echo     shift
echo     goto buildcmd
echo     :endcmd
echo     rem URL encode the entire command string (preserve spaces)
echo     for /f "delims=" %%E in ^('powershell -nologo -command "[uri]::EscapeDataString('!CMD_STRING!')"^') do set "ENCODED=%%%%E"
echo     echo Encoded command: !ENCODED!
echo     call "!APP_PATH!" "urlenc_!ENCODED!"
echo     goto :eof
echo ^)

    

    echo rem Passthrough
    echo call "%%APP_PATH%%" %%*
) > "%targetFile%"

:: Confirm file creation
if exist "%targetFile%" (
    echo.
    echo ✅ wljs script created at: %targetFile%
    echo --- Script Content ---
    type "%targetFile%"
    echo ----------------------
) else (
    echo ❌ Error: Could not create wljs script at "%targetFile%"
    exit /b 1
)
