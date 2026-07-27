@echo off
title Camera Test Cleanup Dispatcher
echo ---------------------------------------------------------
echo [1] DELETING CAMERA TEST DATA...
echo ---------------------------------------------------------

:: Launch the PowerShell cleanup script
:: %~dp0 tells it to look in the folder where THIS batch file is located
powershell.exe -ExecutionPolicy Bypass -File "%~dp0Scripts\Camera_Cleanup.ps1"

echo ---------------------------------------------------------
echo CLEANUP LOGIC FINISHED. 
echo Verify the "CameraTest" user is gone, then proceed.
echo ---------------------------------------------------------
pause