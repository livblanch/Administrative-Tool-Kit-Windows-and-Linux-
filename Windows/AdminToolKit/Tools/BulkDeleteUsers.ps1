# Path to the terminated users CSV
$csvPath = "$env:USERPROFILE\Desktop\AdminToolKit\TerminatedUsers.csv"

if (-not (Test-Path $csvPath)) {
    Write-Host "TerminatedUsers.csv not found. Exiting."
    exit
}

# Read CSV
$terminated = Import-Csv $csvPath

foreach ($user in $terminated) {
    # Generate the username: first initial + last name, lowercase
    $username = ($user.'First Name'.Substring(0,1) + $user.'Last Name').ToLower()

    # Check if user exists
    $localUser = Get-LocalUser -Name $username -ErrorAction SilentlyContinue

    if ($localUser) {
        # Remove user
        Remove-LocalUser -Name $username
        Write-Host "Deleted terminated user: $username"
    } else {
        Write-Host "User not found: $username"
    }
}
