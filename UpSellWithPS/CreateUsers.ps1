[CmdletBinding()]
Param()

Import-Module ActiveDirectory
Clear-Host
Write-Host "Creating users"
$NewUsers = Import-Csv -Path .\NewUsers.csv
$DemoOuExists = Test-Path 'AD:\OU=Demo,DC=Adatum,DC=com'
if ($DemoOuExists -eq $false) {New-ADOrganizationalUnit -Path 'DC=Adatum,DC=com' -Name 'Demo' -ErrorAction 'Stop'}
foreach ($NewUser in $NewUsers) {
  $NewUser |
   Select-Object -Property *,@{n='AccountPassword';e={$_.ClearPassword | ConvertTo-SecureString -AsPlainText -Force}} -ExcludeProperty ClearPassword |
   New-ADUser
}

