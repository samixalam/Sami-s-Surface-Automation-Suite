Write-Host "--- FINAL RESALE PREPARATION ---" -ForegroundColor Cyan

# 1. Remove test artifacts
Write-Host "Removing test artifacts..."
if (Test-Path "C:\battery-report.html") { Remove-Item "C:\battery-report.html" -Force }

# 2. Empty Recycle Bin
Write-Host "Emptying Recycle Bin..."
if (Test-Path "C:\$Recycle.Bin") { cmd /c "rd /s /q C:\$Recycle.Bin" }

# 3. Clear Event Logs (Using a safe loop for RT)
Write-Host "Clearing Event Logs..."
$Logs = Get-EventLog -List
foreach ($Log in $Logs) {
    Clear-EventLog -LogName $Log.Log
}

Write-Host "PRE-SHIP CLEANUP COMPLETE." -ForegroundColor Green