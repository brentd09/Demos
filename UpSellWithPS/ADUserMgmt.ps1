<# 
.NAME
    ADUserMgmt
#>
[CmdletBinding()]
Param()
Import-Module ActiveDirectory
$AllADUsers = Get-ADUser -Filter * | Sort-Object -Property Name

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(914,414)
$Form.text                       = "Level 1 HelpDesk tool"
$Form.TopMost                    = $false

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Choose an Active Directory User to manage"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(30,20)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',14)

$ComboUserPicker                 = New-Object system.Windows.Forms.ComboBox
$ComboUserPicker.text            = "comboBox"
$ComboUserPicker.width           = 395
$ComboUserPicker.height          = 20
$ComboUserPicker.location        = New-Object System.Drawing.Point(30,54)
$ComboUserPicker.Font            = New-Object System.Drawing.Font('Microsoft Sans Serif',12)
$ComboUserPicker.Items.AddRange($AllADUsers)
$ComboUserPicker.DisplayMember('Name')

$ButtonPassword                  = New-Object system.Windows.Forms.Button
$ButtonPassword.text             = "Change Password"
$ButtonPassword.width            = 150
$ButtonPassword.height           = 30
$ButtonPassword.location         = New-Object System.Drawing.Point(30,207)
$ButtonPassword.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$TextBoxPassword1                = New-Object system.Windows.Forms.TextBox
$TextBoxPassword1.multiline      = $false
$TextBoxPassword1.width          = 400
$TextBoxPassword1.height         = 20
$TextBoxPassword1.location       = New-Object System.Drawing.Point(30,250)
$TextBoxPassword1.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',12)
$TextBoxPassword1.UseSystemPasswordChar = $true

$labelUserState                  = New-Object system.Windows.Forms.Label
$labelUserState.text             = "Initial Info"
$labelUserState.AutoSize         = $true
$labelUserState.width            = 200
$labelUserState.height           = 10
$labelUserState.location         = New-Object System.Drawing.Point(40,96)
$labelUserState.Font             = New-Object System.Drawing.Font('Microsoft Sans Serif',12)

$ButtonDisable                   = New-Object system.Windows.Forms.Button
$ButtonDisable.text              = "Disable Account"
$ButtonDisable.width             = 150
$ButtonDisable.height            = 30
$ButtonDisable.location          = New-Object System.Drawing.Point(497,207)
$ButtonDisable.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ButtonEnable                    = New-Object system.Windows.Forms.Button
$ButtonEnable.text               = "Enable Acoount"
$ButtonEnable.width              = 150
$ButtonEnable.height             = 30
$ButtonEnable.location           = New-Object System.Drawing.Point(670,207)
$ButtonEnable.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ButtonClose                     = New-Object system.Windows.Forms.Button
$ButtonClose.text                = "Close"
$ButtonClose.width               = 150
$ButtonClose.height              = 30
$ButtonClose.location            = New-Object System.Drawing.Point(670,341)
$ButtonClose.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Form.controls.AddRange(@($Label1,$ComboUserPicker,$ButtonPassword,$TextBoxPassword1,$labelUserState,$ButtonDisable,$ButtonEnable,$ButtonClose))

$ComboUserPicker.Add_SelectedValueChanged({ 
  $ChosenUser = $AllADUsers | Where-Object {$_.ObjectGUID -eq $ComboUserPicker.SelectedItem.ObjectGUID}
  $labelUserState.ForeColor = 'Black'
  if ($ChosenUser.Enabled -eq $true) {$labelUserState.Text = $ChosenUser.Name + 'is currently enabled'}
  else {$labelUserState.Text = $ChosenUser.Name + 'is currently disabled'}
  $ButtonDisable.Enabled = $true
  $ButtonEnable.Enabled = $true
 })
$ButtonPassword.Add_Click({ 
  if ($TextBoxPassword1.Text) {
    $SecurePassword = $TextBoxPassword1.Text | ConvertTo-SecureString -AsPlainText -Force
    if ($ChosenUser) {
      try {
        Set-ADAccountPassword -Identity $ChosenUser -NewPassword $SecurePassword -Reset -ErrorAction Stop
        $labelUserState.Text = 'The password for ' + $ChosenUser + ' was reset to the new password' 
      }
      catch {$labelUserState.Text = 'The password for ' + $ChosenUser + ' could not be changed' }
    }
  }
})
$ButtonDisable.Add_Click({ 
  if ($ComboUserPicker.SelectedItem) {
    Disable-ADAccount -Identity $ChosenUser
    $labelUserState.ForeColor = 'Red'
    $CurrentUserState = Get-ADUser -identity $ChosenUser
    if ($CurrentUserState.Enabled -eq $false) {$labelUserState.Text = $ChosenUser.Name + ' has been disabled'}
  }
})
$ButtonEnable.Add_Click({ 
  if ($ComboUserPicker.SelectedItem) {
    Enable-ADAccount -Identity $ChosenUser
    $labelUserState.ForeColor = 'Blue'
    $CurrentUserState = Get-ADUser -identity $ChosenUser
    if ($CurrentUserState.Enabled -eq $false) {$labelUserState.Text = $ChosenUser.Name + ' has been enabled'}
  }
})
$ButtonClose.Add_Click({
  $Form.Close()
  $Form.Dispose()
})
$TextBoxPassword1.Add_Leave({$ButtonPassword.Enabled = $true})

#region Logic 
function closeform { }
function EnableAcct { }
function disableAcct { }
function changepwd { }
function changeval { }

#endregion

[void]$Form.ShowDialog()