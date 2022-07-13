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
$Form.TopMost                    = $true

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Choose an Active Directory User to manage"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(30,20)
$Label1.Font                     = New-Object System.Drawing.Font('Arial',14)

$ComboUserPicker                 = New-Object system.Windows.Forms.ComboBox
$ComboUserPicker.text            = ""
$ComboUserPicker.width           = 395
$ComboUserPicker.height          = 20
$ComboUserPicker.location        = New-Object System.Drawing.Point(30,54)
$ComboUserPicker.Font            = New-Object System.Drawing.Font('Arial',12)
$ComboUserPicker.Items.AddRange($AllADUsers)
$ComboUserPicker.DisplayMember = 'Name'

$ButtonPassword                  = New-Object system.Windows.Forms.Button
$ButtonPassword.text             = "Change Password"
$ButtonPassword.width            = 150
$ButtonPassword.height           = 30
$ButtonPassword.location         = New-Object System.Drawing.Point(30,207)
$ButtonPassword.Font             = New-Object System.Drawing.Font('Arial',10)
$ButtonPassword.Enabled          = $false


$TextBoxPassword1                = New-Object system.Windows.Forms.TextBox
$TextBoxPassword1.multiline      = $false
$TextBoxPassword1.width          = 400
$TextBoxPassword1.height         = 20
$TextBoxPassword1.location       = New-Object System.Drawing.Point(30,170)
$TextBoxPassword1.Font           = New-Object System.Drawing.Font('Arial',12)
$TextBoxPassword1.UseSystemPasswordChar = $true
$TextBoxPassword1.Enabled        = $false

$labelUserState                  = New-Object system.Windows.Forms.Label
$labelUserState.text             = ""
$labelUserState.AutoSize         = $true
$labelUserState.width            = 200
$labelUserState.height           = 10
$labelUserState.location         = New-Object System.Drawing.Point(40,96)
$labelUserState.Font             = New-Object System.Drawing.Font('Arial',12)
$labelUserState.Enabled          = $false
$labelUserState.ForeColor        = [System.Drawing.Color]::Red


$ButtonDisable                   = New-Object system.Windows.Forms.Button
$ButtonDisable.text              = "Disable Account"
$ButtonDisable.width             = 150
$ButtonDisable.height            = 30
$ButtonDisable.location          = New-Object System.Drawing.Point(497,207)
$ButtonDisable.Font              = New-Object System.Drawing.Font('Arial',10)
$ButtonDisable.Enabled           = $false



$ButtonEnable                    = New-Object system.Windows.Forms.Button
$ButtonEnable.text               = "Enable Acoount"
$ButtonEnable.width              = 150
$ButtonEnable.height             = 30
$ButtonEnable.location           = New-Object System.Drawing.Point(670,207)
$ButtonEnable.Font               = New-Object System.Drawing.Font('Arial',10)
$ButtonEnable.Enabled            = $false


$ButtonClose                     = New-Object system.Windows.Forms.Button
$ButtonClose.text                = "Close"
$ButtonClose.width               = 150
$ButtonClose.height              = 30
$ButtonClose.location            = New-Object System.Drawing.Point(670,341)
$ButtonClose.Font                = New-Object System.Drawing.Font('Arial',10)

$Form.controls.AddRange(@($Label1,$ComboUserPicker,$ButtonPassword,$TextBoxPassword1,$labelUserState,$ButtonDisable,$ButtonEnable,$ButtonClose))

$ComboUserPicker.Add_Click({
  $ButtonDisable.Enabled = $false
  $ButtonEnable.Enabled = $false
  $TextBoxPassword1.Enabled = $false 
})

$ComboUserPicker.Add_SelectedValueChanged({ 
  if ($ComboUserPicker.SelectedItem) {
    $CurrentUserStatus = Get-ADUser -Identity $ComboUserPicker.SelectedItem
    if ($CurrentUserStatus.Enabled -eq $true) {
      $labelUserState.Text = $ChosenUser.Name + ' is currently enabled'
      $labelUserState.ForeColor = [System.Drawing.Color]::Blue

    }
    else {
      $labelUserState.Text = $ComboUserPicker.SelectedItem.Name + 'is currently disabled'
      $labelUserState.ForeColor = [System.Drawing.Color]::Blue
    }
    $ButtonDisable.Enabled = $true
    $ButtonEnable.Enabled = $true
    $TextBoxPassword1.Enabled = $true 
  }
 })
$ButtonPassword.Add_Click({ 
  if ($TextBoxPassword1.Text) {
    $SecurePassword = $TextBoxPassword1.Text | ConvertTo-SecureString -AsPlainText -Force
    if ($ComboUserPicker.SelectedItem) {
      try {
        Set-ADAccountPassword -Identity $ComboUserPicker.SelectedItem -NewPassword $SecurePassword -Reset -ErrorAction Stop
        $labelUserState.Text = 'The password for ' + $ComboUserPicker.SelectedItem.Name + ' was reset to the new password' 
        $TextBoxPassword1.text = $null
      }
      catch {$labelUserState.Text = 'The password for ' + $ComboUserPicker.SelectedItem.Name + ' could not be changed' }
    }
  }
})
$ButtonDisable.Add_Click({ 
  if ($ComboUserPicker.SelectedItem) {
    try {
      Disable-ADAccount -Identity $ComboUserPicker.SelectedItem
      $CurrentUserState = Get-ADUser -identity $ComboUserPicker.SelectedItem
      if ($CurrentUserState.Enabled -eq $false) {
        $labelUserState.Text = $ComboUserPicker.SelectedItem.Name + ' has been disabled'
        $labelUserState.ForeColor = [System.Drawing.Color]::Red
      }
    }
    catch {
      $labelUserState.Text = $ComboUserPicker.SelectedItem.Name + ' could not be disabled'
      $labelUserState.ForeColor = [System.Drawing.Color]::Red
    }
  }
})
$ButtonEnable.Add_Click({ 
  if ($ComboUserPicker.SelectedItem) {
    try {
      Enable-ADAccount -Identity $ComboUserPicker.SelectedItem
      $CurrentUserState = Get-ADUser -identity $ComboUserPicker.SelectedItem
      if ($CurrentUserState.Enabled -eq $true) {
        $labelUserState.ForeColor = [System.Drawing.Color]::Blue
        $labelUserState.Text = $ComboUserPicker.SelectedItem.Name + ' has been enabled'
      }
    }
    catch {
      $labelUserState.ForeColor = [System.Drawing.Color]::Blue
      $labelUserState.Text = $ComboUserPicker.SelectedItem.Name + ' could not be enabled'
    }
  }
})
$ButtonClose.Add_Click({
  $Form.Close()
  $Form.Dispose()
})
$TextBoxPassword1.Add_Enter({$ButtonPassword.Enabled = $true})

#endregion

[void]$Form.ShowDialog()
