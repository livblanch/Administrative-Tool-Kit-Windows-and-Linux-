# SetupMasterAutomation.ps1
# Creates scheduled task to run MasterAutomation.ps1
# daily at 2 PM + sets execution policy for this session


Write-Host "=== Starting Master Automation Setup ===" -ForegroundColor Cyan

# Allow scripts to run for this session
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Write-Host "Execution policy set to Bypass for this session."

# Full path to MasterAutomation.ps1
$root = "$env:USERPROFILE\Desktop\AdminToolKit"
$taskScript = "$root\MasterAutomation.ps1"

# Validate file exists
if (-not (Test-Path $taskScript)) {
    Write-Host "ERROR: MasterAutomation.ps1 not found at path:" -ForegroundColor Red
    Write-Host $taskScript
    exit 1
}

Write-Host "Found MasterAutomation.ps1 at: $taskScript"


# 1. Create the scheduled task action
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$taskScript`""


# 2. Create daily trigger at 2 PM
$trigger = New-ScheduledTaskTrigger -Daily -At 2:00PM

# 3. Register the scheduled task
$taskName = "AdminToolkit_MasterAutomation"

try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Description "Runs Admin Toolkit automation daily at 2 PM." -Force
    Write-Host "Scheduled Task '$taskName' created successfully!" -ForegroundColor Green
}
catch {
    Write-Host "ERROR creating scheduled task:" -ForegroundColor Red
    Write-Host $_.Exception.Message
    exit 1
}

Write-Host "`n=== Setup Complete! ===" -ForegroundColor Green
Write-Host "Your automation will now run daily at 2 PM."