# Install Wireshark after it has been verfied that the issue can be reproduced on this machine with the step below

# Invoke-Webrequest until we get an error due to a 10 second timeout
$attempt = 0
$noError = $true
while ($noError) {
    $attempt++
    $date = Get-Date
    Write-Host "Attempt #${attempt} at ${date}"
    try {
        $response = Invoke-WebRequest -uri "https://10.1.0.10:10001/" -SkipCertificateCheck -TimeoutSec 10
        if ($response.StatusCode -eq 200) {
            Write-Host "Success"
        }
    } 
    catch [System.Exception] {
        $date = Get-Date
        Write-Host "Timeout error occurred on ${date}"
        $noError = $false
    }
    #Start-Sleep -Seconds 1
}