Import-Module ActiveDirectory
$DemoOuExists = Test-Path 'AD:\OU=Demo,DC=Adatum,DC=com'
if ($DemoOuExists -eq $false) {New-ADOrganizationalUnit -Path 'DC=Adatum,DC=com' -Name 'Demo' -ErrorAction 'Stop'}
Start-Process dsa.msc