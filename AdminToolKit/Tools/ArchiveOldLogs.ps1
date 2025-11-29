# ArchiveOldLogs.ps1
# Moves logs older than a specified number of days
# from Logs folder to Backups folder, then compresses


# Configuration
$daysToKeep = 7
$logFolder = "$env:USERPROFILE\Desktop\AdminToolKit\OrgData\Logs"
$backupFolder = "$env:USERPROFILE\Desktop\AdminToolKit\OrgData\Backups"

# 1. Ensure folders exist
if (-not (Test-Path $logFolder)) {
    Write-Host "Logs folder does not exist: $logFolder"
    exit
}

if (-not (Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
    Write-Host "Created backup folder: $backupFolder"
}


# 2. Find old logs
$cutoff = (Get-Date).AddDays(-$daysToKeep)
$oldLogs = Get-ChildItem -Path $logFolder -File | Where-Object { $_.LastWriteTime -lt $cutoff }

if ($oldLogs.Count -eq 0) {
    Write-Host "No logs older than $daysToKeep days to archive."
} else {
 
    # 3. Move old logs to backup and update LastWriteTime to today
    foreach ($log in $oldLogs) {
        try {
            $dest = Join-Path $backupFolder $log.Name
            Move-Item -Path $log.FullName -Destination $dest -Force

            # Update the LastWriteTime to now so it can be identified as moved today
            (Get-Item $dest).LastWriteTime = Get-Date

            Write-Host "Moved $($log.Name) to backup"
        } catch {
            Write-Host "Error moving $($log.Name): $_"
        }
    }

    # 4. Compress logs moved today
    $today = Get-Date -Format "yyyy-MM-dd"
    $zipName = "ArchivedLogs-$today.zip"
    $zipPath = Join-Path $backupFolder $zipName

    # Get logs with LastWriteTime = today
    $logsToCompress = Get-ChildItem -Path $backupFolder -File |
        Where-Object { $_.LastWriteTime.Date -eq (Get-Date).Date }

    if ($logsToCompress.Count -gt 0) {
        Compress-Archive -Path $logsToCompress.FullName -DestinationPath $zipPath -Force
        Write-Host "Compressed the following logs into ${zipPath}:"
        $logsToCompress | ForEach-Object { Write-Host $_.Name }

        # Delete originals after compression to avoid duplication
        $logsToCompress | Remove-Item -Force
        Write-Host "Deleted original logs from backup after compression."
    } else {
        Write-Host "No logs to compress today."
    }
}

Write-Host "Log rotation complete!"