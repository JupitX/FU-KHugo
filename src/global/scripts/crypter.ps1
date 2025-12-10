. (Resolve-Path "..\functions\parseFunctions.ps1")
. (Resolve-Path "..\functions\getFunctions.ps1")
. (Resolve-Path "..\..\paths.ps1")

$stringsFilepath = "$assetsFolderpath\strings.json"

$stringsContent = Get-Content $stringsFilepath -Raw -Encoding UTF8
$stringsObject = ConvertFrom-Json -InputObject $stringsContent

$key = Get-Key -Bytes 32
$iv = Get-Key -Bytes 16

$hexKey = Get-HexKey -Key $key
$hexIV = Get-HexKey -Key $iv

ForEach ($script in $stringsObject.scripts) {

	$elements = Get-JsonElements -Object $script
	$elements = Parse-JsonElements -Elements $elements

	ForEach ($element in $elements) {
		$allProperties = $element.PSObject.Properties.Name
		$properties = $allProperties[1 .. ($allProperties.Count - 1)]

		$scriptName = $element.script

		ForEach ($property in $properties) {
			$string = $element.$property

			$aes = [System.Security.Cryptography.Aes]::Create()

			$aes.Key = $key
			$aes.IV = $iv
			$aes.Mode = "CBC"
			$aes.Padding = "PKCS7"

			$bytes = [System.Text.Encoding]::UTF8.GetBytes($string)

			$encryptor = $aes.CreateEncryptor()
			$cipherbytes = $encryptor.TransformFinalBlock($bytes, 0, $bytes.Length)

		}
	}
}