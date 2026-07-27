Write-Host "--- CAMERA TEST CLEANUP ---" -ForegroundColor Cyan

$TargetUser = "CameraTest"

# 1. Delete the user account (Standard CMD command)
Write-Host "Deleting account: $TargetUser..."
net user $TargetUser /delete

# 2. Wipe the Profile Folder
$ProfilePath = "C:\Users\" + $TargetUser
if (Test-Path $ProfilePath) {
    Write-Host "Wiping profile files..." -ForegroundColor Yellow
    cmd /c "rd /s /q $ProfilePath"
}

# 3. Clean up the Registry entry (WMI is safe on RT)
Write-Host "Cleaning Registry..."
$ProfileReg = Get-WmiObject Win32_UserProfile | Where-Object {$_.LocalPath -like "*$TargetUser*"}
if ($ProfileReg) {
    $ProfileReg.Delete()
}

Write-Host "CLEANUP COMPLETE." -ForegroundColor Green