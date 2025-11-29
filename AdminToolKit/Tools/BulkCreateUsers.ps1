# Path to your CSV file 

$csvPath = "$env:USERPROFILE\Desktop\AdminToolKit\Employees.csv" 

 

# Import CSV 

$users = Import-Csv $csvPath 

 

# Default password for all users 

$defaultPassword = "Password123" 

 

foreach ($user in $users) { 

 

    # Make raw username (first + last) 

    $rawUsername = ($user."First Name" + $user."Last Name").ToLower() 

 

    # Trim whitespace 

    $rawUsername = $rawUsername -replace "\s","" 

 

    # If longer than 20 characters, cut it down 

    if ($rawUsername.Length -gt 20) { 

        $username = $rawUsername.Substring(0,20) 

    } else { 

        $username = $rawUsername 

    } 

 

    # Check if user already exists 

    if (-not (Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) { 

 

        $securePass = ConvertTo-SecureString $defaultPassword -AsPlainText -Force 

         

        # Create user 

        New-LocalUser -Name $username -FullName ($user."First Name" + " " + $user."Last Name") -Password $securePass 

         

        Write-Output "Created user: $username" 

    } 

    else { 

        Write-Output "User already exists: $username" 

    } 

} 

 