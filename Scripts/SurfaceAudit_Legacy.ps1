# SAMI'S LEGACY AUDIT (Surface RT) - Driver Audit Integrated
$Model  = (Get-WmiObject Win32_ComputerSystem).Model
$Serial = (Get-WmiObject Win32_Bios).SerialNumber
$CPU    = (Get-WmiObject Win32_Processor).Name
$OS     = (Get-WmiObject Win32_OperatingSystem).Caption

$TRAM = (Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum
$RAM  = [int]($TRAM / 1GB)
$TDisk = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'").Size
$Disk  = [int]($TDisk / 1GB)

# Battery Health
$BatHealth = "Check HTML"
try {
    $F = (Get-WmiObject -Namespace root\wmi -Class BatteryFullChargedCapacity -ErrorAction SilentlyContinue).FullChargedCapacity
    $D = (Get-WmiObject -Namespace root\wmi -Class BatteryStaticData -ErrorAction SilentlyContinue).DesignedCapacity
    if ($F -and $D) {
        $H = ($F / $D) * 100
        $BatHealth = "{0:N1}%" -f $H
    }
} catch { $BatHealth = "Check HTML" }

# Driver Audit (Legacy WMI Method)
$DriverErrors = Get-WmiObject Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }
$DriverStatus = if ($DriverErrors) { "FAIL" } else { "PASS" }

# Folder Logic
$ReportsRoot = $PSScriptRoot + "\..\Reports"
if (-not (Test-Path $ReportsRoot)) { New-Item -ItemType Directory -Path $ReportsRoot | Out-Null }
$CleanModel = $Model -replace '[^a-zA-Z0-9]', '_'
$FolderName = $CleanModel + "_" + $Serial
$TargetFolder = $ReportsRoot + "\" + $FolderName
if (-not (Test-Path $TargetFolder)) { New-Item -ItemType Directory -Path $TargetFolder | Out-Null }

# UI Output
Write-Host "`n--- SAMI'S LEGACY AUDIT ---" -ForegroundColor Cyan
Write-Host "Model:   $Model"
Write-Host "Serial:  $Serial"
Write-Host "CPU:     $CPU" -ForegroundColor Gray
Write-Host "Specs:   $RAM GB RAM / $Disk GB Disk"
Write-Host "Battery: $BatHealth"

if ($DriverErrors) {
    Write-Host "Drivers: $DriverStatus" -ForegroundColor Red
    foreach ($dev in $DriverErrors) { Write-Host " -> $($dev.Name)" -ForegroundColor Yellow }
} else {
    Write-Host "Drivers: $DriverStatus" -ForegroundColor Green
}

# Save FULL Text Log
$Report = "==========================================
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
Battery:  $BatHealth
Drivers:  $DriverStatus
$(if($DriverErrors){ "`nFAILING DEVICES:`n" + ($DriverErrors.Name -join "`n") })
=========================================="
$Report | Out-File "$TargetFolder\Audit_Log.txt" -Encoding UTF8 -Force
& powercfg /batteryreport /output "$TargetFolder\Battery_Report.html" | Out-Null