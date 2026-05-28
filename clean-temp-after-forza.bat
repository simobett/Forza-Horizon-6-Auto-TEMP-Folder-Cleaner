@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "GAME_EXE=ForzaHorizon6.exe"
set "LOG=%~dp0forza6-temp-cleaner.log"

if /I "%~1"=="--worker" goto worker

rem Double-clicking a .bat always opens a console briefly. This hands off to a
rem hidden worker immediately so there is no foreground CMD left running.
wscript.exe "%~dp0start-forza6-temp-cleaner-hidden.vbs"
exit /b 0

:worker
call :log "Started hidden watcher for %GAME_EXE%."
call :log "Temp folder is %TEMP%."
call :log "Waiting for %GAME_EXE% to run."

:wait_for_game
call :is_game_running
if errorlevel 1 (
    timeout /T 10 /NOBREAK >NUL
    goto wait_for_game
)

call :log "Detected %GAME_EXE%. Waiting for the game to close."

:wait_for_close
call :is_game_running
if not errorlevel 1 (
    timeout /T 10 /NOBREAK >NUL
    goto wait_for_close
)

call :log "%GAME_EXE% closed. Starting temp cleanup."
call :count_temp_items BEFORE_COUNT
call :log "Temp items before cleanup: !BEFORE_COUNT!"

rem Delete files first, then folders. Locked items are skipped by Windows.
del /F /Q /S "%TEMP%\*" >NUL 2>> "%LOG%"
for /D %%D in ("%TEMP%\*") do rd /S /Q "%%D" >NUL 2>> "%LOG%"

call :count_temp_items AFTER_COUNT
call :log "Temp items after cleanup: !AFTER_COUNT!"
call :log "Cleanup finished. Locked system/app temp files can remain; that is normal."
exit /b 0

:is_game_running
tasklist /FI "IMAGENAME eq %GAME_EXE%" 2>NUL | find /I "%GAME_EXE%" >NUL
exit /b %ERRORLEVEL%

:count_temp_items
set "%~1=unknown"
for /F %%C in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "(Get-ChildItem -LiteralPath $env:TEMP -Force -ErrorAction SilentlyContinue | Measure-Object).Count"') do set "%~1=%%C"
exit /b 0

:log
>> "%LOG%" echo [%DATE% %TIME%] %~1
exit /b 0
