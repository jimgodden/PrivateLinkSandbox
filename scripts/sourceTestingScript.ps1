$errorLogFile = "c:\errorLogs.txt"
New-Item -Type File -Path $errorLogFile

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
        Add-Content -Path $errorLogFile -Value "Timeout error occurred on ${date}"
        $noError = $false
    }
}
