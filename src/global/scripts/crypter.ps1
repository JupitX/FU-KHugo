. (Resolve-Path "..\functions\parseFunctions.ps1")
. (Resolve-Path "..\functions\getFunctions.ps1")
. (Resolve-Path "..\..\paths.ps1")

$stringsFilepath = "$assetsFolderpath\strings.json"

$stringsContent = Get-Content $stringsFilepath -Raw -Encoding UTF8
$stringsObject = ConvertFrom-Json -InputObject $stringsContent

$keyFiles = (Get-ChildItem -Path $keysFolderpath -Filter *.json).FullName

ForEach ($keyFile in $keyFiles) {
	$keyContent = Get-Content $keyFile -Raw -Encoding UTF8
	$keyContent = ConvertFrom-Json $keyContent

	$hexadecimalKey = $keyContent.Key
	$hexadecimalIV = $keyContent.IV
	$id = $keyFile.Split('\')[-1].Replace('.json','')

	$key = Parse-Key -Hexadecimal $hexadecimalKey
	$iv = Parse-Key -Hexadecimal $hexadecimalIV

	ForEach ($script in $stringsObject.scripts) {

		$elements = Get-JsonElements -Object $script
		$elements = Parse-JsonElements -Elements $elements

		ForEach ($element in $elements) {

			$cipherFileContent = ""
			$cipherFileContent += "#pragma once`n"
			$cipherFileContent += "`n"
			$cipherFileContent += "#include <array>`n"
			$cipherFileContent += "#include <cstdint>`n"
			$cipherFileContent += "`n"
			$cipherFileContent += "namespace ciphertexts {`n"
			$cipherFileContent += "`n"

			$allProperties = $element.PSObject.Properties.Name
			$properties = $allProperties[1 .. ($allProperties.Count - 1)]

			$scriptName = $element.script
			$scriptCleanName = ($scriptName.Split("."))[0]

			$cipherStringScriptNameFolder = "$cipherStringFolderpath\$scriptCleanName"

			if (-not (Test-Path $cipherStringScriptNameFolder)) {
				New-Item -Path $cipherStringFolderpath -Name $scriptCleanName -ItemType "Directory" | Out-Null
			}

			$cipherStringFilepath = "$cipherStringScriptNameFolder\$id.hpp"

			ForEach ($property in $properties) {

				$string = $element.$property

				if (($property -Like '*[[]*') -or ($property -Like '*[]]*')) {
					$property = $property -replace '[\[\]]', ''
				}

				$aes = [System.Security.Cryptography.Aes]::Create()

				$aes.Key = $key
				$aes.IV = $iv
				$aes.Mode = "CBC"
				$aes.Padding = "PKCS7"

				$bytes = [System.Text.Encoding]::UTF8.GetBytes($string)

				$encryptor = $aes.CreateEncryptor()
				$cipherbytes = $encryptor.TransformFinalBlock($bytes, 0, $bytes.Length)
				$hexadecimalCiphertext = ($cipherbytes | ForEach-Object { "0x{0:X2}" -f $_ }) -join ", "

				$cipherFileContent += "`tconstexpr std::array<uint8_t, $($cipherbytes.Length)> $($property.ToUpper()) = {`n"
				$cipherFileContent += "`t`t$hexadecimalCiphertext`n"
				$cipherFileContent += "`t`};`n"
				$cipherFileContent += "`t`n"
			}
		}

		$cipherFileContent += "`}"

		Set-Content -Path $cipherStringFilepath -Value $cipherFileContent -Encoding UTF8
	}
}
