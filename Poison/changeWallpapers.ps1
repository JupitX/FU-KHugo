. $rootScriptDirectory"FuckHugo"\otherFunctionalities.ps1
function deleteWallpaperEngine {
    functionPresentation -text "Deleting Wallpaper Engine"
    function detectSteamFolder {
        informTerminal -category "Drives" -result "DETECTING" -color "cyan" -icon "+"

        $drives = Get-PSDrive -Psprovider FileSystem | Select-Object -Property Name

        if ($drives) {
            informTerminal -category "Drives" -result "FOUND" -color "green" -icon "+"

            foreach ($drive in $drives) {
                informTerminal -category "Deleting Wallpaper Engine" -result "SEARCHING STEAM FOLDER" -color "cyan" -icon "+"
    
                $steamDirectory = Get-ChildItem -Path "$($drive.Name):\" -Exclude Windows -Recurse -Directory -Filter *steamapps* | Select-Object -First 1 -Property FullName -ErrorAction SilentlyContinue
    
                if ($steamDirectory -ne $null) {
                    informTerminal -category "Deleting Wallpaper Engine" -result "FOLDER FOUND IN DRIVE $($drive.Name)" -color "green" -icon "+"
                    return $steamDirectory
                } else {
                    informTerminal -category "Deleting Wallpaper Engine" -result "FOLDER NOT FOUND IN DRIVE $($drive.Name)" -color "yellow" -icon "!"
                    continue
                }
            }
        } else {
            informTerminal -category "Drives" -result "ERROR DETECTING DRIVES" -color "red" -icon "x"
            informTerminal -category "Drives" -result "EXITING" -color "red" -icon "x"
            exit 1
        }
    }

    function removeWallpaperEngineFolder {
        param (
            [Parameter()]
            [string]$steamDirectory,
            [Parameter()]
            [string]$wallpaperEngineFolder
        )

        if ($steamDirectory -ne $null) {
            informTerminal -category "Deleting Wallpaper Engine" -result "FOLDER DETECTED $($steamPath.FullName)" -color "green" -icon "+"

            if (Test-Path $wallpaperEngineFolder) {
                informTerminal -category "Deleting Wallpaper Engine" -result "APP DETECTED" -color "green" -icon "+"
                informTerminal -category "Deleting Wallpaper Engine" -result "DELETING WALLPAPER ENGINE FOLDER" -color "cyan" -icon "+"

                Remove-Item $wallpaperEngineFolder -Recurse -Force

                if (Test-Path $wallpaperEngineFolder) {
                    informTerminal -category "Deleting Wallpaper Engine" -result "ERROR DELETING WALLPAPER ENGINE" -color "red" -icon "x"
                } else {
                    informTerminal -category "Deleting Wallpaper Engine" -result "WALLPAPER ENGINE DELETED SUCCESSFULLY" -color "green" -icon "+"
                }
            } else {
                informTerminal -category "Deleting Wallpaper Engine" -result "APP NOT INSTALLED" -color "red" -icon "x"
            }
        } else {
            informTermianl -category "Deleting Wallpaper Engine" -result "STEAM FOLDER NOT FOUND, MAYBE STEAM NOT INSTALLED" -color "red" -icon "x"
        }

    }

    function closeWallpaperEngineProcess {

        $steamProcess = Get-Process -Name "*wallpaper*","*ui*"

        if ($steamProcess -ne $null) {
            informTerminal -category "Deleting Wallpaper Engine" -result "PROCESS DETECTED" -color "green" -icon "+"
            informTerminal -category "Deleting Wallpaper Engine" -result "ATTEMPTING TO CLOSE PROCESS" -color "cyan" -icon "+"

            $steamProcess | Stop-Process -Force
            $steamProcess | Stop-Process -Force
            $steamProcess | Stop-Process -Force
            
            $steamProcess = Get-Process -Name "*wallpaper*","*ui*"

            if ($steamProcess -ne $null) {
                informTerminal -category "Deleting Wallpaper Engine" -result "ERROR STOPPING PROCESS" -color "red" -icon "x"
            } else {
                informTerminal -category "Deleting Wallpaper Engine" -result "PROCESS STOPPED" -color "green" -icon "+"
            }
        } else {
            informTerminal -category "Deleting Wallpaper Engine" -result "NO PROCESS IS RUNNING" -color "red" -icon "x"
        }
    }

    $steamPath = detectSteamFolder
    $wallpaperEngineFolder = "$($steamPath.Fullname)\common\wallpaper_engine"
    closeWallpaperEngineProcess
    Start-Sleep -Seconds 1
    removeWallpaperEngineFolder -steamDirectory $($steamPath.Fullname) -wallpaperEngineFolder $wallpaperEngineFolder

}

function detectAppropriatedImages {
    param (
        [string]$imagesDirectory
    )

    Add-Type -AssemblyName System.Drawing

    $images = Get-ChildItem -Path $imagesDirectory -File -Filter *.jpg
    $fileList = $images.FullName
    [System.Collections.ArrayList]$appropriateImages = @()

    foreach ($image in $fileList) {
        $loadedImage = [System.Drawing.Image]::FromFile($image)

        if ($($loadedImage.Width) -ge 1920 -and $($loadedImage.Height) -ge 1080) {
            $appropriateImages += ($image)
        }

        $loadedImage.Dispose()
    }

    return $appropriateImages
}

function setWallpaper {
    param (
        [Parameter()]
        [string]$code,
        [Parameter()]
        [string]$directory
    )
    functionPresentation -text "Changing Wallpaper"
    informTerminal -category "Random Image" -result "SELECTING" -color "cyan" -icon "+"

    $wallpapers = detectAppropriatedImages -imagesDirectory $directory
    $randomImage = $($wallpapers | Get-Random)

    if ($randomImage -eq $null) {
        informTerminal -category "Random Image" -result "ERROR SELECTING" -color "red" -icon "x"
    } else {
        informTerminal -category "Random Image" -result "SELECTED" -color "green" -icon "+"
    }

    Add-Type $code 
    [Win32.Wallpaper]::SetWallpaper($randomImage)
    
    informTerminal -category "Wallpaper Changed" -result $randomImage -color "green" -icon "+"
}

function setLockScreen {
    param (
        [string]$directory
    )
    functionPresentation -text "Changing Lock Screen"

    $wallpapers = detectAppropriatedImages -imagesDirectory $directory
    $randomImage = $($wallpapers | Get-Random)

    $registryPath = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

    REG ADD $registryPath /f | Out-Null
    REG ADD $registryPath /v LockScreenImagePath /t REG_SZ /d $randomImage /f | Out-Null
    REG ADD $registryPath /v LockScreenImageUrl /t REG_SZ /d $randomImage /f | Out-Null
    REG ADD $registryPath /v LockScreenImageStatus /t REG_DWORD /d 1 /f | Out-Null
    icacls "$env:SYSTEMDRIVE\ProgramData\Microsoft\Windows\SystemData\" /reset /t /c /l /q

    informTerminal -category "Lock Screen" -result "CHANGED TO $randomImage" -color "green" -icon "+"
}

$wallpaperCode = @' 
        using System.Runtime.InteropServices; 
        namespace Win32 { 
            public class Wallpaper { 
                [DllImport("user32.dll", CharSet=CharSet.Auto)] 
                static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni); 
        
                public static void SetWallpaper(string path) { 
                    SystemParametersInfo(20,0,path,3); 
                }
            }
        }
'@