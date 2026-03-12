@echo off
setlocal EnableDelayedExpansion
REM Set console code page to UTF-8
chcp 65001 >nul 2>&1
title Automated Program Launcher

REM ==============================================================================
REM                               Main Program Flow
REM ==============================================================================

echo ========================================
echo        Automated Program Launcher
echo ========================================
echo.
echo [%time%] Script started. Initializing...
echo.

REM ==============================================================================
REM MODULE 1: TIME CHECK & WAIT LOGIC
REM ==============================================================================
echo.
echo ----------------------------------------
echo [Module 1] Time Check & Mode Selection
echo ----------------------------------------
call :CheckTimeMode
if errorlevel 1 (
    echo [ERROR] Time detection failed. Script terminated.
    pause
    exit /b 1
)

REM ==============================================================================
REM MODULE 2: TASK EXECUTION LOGIC
REM ==============================================================================
echo.
echo ----------------------------------------
echo [Module 2] Task Execution Sequence
echo ----------------------------------------

REM --- Task 1 ---
call "%~dp0task_1_mfa.bat"
if errorlevel 1 (
    echo [WARNING] Task 1 reported an error. Continuing to next task...
)
echo.
echo [Wait] Waiting 30 minutes (1800 seconds) before next task...
timeout /t 1800 /nobreak >nul

REM --- Task 2 ---
call "%~dp0task_2_bettergi.bat"
if errorlevel 1 (
    echo [WARNING] Task 2 reported an error. Continuing to next task...
)
echo.
echo [Wait] Waiting 30 minutes (1800 seconds) before next task...
timeout /t 1800 /nobreak >nul

REM --- Task 3 ---
call "%~dp0task_3_march7th.bat"
if errorlevel 1 (
    echo [WARNING] Task 3 reported an error. Continuing to next task...
)
echo.
echo [Wait] Waiting 30 minutes (1800 seconds) before next task...
timeout /t 1800 /nobreak >nul

REM --- Task 4 ---
call "%~dp0task_4_okww.bat"
if errorlevel 1 (
    echo [WARNING] Task 4 reported an error. Continuing to next task...
)
echo.
echo [Wait] Waiting 30 minutes (1800 seconds) before shutdown check...
timeout /t 1800 /nobreak >nul

echo.
echo ========================================
echo           All Tasks Completed
echo ========================================
echo [%time%] Automation process completed.

REM ==============================================================================
REM MODULE 3: SHUTDOWN LOGIC
REM ==============================================================================
echo.
echo ----------------------------------------
echo [Module 3] Shutdown Check
echo ----------------------------------------
call :ShutdownCheck

REM ------------------------------------------------------------------------------
REM End of Script
REM ------------------------------------------------------------------------------
echo.
echo Script execution finished. Window will close in 10 seconds...
timeout /t 10
exit

REM ==============================================================================
REM                            Subroutines Definition Area
REM ==============================================================================

REM ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
REM Subroutine: CheckTimeMode
REM Description: Calls PowerShell to check system time.
REM              - Night Mode (22:00 - 04:00): Calculates seconds until 04:15 AM and waits.
REM              - Day Mode (Other times): Returns immediately without waiting.
REM ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:CheckTimeMode
echo [%time%] Checking system time...

REM Define temporary PowerShell script path
set "PS_SCRIPT=%TEMP%\Launcher_TimeCheck_%RANDOM%.ps1"

REM Generate PowerShell script content
(
    echo $n = Get-Date
    echo $h = $n.Hour
    echo if ^($h -ge 22 -or $h -lt 4^) {
    echo     $t = $n.Date.AddHours^(4^).AddMinutes^(15^)
    echo     if ^($t -lt $n^) { $t = $t.AddDays^(1^) }
    echo     $s = [int]^($t - $n^).TotalSeconds
    echo     Write-Output "NIGHT $s"
    echo } else {
    echo     Write-Output "DAY 0"
    echo }
) > "%PS_SCRIPT%"

set "MODE="
set "WAIT_SECONDS="

REM Execute PowerShell script and capture output (MODE and WAIT_SECONDS)
for /f "usebackq tokens=1,2 delims= " %%a in (`powershell -ExecutionPolicy Bypass -File "%PS_SCRIPT%"`) do (
    set "MODE=%%a"
    set "WAIT_SECONDS=%%b"
)

REM Clean up temporary file
if exist "%PS_SCRIPT%" del "%PS_SCRIPT%"

REM Error handling
if "%MODE%"=="" (
    echo [ERROR] Failed to detect time mode. PowerShell execution may have failed.
    echo Please check if PowerShell is available and working.
    exit /b 1
)

echo [%time%] Time Detection Result: Mode=!MODE!

REM Execute logic based on mode
if "!MODE!"=="NIGHT" (
    echo.
    echo ========================================
    echo          NIGHT MODE ACTIVATED
    echo ========================================
    echo Current time is within 22:00 - 04:00.
    echo Status: Waiting until 04:15 AM to start tasks.
    echo Wait duration: !WAIT_SECONDS! seconds.
    echo.
    echo [%time%] Waiting...
    
    REM Use PowerShell for precise sleep
    powershell -Command "Start-Sleep -Seconds !WAIT_SECONDS!"
    
    echo.
    echo [%time%] 04:15 AM reached. Starting tasks...
) else (
    echo.
    echo ========================================
    echo          DAY MODE ACTIVATED
    echo ========================================
    echo Current time is within 04:00 - 22:00.
    echo Status: Starting tasks immediately.
    echo.
)
exit /b 0

REM ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
REM Subroutine: ShutdownCheck
REM Description: Reads shutdown settings from shutdown_schedule.ini and executes shutdown if enabled for today.
REM ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:ShutdownCheck
echo [%time%] Checking schedule for shutdown logic...

set "CONFIG_FILE=%~dp0shutdown_schedule.ini"

if not exist "%CONFIG_FILE%" (
    echo [WARNING] Configuration file not found: %CONFIG_FILE%
    echo Falling back to default: Shutdown on weekdays only.
    call :GetDayOfWeek
    set "DO_SHUTDOWN=true"
    if /i "!CURRENT_DAY!"=="Saturday" set "DO_SHUTDOWN=false"
    if /i "!CURRENT_DAY!"=="Sunday" set "DO_SHUTDOWN=false"
) else (
    call :GetDayOfWeek
    set "DO_SHUTDOWN=false"
    for /f "usebackq tokens=1,2 delims==" %%a in ("%CONFIG_FILE%") do (
        if /i "%%a"=="!CURRENT_DAY!" (
            if /i "%%b"=="true" set "DO_SHUTDOWN=true"
        )
    )
)

echo Today is: [!CURRENT_DAY!]
echo [Debug Info] Shutdown Flag from Config: !DO_SHUTDOWN!

REM Execute shutdown or skip based on flag
if "!DO_SHUTDOWN!"=="true" (
    echo [Scheduled] Preparing for shutdown sequence...
    echo.
    echo ========================================================
    echo  WARNING: SYSTEM WILL SHUT DOWN IN 60 SECONDS
    echo  Reason: Scheduled in shutdown_schedule.ini
    echo ========================================================
    echo.
    
    REM --- Execute Shutdown Command ---
    shutdown /s /t 60 /c "Auto Launcher: Tasks completed on !CURRENT_DAY!. System shutting down in 60s."
    
    REM Check if shutdown command was successfully submitted
    if !errorlevel! neq 0 (
        echo [ERROR] Shutdown command failed.
    ) else (
        echo Shutdown scheduled.
        echo ^(To cancel, run 'shutdown /a' in CMD^)
    )
) else (
    echo [Not Scheduled] Skipping shutdown sequence.
)
exit /b 0

REM ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
REM Subroutine: GetDayOfWeek
REM Description: Gets the current day of the week in English.
REM ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:GetDayOfWeek
set "PS_DAY_CMD=powershell -Command "(Get-Date).DayOfWeek.ToString()""
set "CURRENT_DAY="
for /f "usebackq delims=" %%d in (`!PS_DAY_CMD!`) do set "CURRENT_DAY=%%d"
if "!CURRENT_DAY!"=="" (
    echo [ERROR] Failed to determine day of week.
    exit /b 1
)
exit /b 0