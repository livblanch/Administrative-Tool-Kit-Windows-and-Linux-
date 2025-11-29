# SystemHealthCheck.ps1
# Collects basic system health metrics and saves them as dated reports


# Configuration
$orgDataFolder = "$env:USERPROFILE\Desktop\AdminToolKit\OrgData"
$healthFolder = Join-Path $orgDataFolder "System Health Checks"

# Ensure folder exists
if (-not (Test-Path $healthFolder)) {
    New-Item -ItemType Directory -Path $healthFolder | Out-Null
    Write-Host "Created System Health Checks folder at $healthFolder"
}

# 1. Gather System Health Metrics


$reportDate = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$reportFile = Join-Path $healthFolder "SystemHealth-$reportDate.txt"

# CPU usage
$cpu = Get-CimInstance Win32_Processor | Select-Object LoadPercentage, Name

# Memory usage
$memory = Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory

# Disk usage
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, Size, FreeSpace

# Running processes
$processes = Get-Process | Select-Object Name, CPU, ID

# Logged in users
$loggedInUsers = Get-CimInstance Win32_ComputerSystem | Select-Object UserName


# 2. Save Report

@"
SYSTEM HEALTH REPORT - $reportDate


CPU:
$($cpu | Format-Table -AutoSize | Out-String)

Memory:
$($memory | Format-Table -AutoSize | Out-String)

Disks:
$($disks | Format-Table -AutoSize | Out-String)

Logged in Users:
$($loggedInUsers.UserName)

Top 10 Processes by CPU:
$($processes | Sort-Object -Property CPU -Descending | Select-Object -First 10 | Format-Table -AutoSize | Out-String)

"@ | Out-File -FilePath $reportFile -Encoding UTF8

Write-Host "System health check saved to $reportFile"