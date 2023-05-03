$wshell = New-Object -ComObject Wscript.Shell
$answer = $wshell.Popup("Do you want to download Wireshark?",0,"Download Option",32+4)
if ($answer -eq 6) {
    # Install-Module Convert-Etl2Pcapng -Scope CurrentUser -Force
    Write-Host "Downloading Wireshark to capture packets and catch the next occurrance.."
    Invoke-WebRequest -Uri https://2.na.dl.wireshark.org/win64/Wireshark-win64-3.6.13.exe -OutFile Wireshark-win64-3.6.13.exe
    .\Wireshark-win64-3.6.13.exe
    
    Write-Host "Setting the Wireshark.exe to Path.."

    $wiresharkPath = "C:\Program Files\Wireshark\Wireshark.exe"
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

    if ($currentPath -notlike "*$wiresharkPath*") {
        $newPath = "$currentPath;$wiresharkPath"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Write-Host "Wireshark has been added to the system's PATH."
    } else {
        Write-Host "Wireshark is already in the system's PATH."
    }

    Write-Host "Please do not press yes to the next prompt until Wireshark is done installing."

    $wshell = New-Object -ComObject Wscript.Shell
    $answer = $wshell.Popup("Do you want to open Wireshark?",0,"Question",32+4)
    if ($answer -eq 6) {
        if ((Test-Path $wiresharkPath)){
            .\Wireshark.exe
        }
        else {
            Write-Host "Wait until Wireshark is done installing.  Once finished you can run `".\Wireshark.exe`" in Powershell to run the program"
        }
        
    }
    elseif ($answer -eq 7) {
        Write-Host "Good luck!"
    }
    else {
        Write-Host "Unknown error.  Please open Wireshark manually if desired."
    }
}
elseif ($answer -eq 7) {
    Write-Host "Good luck!"
}
else {
    Write-Host "Unknown error.  Please download Wireshark manually if desired."
}