@echo off
title SAMI'S AUDIT RETURN TOOL
echo =========================================================
echo        SAMI'S AUDIT MODE RE-ENTRY v1.2
echo =========================================================
echo [1] PREPARING SYSTEM TO RETURN TO AUDIT MODE...
echo.
echo WARNING: The system will now reboot and automatically 
echo log into the built-in Administrator account.
echo ---------------------------------------------------------
pause

:: The command to switch from OOBE/User mode back to Audit Mode
C:\Windows\System32\Sysprep\sysprep.exe /audit /reboot