# functions
function Get-Tax {
[CmdletBinding()]
  Param (
    [double]$PreTaxIncome,
    [double]$Benefit
  )
  # These are the values per Australian Tax bracket
  $TaxCents    = @(    0, 0.19, 0.325,  0.37,  0.45)
  $TaxCeilings = @(18200,45000,120000,180000,180001)
  $TaxFromPrev = @(    0,    0,  5092, 29467, 51667)

  if ($PreTaxIncome -le $TaxCeilings[0]) {
    $Bracket = 0
    $TotalTaxPaid = $TaxFromPrev[0] + 0
  }
  elseif ($PreTaxIncome -le $TaxCeilings[1]) {
    $Bracket = 1
    $TotalTaxPaid = ($TaxFromPrev[1] + $PreTaxIncome - $TaxCeilings[0]) * $TaxCents[$Bracket]
  }
  elseif ($PreTaxIncome -le $TaxCeilings[2]) {
    $Bracket = 2
    $TotalTaxPaid = $TaxFromPrev[2] + ($PreTaxIncome - $TaxCeilings[1]) * $TaxCents[$Bracket]
  }
  elseif ($PreTaxIncome -le $TaxCeilings[3]) {
    $Bracket = 3
    $TotalTaxPaid = $TaxFromPrev[3] + ($PreTaxIncome - $TaxCeilings[2]) * $TaxCents[$Bracket]
  }
  elseif ($PreTaxIncome -ge $TaxCeilings[4]) {
    $Bracket = 4
    $TotalTaxPaid = $TaxFromPrev[4] + ($PreTaxIncome - $TaxCeilings[3]) * $TaxCents[$Bracket]
  }
  return [PSCustomObject]@{
    Original      = [math]::Round($PreTaxIncome,2)
    Equiv         = [math]::Round($Benefit / (1-$TaxCents[$Bracket]) + $PreTaxIncome,2)
    PreTaxIncr    = [math]::Round((($Benefit / (1-$TaxCents[$Bracket]) + $PreTaxIncome) - $PreTaxIncome),2)
  }
}

# Main Code

Get-Tax -PreTaxIncome 128331.33 -Benefit 470

