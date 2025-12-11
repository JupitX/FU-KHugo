function Parse-JsonElements {
    param(
        [Parameter(Mandatory)]
        $Elements
    )

    $elementObjects = [System.Collections.Generic.List[object]]::new()
    $current = $null

    foreach ($element in $Elements) {

        $name  = $element.Name
        $value = $element.Value

        if ($name -eq "filename") {

            if ($current) {
                $elementObjects.Add($current)
            }

            $current = [PSCustomObject]@{
                script = $value
            }
            continue
        }

        $property = ($name -split "\.")[-1]

        $current | Add-Member -NotePropertyName $property -NotePropertyValue $value -Force
    }

    if ($current) {
        $elementObjects.Add($current)
    }

    return $elementObjects
}

function Parse-Key {
    param(
        [Parameter(Mandatory)]
        $Hexadecimal
    )

    $byteCount = $Hexadecimal.Length / 2
    $byteArray = New-Object byte[] ($Hexadecimal.Length / 2)

    for ($counter = 0; $counter -lt $byteCount; $counter++) {
        $byteArray[$counter] = [Convert]::ToByte($hexadecimalKey.Substring($counter * 2, 2), 16)
    }

    return $byteArray
}
