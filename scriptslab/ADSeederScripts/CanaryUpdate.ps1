

# Specify the sAMAccountName of the user to modify
$sAMAccountName = "canary"

# Get the user object
$user = Get-ADUser -Identity $sAMAccountName -Properties *

# Create a hashtable to store the attribute changes
$changes = @{
    GivenName = "NewFirstName"
    Surname = "NewLastName"
    DisplayName = "New Display Name"
    Description = "New description for the user"
    Title = "New Job Title"
    Department = "New Department"
    Company = "New Company"
    OfficePhone = "123-456-7890"
    MobilePhone = "987-654-3210"
    Fax = "111-222-3333"
    EmailAddress = "new.email@example.com"
    HomePage = "https://www.example.com"
    StreetAddress = "123 New Street"
    City = "New City"
    State = "New State"
    PostalCode = "12345"
    Country = "New Country"
    Office = "New Office"
    Manager = "CN=NewManager,OU=Users,DC=example,DC=com"
    EmployeeID = "EMP123456"
    EmployeeNumber = "123456"
    Division = "New Division"
    Organization = "New Organization"
    OtherName = "New Middle Name"
    Initials = "NMN"
    ScriptPath = "\\server\scripts\newscript.vbs"
    ProfilePath = "\\server\profiles\newprofile"
    HomeDirectory = "\\server\homes\newhomedirectory"
    HomeDrive = "H:"
    LogonScript = "newlogonscript.vbs"
    HomePhone = "555-123-4567"
    Pager = "555-987-6543"
    IPPhone = "192.168.1.100"
    Info = "Additional information about the user"
    PostOfficeBox = "PO Box 12345"
    UserPrincipalName = "newupn@example.com"
    EmployeeType = "Full-Time"
    Enabled = $true
    CannotChangePassword = $false
    PasswordNeverExpires = $false
    SmartcardLogonRequired = $false
    TrustedForDelegation = $false
    AllowReversiblePasswordEncryption = $false
    AccountNotDelegated = $false
    UseDESKeyOnly = $false
    AccountExpirationDate = (Get-Date).AddYears(1)
    AccountLockoutTime = $null
    BadLogonCount = 0
    LastBadPasswordAttempt = $null
    LastLogon = $null
    LastLogoff = $null
    PasswordLastSet = (Get-Date)
    LockedOut = $false
    LogonCount = 0
    Modified = (Get-Date)
    PasswordExpired = $false
    whenCreated = (Get-Date).AddYears(-1)
    whenChanged = (Get-Date)
    DistinguishedName = "CN=NewCanary,OU=Users,DC=example,DC=com"
    ObjectGUID = [System.Guid]::NewGuid()
    ObjectSID = "S-1-5-21-1234567890-1234567890-1234567890-1001"
    SID = "S-1-5-21-1234567890-1234567890-1234567890-1001"
    PrimaryGroup = "CN=Domain Users,CN=Users,DC=example,DC=com"
    ProtectedFromAccidentalDeletion = $true
    Name = "NewCanary"
    CN = "NewCanary"
    CanonicalName = "example.com/Users/NewCanary"
    ObjectClass = "user"
    ObjectCategory = "CN=Person,CN=Schema,CN=Configuration,DC=example,DC=com"
    SamAccountType = 805306368
    UserAccountControl = 512
    AdminCount = 0
    AuthenticationPolicy = $null
    AuthenticationPolicySilo = $null
    Certificates = @()
    CompoundIdentitySupported = $false
    isDeleted = $false
    LastKnownParent = $null
    ManagedBy = $null
    MemberOf = @("CN=Group1,OU=Groups,DC=example,DC=com", "CN=Group2,OU=Groups,DC=example,DC=com")
    MNSLogonAccount = $false
    PasswordNotRequired = $false
    PrincipalsAllowedToDelegateToAccount = @()
    PropertyCount = 100
    ServicePrincipalNames = @("SPN1/example.com", "SPN2/example.com")
    SIDHistory = @()
    ThumbnailPhoto = [byte[]]@(1,2,3,4,5)
    UserParameters = $null
    aaa = "ffff"
}

# Apply the changes to the user object
foreach ($attribute in $changes.Keys) {
    Write-Host "Updating $attribute to $($changes[$attribute])"
    Set-ADUser -Identity $user -Replace @{ $attribute = $changes[$attribute] }
}


Write-Host "Attributes updated for user $sAMAccountName"