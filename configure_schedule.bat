@echo off
setlocal EnableDelayedExpansion
title Shutdown Schedule Configuration

echo ==================================================
echo       Shutdown Schedule Configuration Tool
echo ==================================================
echo.
echo This tool will help you configure the auto-shutdown schedule.
echo For each day, enter:
echo   1 - To ENABLE shutdown (True)
echo   2 - To DISABLE shutdown (False)
echo.
echo ==================================================
echo.

REM --- Monday ---
:AskMonday
set "USER_INPUT="
set /p "USER_INPUT=Shutdown on Monday? (1=Yes, 2=No): "
if "%USER_INPUT%"=="1" (
    set "Monday=true"
    echo   - Set Monday to TRUE
) else if "%USER_INPUT%"=="2" (
    set "Monday=false"
    echo   - Set Monday to FALSE
) else (
    echo   [ERROR] Invalid input. Please enter 1 or 2.
    goto AskMonday
)
echo.

REM --- Tuesday ---
:AskTuesday
set "USER_INPUT="
set /p "USER_INPUT=Shutdown on Tuesday? (1=Yes, 2=No): "
if "%USER_INPUT%"=="1" (
    set "Tuesday=true"
    echo   - Set Tuesday to TRUE
) else if "%USER_INPUT%"=="2" (
    set "Tuesday=false"
    echo   - Set Tuesday to FALSE
) else (
    echo   [ERROR] Invalid input. Please enter 1 or 2.
    goto AskTuesday
)
echo.

REM --- Wednesday ---
:AskWednesday
set "USER_INPUT="
set /p "USER_INPUT=Shutdown on Wednesday? (1=Yes, 2=No): "
if "%USER_INPUT%"=="1" (
    set "Wednesday=true"
    echo   - Set Wednesday to TRUE
) else if "%USER_INPUT%"=="2" (
    set "Wednesday=false"
    echo   - Set Wednesday to FALSE
) else (
    echo   [ERROR] Invalid input. Please enter 1 or 2.
    goto AskWednesday
)
echo.

REM --- Thursday ---
:AskThursday
set "USER_INPUT="
set /p "USER_INPUT=Shutdown on Thursday? (1=Yes, 2=No): "
if "%USER_INPUT%"=="1" (
    set "Thursday=true"
    echo   - Set Thursday to TRUE
) else if "%USER_INPUT%"=="2" (
    set "Thursday=false"
    echo   - Set Thursday to FALSE
) else (
    echo   [ERROR] Invalid input. Please enter 1 or 2.
    goto AskThursday
)
echo.

REM --- Friday ---
:AskFriday
set "USER_INPUT="
set /p "USER_INPUT=Shutdown on Friday? (1=Yes, 2=No): "
if "%USER_INPUT%"=="1" (
    set "Friday=true"
    echo   - Set Friday to TRUE
) else if "%USER_INPUT%"=="2" (
    set "Friday=false"
    echo   - Set Friday to FALSE
) else (
    echo   [ERROR] Invalid input. Please enter 1 or 2.
    goto AskFriday
)
echo.

REM --- Saturday ---
:AskSaturday
set "USER_INPUT="
set /p "USER_INPUT=Shutdown on Saturday? (1=Yes, 2=No): "
if "%USER_INPUT%"=="1" (
    set "Saturday=true"
    echo   - Set Saturday to TRUE
) else if "%USER_INPUT%"=="2" (
    set "Saturday=false"
    echo   - Set Saturday to FALSE
) else (
    echo   [ERROR] Invalid input. Please enter 1 or 2.
    goto AskSaturday
)
echo.

REM --- Sunday ---
:AskSunday
set "USER_INPUT="
set /p "USER_INPUT=Shutdown on Sunday? (1=Yes, 2=No): "
if "%USER_INPUT%"=="1" (
    set "Sunday=true"
    echo   - Set Sunday to TRUE
) else if "%USER_INPUT%"=="2" (
    set "Sunday=false"
    echo   - Set Sunday to FALSE
) else (
    echo   [ERROR] Invalid input. Please enter 1 or 2.
    goto AskSunday
)
echo.

echo ==================================================
echo Saving configuration...
echo ==================================================

(
    echo # Shutdown Schedule Configuration
    echo # Set to true to enable shutdown on that day.
    echo # Set to false to disable shutdown on that day.
    echo Monday=!Monday!
    echo Tuesday=!Tuesday!
    echo Wednesday=!Wednesday!
    echo Thursday=!Thursday!
    echo Friday=!Friday!
    echo Saturday=!Saturday!
    echo Sunday=!Sunday!
) > "%~dp0shutdown_schedule.ini"

echo.
echo Configuration saved to: %~dp0shutdown_schedule.ini
echo.
echo Current Settings:
type "%~dp0shutdown_schedule.ini" | findstr /v "#"
echo.
pause
