
$defaultContainers = @(
    "CN=Users", # Default container for user accounts
    "CN=Computers" # Default container for computer accounts
)

# Get all OUs in the domain, including their distinguished names
$allOUs = Get-ADOrganizationalUnit -Filter * -Properties DistinguishedName | Select-Object Name, DistinguishedName

# Exclude the default containers by checking if their distinguished names contain the default container names
$customOUs = $allOUs | Where-Object {
    $isDefault = $false
    foreach ($defaultContainer in $defaultContainers) {
        if ($_.DistinguishedName -like "*$defaultContainer,*") {
            $isDefault = $true
            break
        }
    }
    -not $isDefault
}

$customOUs

# create a function that creates a random string for displayName another for givenName another for sn, another for password, another for sAMaccountName
# Iterate 1000 times and call that function
# The function will take a random OU from $customOUs and create a user in that OU with the random attributes
# the userPrincipalName will be the sAMAccountName with the domain appended, in this case megacorp.local
# Import the Active Directory module
Import-Module ActiveDirectory

# Function to generate a random string
function Get-RandomString {
    param (
        [int]$length = 8
    )
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    $randomString = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    return $randomString
}

# Functions to generate random attributes
function Get-RandomDisplayName { Get-RandomString -length 10 }
function Get-RandomGivenName { Get-RandomString -length 6 }
function Get-RandomSN { Get-RandomString -length 8 }
function Get-RandomPassword { Get-RandomString -length 12 }
function Get-RandomSAMAccountName { Get-RandomString -length 8 }



# Function to create a user with random attributes
function New-RandomUser {
    $displayName = Get-RandomDisplayName
    $givenName = Get-RandomGivenName
    $sn = Get-RandomSN
    $password = Get-RandomPassword
    $sAMAccountName = Get-RandomSAMAccountName
    $ou = $customOUs | Get-Random
    $userPrincipalName = "$sAMAccountName@megacorp.local"

	# this password is for labs, no problem if it shows up on github
    $securePassword = ConvertTo-SecureString -String "C3**874wefwefw" -AsPlainText -Force

    try {
        New-ADUser -Name $displayName `
                   -GivenName $givenName `
                   -Surname $sn `
                   -DisplayName $displayName `
                   -SamAccountName $sAMAccountName `
                   -UserPrincipalName $userPrincipalName `
                   -Path $ou.DistinguishedName `
                   -AccountPassword $securePassword `
                   -Enabled $true

        Write-Host "Created user: $displayName in $ou"
    }
    catch {
        Write-Error "Failed to create user: $displayName. Error: $_"
    }
}

# Create 1000 random users
for ($i = 1; $i -le 50000; $i++) {
    New-RandomUser
    
}

Write-Host "Finished creating 1000 random users."