$a = 832091
$p = 322

$s1 = 321
$s2 = 319

$pow1 = [math]::Pow($a,$s1) 
$pow2 = [math]::Pow($a,$s2)

$mod1 = [math]::DivRem($pow1,$p)
$mod2 = [math]::DivRem($pow2,$p)

