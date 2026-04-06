. $rootScriptDirectory"FuckHugo"\otherFunctionalities.ps1

function changeDefaultSound {
    param (
        [string]$audiosDirectory
    )
    functionPresentation -text "Changing Windows Sound"
    $regPaths = Get-ChildItem -Path "HKCU:\AppEvents\Schemes\Apps\.Default" | Select-Object -ExpandProperty Name
    $audios = Get-ChildItem -Path $audiosDirectory -File -Filter *.wav

    if ($audios -eq $null) {
        informTerminal -category "Windows Audio" -result "ERROR GETTING AUDIOS" -color "red" -icon "x"
    } else {
        $audioList = $audios.FullName
        $wshell = New-Object -ComObject WScript.Shell
    
        foreach ($regPath in $regPaths) {
            $randomAudio = $($audioList | Get-Random)
    
            $wshell.RegWrite("$regPath\.Current\", $randomAudio, "REG_SZ")
    
            informTerminal -category "Windows Audio" -result "Applied $($randomAudio.Split('\') | Select-Object -Last 1)" -color "green" -icon "+"
        }
    }
}

function changeMouseScheme {
    param (
        [string]$imagesDirectory
    )
    functionPresentation -text "Changing Mouse Scheme"
    function updateRegistry {
        param (
            [string]$directory
        )

        informTerminal -category "Mouse Schema" -result "SELECTING" -color "cyan" -icon "+"

        $cursorsList = Get-ChildItem -Path $directory -File -Filter *.ani

        $randomCursor = $($cursorsList | Get-Random)

        if ($randomCursor -eq $null) {
            informTerminal -category "Mouse Schema" -result "ERROR SELECTING RANDOM CURSOR" -color "red" -icon "x"
            informTerminal -category "Mouse Schema" -result "EXITING" -color "red" -icon "x"
            exit 1
        } else {
            informTerminal -category "Mouse Schema" -result "SCHEMA SELECTED $randomCursor" -color "green" -icon "+"
        }

        $cursorPath = "$imagesDirectory\$randomCursor"

        $regConnect = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"CurrentUser","$env:COMPUTERNAME")
        $regCursors = $regConnect.OpenSubKey("Control Panel\Cursors",$true)

        $regCursors.SetValue("","Windows Black")
        $regCursors.SetValue("AppStarting", $cursorPath)
        $regCursors.SetValue("Arrow", $cursorPath)
        $regCursors.SetValue("Crosshair", $cursorPath)
        $regCursors.SetValue("Hand", $cursorPath)
        $regCursors.SetValue("Help", $cursorPath)
        $regCursors.SetValue("IBeam", $cursorPath)
        $regCursors.SetValue("No", $cursorPath)
        $regCursors.SetValue("NWPen", $cursorPath)
        $regCursors.SetValue("SizeAll", $cursorPath)
        $regCursors.SetValue("SizeNESW",$cursorPath)
        $regCursors.SetValue("SizeNS", $cursorPath)
        $regCursors.SetValue("SizeNWSE", $cursorPath)
        $regCursors.SetValue("SizeWE", $cursorPath)
        $regCursors.SetValue("UpArrow", $cursorPath)
        $regCursors.SetValue("Wait", $cursorPath)
        $regCursors.Close()
        $regConnect.Close()

        informTerminal -category "Mouse Schema" -result "CHANGED" -color "green" -icon "+"
    }
    
    function applyChanges {
        param (
            [string]$code
        )

        $cursorRefresh = Add-Type -MemberDefinition $code -Name WinAPICall -Namespace SystemMouseInfo -PassThru
        $cursorRefresh::SystemParametersInfo(0x0057,0,$null,0) | Out-Null

        informTerminal -category "Mouse Schema" -result "REGISTRY TABLE APPLIED" -color "green" -icon "+"
    }

    updateRegistry -directory $imagesDirectory
    applyChanges -code $applyChangesCode

}

$applyChangesCode = @'
    [DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
    public static extern bool SystemParametersInfo( uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
'@