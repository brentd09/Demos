[CmdletBinding()]
Param()

Clear-Host
Write-Host "Creating 200 users"
$NewUsers = Import-Csv -Path .\NewUsers.csv
foreach ($NewUser in $NewUsers) {
  $NewUser |
   Select-Object -Property *,@{n='AccountPassword';e={$_.ClearPassword | ConvertTo-SecureString -AsPlainText -Force}} -ExcludeProperty ClearPassword |
   New-ADUser
}

