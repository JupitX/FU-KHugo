. (Resolve-Path "..\..\paths.ps1")

function Get-JsonElements { 
    param( 
        [Parameter(Mandatory)] 
        $Object, 
        $Prefix = "" 
    ) 

    $elements = @() 

    if ($Object -is [System.Collections.IDictionary]) {

        foreach ($key in $Object.Keys) {
            $fullkey = if ($Prefix) { "$Prefix.$key" } else { $key }
            $elements += Get-JsonElements -Object $Object[$key] -Prefix $fullkey
        }
    }

    elseif ($Object -is [System.Collections.IList]) {

        for ($i = 0; $i -lt $Object.Count; $i++) {
            $item = $Object[$i]
            $fullkey = if ($Prefix) { "$Prefix[$i]" } else { "[$i]" }
            $elements += Get-JsonElements -Object $item -Prefix $fullkey
        }
    }

    elseif ($Object -is [PSObject] -and $Object.PSObject.Properties.Count -gt 0) {

        foreach ($prop in $Object.PSObject.Properties) {
            $fullkey = if ($Prefix) { "$Prefix.$($prop.Name)" } else { $prop.Name }
            $elements += Get-JsonElements -Object $prop.Value -Prefix $fullkey
        }
    }

    else {

        $elements += [PSCustomObject]@{
            Name  = $Prefix
            Value = $Object
        }
    }

    return $elements
}