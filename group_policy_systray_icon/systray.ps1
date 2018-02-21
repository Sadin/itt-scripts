#param(
#    [Parameter(Mandatory=$true,HelpMessage='The name of the program')][string]$ProgramName,
#    [Parameter(Mandatory=$true,HelpMessage='Program value')]
#        [ValidateScript({if ($_ -lt 0 -or $_ -gt 2) { throw 'Invalid setting' } return $true})]
#        [Int16]$Setting
#    )

# In event not set already, Disable explorer from restarting via registry. ( Default for windows is to in fact, Restart )
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoRestartShell -Value 0

# Kill explorer.exe via Powershell
Stop-Process -Name explorer -Force

# Set search values manually. ( Were looking for Ninja's systray application here, and we want to Always show icon thus the "2" )
$ProgramName = 'njbar.exe'
$Setting = 2

# Run the script that searches for values set above in the registry, then make changes
$encText = New-Object System.Text.UTF8Encoding
[byte[]] $bytRegKey = @()
$strRegKey = ""
$bytRegKey = $(Get-ItemProperty $(Get-Item 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify').PSPath).IconStreams
for($x=0; $x -le $bytRegKey.Count; $x++)
{
    $tempString = [Convert]::ToString($bytRegKey[$x], 16)
    switch($tempString.Length)
    {
        0 {$strRegKey += "00"}
        1 {$strRegKey += "0" + $tempString}
        2 {$strRegKey += $tempString}
    }
}
[byte[]] $bytTempAppPath = @()
$bytTempAppPath = $encText.GetBytes($ProgramName)
[byte[]] $bytAppPath = @()
$strAppPath = ""

Function Rot13($byteToRot)
{
    if($byteToRot -gt 64 -and $byteToRot -lt 91)
    {
        $bytRot = $($($byteToRot - 64 + 13) % 26 + 64)
        return $bytRot
    }
    elseif($byteToRot -gt 96 -and $byteToRot -lt 123)
    {
        $bytRot = $($($byteToRot - 96 + 13) % 26 + 96)
        return $bytRot
    }
    else
    {
        return $byteToRot
    }
}

for($x = 0; $x -lt $bytTempAppPath.Count * 2; $x++)
{
    If($x % 2 -eq 0)
    {
        $curbyte = $bytTempAppPath[$([Int]($x / 2))]
            $bytAppPath += Rot13($curbyte)

    }
    Else
    {
        $bytAppPath += 0
    }
}

for($x=0; $x -lt $bytAppPath.Count; $x++)
{
    $tempString = [Convert]::ToString($bytAppPath[$x], 16)
    switch($tempString.Length)
    {
        0 {$strAppPath += "00"}
        1 {$strAppPath += "0" + $tempString}
        2 {$strAppPath += $tempString}
    }
}
if(-not $strRegKey.Contains($strAppPath))
{
    Start-Process cmd.exe
    break
}

[byte[]] $header = @()
$items = @{}
for($x=0; $x -lt 20; $x++)
{
    $header += $bytRegKey[$x]
}

for($x=0; $x -lt $(($bytRegKey.Count-20)/1640); $x++)
{
    [byte[]] $item=@()
    $startingByte = 20 + ($x*1640)
    $item += $bytRegKey[$($startingByte)..$($startingByte+1639)]
    $items.Add($startingByte.ToString(), $item)
}

foreach($key in $items.Keys)
{
$item = $items[$key]
    $strItem = ""
    $tempString = ""

    for($x=0; $x -le $item.Count; $x++)
    {
        $tempString = [Convert]::ToString($item[$x], 16)
        switch($tempString.Length)
        {
            0 {$strItem += "00"}
            1 {$strItem += "0" + $tempString}
            2 {$strItem += $tempString}
        }
    }
    if($strItem.Contains($strAppPath))
    {
        $bytRegKey[$([Convert]::ToInt32($key)+528)] = $setting
        Set-ItemProperty $($(Get-Item 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify').PSPath) -name IconStreams -value $bytRegKey
    }
}

# Restart explorer.exe
Start-Process explorer.exe