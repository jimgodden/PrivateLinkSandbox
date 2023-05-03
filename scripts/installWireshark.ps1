$wshell = New-Object -ComObject Wscript.Shell
$answer = $wshell.Popup("Do you want to download Wireshark?",0,"Download Option",32+4)
if ($answer -eq 6) {
    # Install-Module Convert-Etl2Pcapng -Scope CurrentUser -Force
    Write-Host "Downloading Wireshark to capture packets and catch the next occurrance.."
    Invoke-WebRequest -Uri https://2.na.dl.wireshark.org/win64/Wireshark-win64-3.6.13.exe -OutFile Wireshark-win64-3.6.13.exe
    .\Wireshark-win64-3.6.13.exe
    
}
elseif ($answer -eq 7) {
    Write-Host "Good luck!"
}
else {
    Write-Host "Unknown error.  Please download Wireshark manually if desired."
}