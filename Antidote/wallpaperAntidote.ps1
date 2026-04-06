function correctWallpaper {
    param (
        [Parameter()]
        [string]$code,
        [Parameter()]
        [string]$wallpaperDirectory
    )

    Write-Host "`t[+] Windows image - " -NoNewline
    Write-Host "FIXING" -ForegroundColor cyan
    
    if (Test-Path "$wallpaperDirectory\img0.jpg") {
        $image = "$wallpaperDirectory\img0.jpg"
        Write-Host "`t[+] Windows image - " -NoNewline
        Write-Host "FOUND" -ForegroundColor green

        Add-Type $code 
        [Win32.Wallpaper]::SetWallpaper($image)
        Write-Host "`t[+] Wallpaper changed - " -NoNewline
        Write-Host $image -ForegroundColor green
    } else {
        Write-Host "`t[x] Windows image - " -NoNewline
        Write-Host "IMAGE NOT FOUND" -ForegroundColor red
    }
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