function Get-RandomString {
    param (
        [int]$length = 8
    )
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    $randomString = -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    return $randomString
}
# connect to the user with samAccountName edu01 and change the description attribute and the mail attribute with a random string
Get-ADUser -Filter {samAccountName -eq 'edu01'} | Set-ADUser -Description (Get-RandomString -length 10) -EmailAddress (Get-RandomString -length 10)
# take the shared folder object in AD with DN CN=ewf,OU=randomchanges,DC=megacorp,DC=local and change the description attribute with a random string
Get-ADObject -Filter {distinguishedName -eq 'CN=ewf,OU=randomchanges,DC=megacorp,DC=local'} | Set-ADObject -Description (Get-RandomString -length 10)
# take the inetOrgPerson object named ffff and change the description attribute with a random string
Get-ADObject -Filter {name -eq 'ffff'}  | Set-ADObject -Description (Get-RandomString -length 10)
# take the group91 in ad and change the description attribute with a random string
Get-ADGroup -Filter {name -eq 'group91'} | Set-ADGroup -Description (Get-RandomString -length 10)
# take the contact with DN CN=awdawd,OU=randomchanges,DC=megacorp,DC=local and change the description attribute with a random string
Get-ADObject -Filter {distinguishedName -eq 'CN=awdawd,OU=randomchanges,DC=megacorp,DC=local'} | Set-ADObject -Description (Get-RandomString -length 10)
# take the computer testpc in ad and change the description attribute with a random string
Get-ADComputer -Filter {name -eq 'testpc'} | Set-ADComputer -Description (Get-RandomString -length 10)
# take the OU with DN OU=bbb,OU=randomchanges,DC=megacorp,DC=local and change the description attribute with a random string
Get-ADOrganizationalUnit -Filter {distinguishedName -eq 'OU=bbb,OU=randomchanges,DC=megacorp,DC=local'} | Set-ADOrganizationalUnit -Description (Get-RandomString -length 10)

