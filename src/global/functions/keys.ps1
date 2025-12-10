. (Resolve-Path "..\..\paths.ps1")

$keysFilepath = "$serverKeysFolderpath\"

$key = New-Object byte[] 32
$iv = New-Object byte[] 16
$id = [guid]::NewGuid().ToString()

$keysFilepath = "$serverKeysFolderpath\$id.json"

[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($key)
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($iv)

$keyHex = ""
ForEach ($byte in $key) {
    $keyHex += $byte.ToString("X2")
}

$ivhex = ""
ForEach ($byte in $iv) {
    $ivhex += $byte.ToString("X2")
}

$keys = [PSCustomObject]@{
	Key = $keyHex
	IV = $ivhex
}

$keysJSON = ConvertTo-Json $keys

Set-Content -Path $keysFilepath -Value $keysJSON -Encoding UTF8