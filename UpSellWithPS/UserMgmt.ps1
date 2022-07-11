<# 
.NAME
    ChangeAccount
#>

$AllUsers = Get-ADUser -filter * 
$AllNames = $AllUsers.Name

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(810,406)
$Form.text                       = "Account Control"
$Form.TopMost                    = $false

$dabtn                           = New-Object system.Windows.Forms.Button
$dabtn.text                      = "Disable Account"
$dabtn.width                     = 115
$dabtn.height                    = 30
$dabtn.location                  = New-Object System.Drawing.Point(606,240)
$dabtn.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$eabtn                           = New-Object system.Windows.Forms.Button
$eabtn.text                      = "Enable Account"
$eabtn.width                     = 115
$eabtn.height                    = 30
$eabtn.location                  = New-Object System.Drawing.Point(606,290)
$eabtn.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$sucbox                          = New-Object system.Windows.Forms.ComboBox
$sucbox.width                    = 396
$sucbox.height                   = 78
$sucbox.location                 = New-Object System.Drawing.Point(36,50)
$sucbox.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',14)
$sucbox.Items.AddRange($AllNames)

$Form.controls.AddRange(@($dabtn,$eabtn,$sucbox))

$dabtn.Add_Click({ 
    if ($sucbox.SelectedItem) {}
 })
$eabtn.Add_Click({ EnableAccount })
$sucbox.Add_Click({ GetUsers })

#region Logic 
function GetUsers { }
function EnableAccount { }

function DisableAccount { }

#endregion

[void]$Form.ShowDialog()