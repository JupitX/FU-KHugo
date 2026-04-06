function correctDefaultSound {
    
}

function correctMouse {
    function updateRegistry {

        Write-Host "`t[+] Mouse Scheme - " -NoNewline
        Write-Host "FIXING" -ForegroundColor cyan

        $cursorsDirectory = "$env:SYSTEMDRIVE\Windows\Cursors"

        $regConnect = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]"CurrentUser","$env:COMPUTERNAME")
        $regCursors = $regConnect.OpenSubKey("Control Panel\Cursors",$true)

        $regCursors.SetValue("","Windows Black")
        $regCursors.SetValue("AppStarting", "$cursorsDirectory\wait_m.cur")
        $regCursors.SetValue("Arrow", "$cursorsDirectory\aero_arrow.cur")
        $regCursors.SetValue("Crosshair", "$cursorsDirectory\cross_l.cur")
        $regCursors.SetValue("Hand", "$cursorsDirectory\aero_link.cur")
        $regCursors.SetValue("Help", "$cursorsDirectory\help_m.cur")
        $regCursors.SetValue("IBeam", "$cursorsDirectory\beam_r.cur")
        $regCursors.SetValue("No", "$cursorsDirectory\no_r.cur")
        $regCursors.SetValue("NWPen", "$cursorsDirectory\pen_m.cur")
        $regCursors.SetValue("SizeAll", "$cursorsDirectory\aero_move.cur")
        $regCursors.SetValue("SizeNESW","$cursorsDirectory\aero_nesw.cur")
        $regCursors.SetValue("SizeNS", "$cursorsDirectory\aero_ns.cur")
        $regCursors.SetValue("SizeNWSE", "$cursorsDirectory\aero_nwse.cur")
        $regCursors.SetValue("SizeWE", "$cursorsDirectory\aero_ew.cur")
        $regCursors.SetValue("UpArrow", "$cursorsDirectory\aero_up.cur")
        $regCursors.SetValue("Wait", "$cursorsDirectory\busy_m.cur")
        $regCursors.Close()
        $regConnect.Close()

        Write-Host "`t[+] Mouse Scheme - " -NoNewline
        Write-Host "CHANGED" -ForegroundColor green
    }
    
    function applyChanges {
        param (
            [string]$code
        )

        $cursorRefresh = Add-Type -MemberDefinition $code -Name WinAPICall -Namespace SystemMouseAntidote -PassThru
        $cursorRefresh::SystemParametersInfo(0x0057,0,$null,0) | Out-Null

        Write-Host "`t[+] Mouse Scheme - " -NoNewline
        Write-Host "REGISTRY APPLIED" -ForegroundColor green
    }

    updateRegistry
    applyChanges -code $applyChangesCode
}

$applyChangesCode = @'
    [DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
    public static extern bool SystemParametersInfo( uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
'@