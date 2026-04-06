if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File $($MyInvocation.MyCommand.Path)"
    Exit
}

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDirectory = Split-Path -Path $scriptPath -Parent
$rootScriptDirectory = Split-Path -Path $scriptDirectory -Parent

. $rootScriptDirectory"FuckHugoAntidote"\wallpaperAntidote.ps1
. $rootScriptDirectory"FuckHugoAntidote"\otherFunctionalities.ps1
. $rootScriptDirectory"FuckHugoAntidote"\settingsAntidote.ps1

function main() {
    $ProgressPreference = 'SilentlyContinue'

    $wallpaperDir = "$env:SYSTEMDRIVE\Windows\Web\Wallpaper\Windows"

    functionPresentation -text "Fixing Wallpaper"
    correctWallpaper -code $wallpaperCode -wallpaperDirectory $wallpaperDir

    functionPresentation -text "Fixing Mouse"
    correctMouse

    functionPresentation -text "Script Ended"

}

main