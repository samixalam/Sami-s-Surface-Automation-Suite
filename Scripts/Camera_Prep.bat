@echo off
echo EXITING AUDIT MODE FOR CAMERA TEST...
echo System will reboot to OOBE. Create local user 'CameraTest'.
pause
C:\Windows\System32\Sysprep\sysprep.exe /oobe /reboot