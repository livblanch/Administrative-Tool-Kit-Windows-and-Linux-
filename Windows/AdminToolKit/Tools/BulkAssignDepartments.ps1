# Path to your CSV file
$csvPath = "$env:USERPROFILE\Desktop\AdminToolKit\Employees.csv"

# Import CSV
$users = Import-Csv $csvPath

# Function to sanitize department names for groups
function Fix-GroupName {
    param([string]$name)
    return ($name -replace '[\\\/:*?"<>|]', '_')
}

# 1. Create groups from Departments

$departments = $users.Department | Sort-Object -Unique

foreach ($dept in $departments) {
    $groupName = Fix-GroupName $dept

    if (-not (Get-LocalGroup -Name $groupName -ErrorAction SilentlyContinue)) {
        New-LocalGroup -Name $groupName
        Write-Host "Created group: $groupName"
    } else {
        Write-Host "Group already exists: $groupName"
    }
}

# 2. Create users and add to groups
# Keep Create Users to Assure New Users Are Accounted For
# Passwords will need to be changed from default once created

$defaultPassword = "Password123"
$securePass = ConvertTo-SecureString $defaultPassword -AsPlainText -Force

foreach ($user in $users) {

    # Build username
    $rawUsername = ($user."First Name" + $user."Last Name").ToLower()
    $rawUsername = $rawUsername -replace "\s",""

    if ($rawUsername.Length -gt 20) {
        $username = $rawUsername.Substring(0,20)
    } else {
        $username = $rawUsername
    }

    # Create user if not exists
    if (-not (Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
        New-LocalUser -Name $username -FullName "$($user.'First Name') $($user.'Last Name')" -Password $securePass
        Write-Host "Created user: $username"
    } else {
        Write-Host "User already exists: $username"
    }

    # Add user to group
    $groupName = Fix-GroupName $user.Department
    Add-LocalGroupMember -Group $groupName -Member $username -ErrorAction SilentlyContinue

    Write-Host "Added $username to $groupName"
}