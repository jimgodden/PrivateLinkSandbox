Install-Module Convert-Etl2Pcapng -Scope CurrentUser -Force

# $wshell = New-Object -ComObject Wscript.Shell
# $answer = $wshell.Popup("Do you want to download Wireshark?",0,"Download Option",32+4)
# if ($answer -eq 6) {
#     Install-Module Convert-Etl2Pcapng -Scope CurrentUser -Force
#     Write-Host "Downloading Wireshark to capture packets and catch the next occurrance.."
#     Invoke-WebRequest -Uri https://2.na.dl.wireshark.org/win64/Wireshark-win64-3.6.13.exe -OutFile Wireshark-win64-3.6.13.exe
#     .\Wireshark-win64-3.6.13.exe
    
# }
# elseif ($answer -eq 7) {
#     Write-Host "Good luck!"
# }
# else {
#     Write-Host "Unknown error.  Please download Wireshark manually if desired."
# }

$errorLogFile = "c:\errorLogs.txt"
New-Item -Type File -Path $errorLogFile


$attempt = 0
while ($true) {
    # Starts a netsh trace to capture any errors
    $Logfile = "C:\Trace_$(Get-Date -Format HH-mm_dd-MM-yyyy).etl"
    netsh trace start capture=yes report=disabled filemode=single maxSize=2048 PacketTruncateBytes=100 tracefile=$Logfile

    $noError = $true
    
    # Invoke-Webrequest until we get an error due to a 10 second timeout
    while ($noError) {
        $attempt++
        $date = Get-Date
        Write-Host "Attempt #${attempt} at ${date}"
        try {
            # 10.1.2.4 is the IP of the Private Endpoint
            $response = Invoke-WebRequest -uri "https://10.1.2.4:10001/" -SkipCertificateCheck -TimeoutSec 10
            if ($response.StatusCode -eq 200) {
                Write-Host "Success"
            }
        } 
        catch [System.Exception] {
            $date = Get-Date
            Write-Host "Timeout error occurred on ${date}"
            Add-Content -Path $errorLogFile -Value "Timeout error occurred on ${date} in ${LogFile}"
            $noError = $false

            # Leaving extra time for the traces to catch extra packets
            Start-Sleep -Seconds 15
            netsh trace stop
            Convert-Etl2Pcapng $Logfile
        }
    }
}