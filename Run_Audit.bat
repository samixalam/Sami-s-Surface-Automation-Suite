@echo off
title SAMI'S SMART AUDIT DISPATCHER
echo =========================================================
echo        SAMI'S SURFACE AUTOMATION SUITE v1.2
echo =========================================================
echo [1] IDENTIFYING SYSTEM ARCHITECTURE...

for /f "tokens=4-5 delims=. " %%i in ('ver') do set OS_VER=%%i.%%j
echo OS Version Detected: %OS_VER%

if "%OS_VER%"=="6.3" goto LEGACY
if "%OS_VER%"=="6.2" goto LEGACY
if "%OS_VER:~0,2%"=="10" goto MODERN

:MODERN
echo [SYSTEM] Modern Architecture (Windows 10/11).
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Scripts\SurfaceAudit_Modern.ps1"
goto END

:LEGACY
echo [SYSTEM] Legacy Architecture (Windows 8.1/RT).
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Scripts\SurfaceAudit_Legacy.ps1"
goto END

:END
echo =========================================================
echo AUDIT COMPLETE.
pause