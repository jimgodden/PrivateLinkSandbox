# Define variables for the IIS website and certificate
$siteName = "Default Web Site"
$port = 10001
$certName = "MySelfSignedCert"

# Download and install the PowerShell Core package
Invoke-WebRequest -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.2.1/PowerShell-7.2.1-win-x64.msi -OutFile PowerShell-7.2.1-win-x64.msi
Start-Process msiexec.exe -Wait -ArgumentList '/i PowerShell-7.2.1-win-x64.msi /qn /norestart'

# Add the PowerShell Core executable path to the system PATH environment variable
$envPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$psCorePath = 'C:\Program Files\PowerShell\7'
if ($envPath -notlike "*$psCorePath*") {
    [Environment]::SetEnvironmentVariable('Path', "$envPath;$psCorePath", 'Machine')
}

# Create a self-signed certificate
New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "cert:\LocalMachine\My" `
-FriendlyName $certName

# Open TCP port 10001 on the firewall
New-NetFirewallRule -DisplayName "Allow inbound TCP port 10001" -Direction Inbound -LocalPort $port -Protocol TCP -Action Allow

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/jimgodden/PrivateLinkSandbox/main/scripts/installWireshark.ps1" -OutFile "c:\installWireshark.ps1"

# Install Windows Terminal
Invoke-WebRequest -Uri "https://aka.ms/terminal-download-win" -OutFile "c:\WindowsTerminal.msi"
Start-Process msiexec.exe -Wait -ArgumentList "/i c:\WindowsTerminal.msi /qn"

# Set PowerShell as the default profile
$settings = Get-Content "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json" -Raw | ConvertFrom-Json
$settings.defaultProfile = "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}"
$settings | ConvertTo-Json -Depth 50 | Set-Content "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json"

# Configure Windows Terminal to start automatically
$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
Set-ItemProperty -Path $registryPath -Name "Windows Terminal" -Value "wt.exe"


# Install the IIS server feature
Install-WindowsFeature -Name Web-Server -includeManagementTools

Import-Module WebAdministration

New-WebBinding -Name $siteName -Port $port -Protocol "https"

$SSLCert = Get-ChildItem -Path "cert:\LocalMachine\My" | Where-Object {$_.subject -like 'cn=localhost'}
Set-Location "IIS:\sslbindings"
New-Item "!10001!" -value $SSLCert