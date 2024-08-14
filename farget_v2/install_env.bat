@echo off
echo Setting up AWS Credential...
setx TF_VAR_aws_access_key ""
setx TF_VAR_aws_secret_key ""
echo.
echo Closing Visual Studio Code...
echo.

:: Use taskkill to terminate the VS Code process
:: Check if the process is running
tasklist /FI "IMAGENAME eq Code.exe" | find /I "Code.exe" >nul
if "%ERRORLEVEL%"=="0" (
    :: Use taskkill to terminate the VS Code process
    taskkill /IM Code.exe /F
    echo.
    echo Visual Studio Code closed.
    echo.
    set PATH=c
    echo "set PATH=c has been executed."
) else (
    echo Visual Studio Code is not running.
)

pause
