<# 
.NAME
    ChangeAccount
#>

$AllUsers = Get-ADUser -filter * 
$AllNames = $AllUsers | Sort-Object -Property Name

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(810,406)
$Form.text                       = "Account Control"
$Form.TopMost                    = $false

$dabtn                           = New-Object system.Windows.Forms.Button
$dabtn.text                      = "Disable Account"
$dabtn.width                     = 150
$dabtn.height                    = 30
$dabtn.location                  = New-Object System.Drawing.Point(606,240)
$dabtn.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$statuslbl                       = New-Object System.Windows.Forms.Label
$statuslbl.text                  = ""
$statuslbl.width                 = 300
$statuslbl.height                = 30
$statuslbl.location              = New-Object System.Drawing.Point(36,100)
$statuslbl.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',12)
$statuslbl.ForeColor             = "Red"

$eabtn                           = New-Object system.Windows.Forms.Button
$eabtn.text                      = "Enable Account"
$eabtn.width                     = 150
$eabtn.height                    = 30
$eabtn.location                  = New-Object System.Drawing.Point(606,290)
$eabtn.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$sucbox                          = New-Object system.Windows.Forms.ComboBox
$sucbox.width                    = 396
$sucbox.height                   = 78
$sucbox.location                 = New-Object System.Drawing.Point(36,50)
$sucbox.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',14)
$sucbox.Items.AddRange($AllNames)
$sucbox.DisplayMember = 'Name'

$Form.controls.AddRange(@($statuslbl,$dabtn,$eabtn,$sucbox))

$sucbox.Add_SelectedValueChanged({
  $ADUser = Get-ADUser -Identity $sucbox.SelectedItem
  $statuslbl.ForeColor = "Black"
  if ($ADUser.Enabled -eq $true) {$statuslbl.text = $ADUser.Name + ' is currently enabled'}
  else {$statuslbl.text = $ADUser.Name + ' is currently disabled'}
}) 


$dabtn.Add_Click({ 
  if ($sucbox.SelectedItem) {
    $statuslbl.ForeColor = "Red"
    Disable-ADAccount -Identity $sucbox.SelectedItem
    $ADUser = Get-ADUser -Identity $sucbox.SelectedItem
    if ($ADUser.Enabled -eq $false) {$statuslbl.text = $ADUser.Name + ' has been disabled'}

  }
 })
$eabtn.Add_Click({ 
  if ($sucbox.SelectedItem) {
    $statuslbl.ForeColor = "Blue"
    Enable-ADAccount -Identity $sucbox.SelectedItem
    $ADUser = Get-ADUser -Identity $sucbox.SelectedItem
    if ($ADUser.Enabled -eq $true) {$statuslbl.text = $ADUser.Name + ' has been enabled'}
  }
   
})
$sucbox.Add_Click({ GetUsers })

#region Logic 
function GetUsers { }
function EnableAccount { }

function DisableAccount { }

#endregion

[void]$Form.ShowDialog()
