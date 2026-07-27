@echo off
title Final Resale Preparation Dispatcher
echo ---------------------------------------------------------
echo [1] PERFORMING FINAL SYSTEM WIPES...
echo ---------------------------------------------------------

:: Launch the PowerShell final cleanup script
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Scripts\Finalize_Ship.ps1"

echo ---------------------------------------------------------
echo [2] SYSTEM FINALIZATION COMPLETE.
echo.
echo WARNING: Pressing any key will trigger the FINAL SHUTDOWN.
echo This puts the device into "Out of Box Experience" (OOBE).
echo The next person to turn it on will see the Welcome screen.
echo ---------------------------------------------------------
pause

:: The official resale command (No Generalize as per SOP)
C:\Windows\System32\Sysprep\sysprep.exe /oobe /shutdown