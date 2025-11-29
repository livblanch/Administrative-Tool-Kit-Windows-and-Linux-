# MasterAutomation.ps1
# Runs all admin toolkit scripts daily at 2 PM
# Generates error logs + master status ZIP archive


# Configuration
$root = "$env:USERPROFILE\Desktop\AdminToolKit"

$scripts = @{
    "BulkCreateUsers"       = "$root\Tools\BulkCreateUsers.ps1"
    "BulkDeleteUsers"       = "$root\Tools\BulkDeleteUsers.ps1"
    "BulkAssignDepartments" = "$root\Tools\BulkAssignDepartments.ps1"
    "ArchiveOldLogs"        = "$root\Tools\ArchiveOldLogs.ps1"
    "SystemHealthChecks"     = "$root\Tools\SystemHealthChecks.ps1"
}

$logFolder = "$root\RunLogs"
$summaryFolder = "$root\DailySummaries"

# Ensure folders exist
foreach ($folder in @($logFolder, $summaryFolder)) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
    }
}

# Timestamp
$timeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$errors = @{}
$summaryLogPath = "$summaryFolder\Summary_$timeStamp.txt"

# Function: Run admin script

function Run-AdminScript {
    param(
        [string]$Name,
        [string]$Path
    )

    $logPath = "$logFolder\$Name-$timeStamp.log"

    try {
        Write-Host "Running $Name..."
        PowerShell -ExecutionPolicy Bypass -File $Path *>&1 | Tee-Object -FilePath $logPath

        if ($LASTEXITCODE -ne 0) {
            $errors[$Name] = "Exited with code $LASTEXITCODE"
        }
    }
    catch {
        $errors[$Name] = $_.Exception.Message
    }
}


# Run each script 

foreach ($task in $scripts.Keys) {
    Run-AdminScript -Name $task -Path $scripts[$task]
}


# Build Status Summary 

$summary = @()
$summary += "Daily Status Summary - $timeStamp"
$summary += "=========================================`n"

foreach ($task in $scripts.Keys) {
    if ($errors.ContainsKey($task)) {
        $summary += "[FAILED] $task"
        $summary += "Reason: $($errors[$task])`n"
    } else {
        $summary += "[SUCCESS] $task`n"
    }
}

# Save summary
$summary -join "`n" | Out-File -FilePath $summaryLogPath -Encoding UTF8

Write-Host "Summary created: $summaryLogPath"

# Zip daily summary and logs
$zipName = "$root\DailyReport-$timeStamp.zip"

Compress-Archive -Path @(
    $summaryLogPath,
    "$logFolder\*-$timeStamp.log"
) -DestinationPath $zipName -Force

Write-Host "Created master ZIP archive:"
Write-Host $zipName