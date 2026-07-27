# SAMI'S MODERN AUDIT (Win 10/11) - Final Compatibility Patch
$Model  = (Get-CimInstance Win32_ComputerSystem).Model
$Serial = (Get-CimInstance Win32_Bios).SerialNumber
$CPU    = (Get-CimInstance Win32_Processor).Name
$OS     = (Get-CimInstance Win32_OperatingSystem).Caption
$RAM    = [Math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1GB, 0)
$Disk   = [Math]::Round((Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'").Size / 1GB, 0)

# Battery Health with Hybrid Fallback
$BatHealth = "N/A"
try {
    $BatData = Get-CimInstance -Namespace root/wmi -ClassName BatteryFullChargedCapacity -ErrorAction Stop
    $Static  = Get-CimInstance -Namespace root/wmi -ClassName BatteryStaticData -ErrorAction Stop
    $Full = $BatData[0].FullChargedCapacity
    $Design = $Static[0].DesignedCapacity
} catch {
    $Full = (Get-WmiObject -Namespace root/wmi -Class BatteryFullChargedCapacity -ErrorAction SilentlyContinue)[0].FullChargedCapacity
    $Design = (Get-WmiObject -Namespace root/wmi -Class BatteryStaticData -ErrorAction SilentlyContinue)[0].DesignedCapacity
}
if ($Full -gt 0 -and $Design -gt 0) {
    $Pct = ($Full / $Design) * 100
    $BatHealth = "$([Math]::Round($Pct, 1))%"
}

# Driver Audit
$DriverErrors = Get-PnpDevice -Status Error -ErrorAction SilentlyContinue
$DriverStatus = "PASS"
if ($DriverErrors) { $DriverStatus = "FAIL" }

# Folder Logic
$ReportsRoot = "$PSScriptRoot\..\Reports"
if (-not (Test-Path $ReportsRoot)) { New-Item -ItemType Directory -Path $ReportsRoot -Force | Out-Null }
$FolderName = ($Model -replace '[^a-zA-Z0-9]', '_') + "_" + $Serial
$TargetFolder = "$ReportsRoot\$FolderName"
if (-not (Test-Path $TargetFolder)) { New-Item -ItemType Directory -Path $TargetFolder -Force | Out-Null }

# UI Output - Compatibility Safe Color Logic
$BatColor = "Green"
if ($BatHealth -eq "N/A") { $BatColor = "Red" }

Write-Host "`n--- SAMI'S MODERN AUDIT ---" -ForegroundColor Blue
Write-Host "Model:   $Model"
Write-Host "Serial:  $Serial"
Write-Host "CPU:     $CPU" -ForegroundColor Gray
Write-Host "Battery: $BatHealth" -ForegroundColor $BatColor
Write-Host "Specs:   $RAM GB RAM / $Disk GB Disk"

if ($DriverErrors) {
    Write-Host "Drivers: $DriverStatus" -ForegroundColor Red
    $DriverErrors | ForEach-Object { Write-Host " -> $($_.FriendlyName)" -ForegroundColor Yellow }
} else {
    Write-Host "Drivers: $DriverStatus" -ForegroundColor Green
}

# Save FULL Text Log
$Report = @"
==========================================
       SAMI'S SURFACE AUDIT REPORT
==========================================
Generated: $(Get-Date)

DEVICE IDENTITY
---------------
Model:    $Model
Serial:   $Serial
OS:       $OS

HARDWARE SPECS
--------------
CPU:      $CPU
RAM:      $RAM GB
Storage:  $Disk GB

DIAGNOSTICS
-----------
Battery:  $BatHealth Health
Drivers:  $DriverStatus
$(if($DriverErrors){ "`nFAILING DEVICES:`n" + ($DriverErrors.FriendlyName -join "`n") })
==========================================
"@
$Report | Out-File "$TargetFolder\Audit_Log.txt" -Force

# Save HTML separately (Fixed the HTML-in-TXT bug)
& powercfg /batteryreport /output "$TargetFolder\Battery_Report.html" | Out-Null