# Define variables for the IIS website and certificate
$siteName = "Default Web Site"
$port = 10001
$certName = "MySelfSignedCert"

# Create a self-signed certificate
New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation "cert:\LocalMachine\My" `
-FriendlyName $certName

# Open TCP port 10001 on the firewall
New-NetFirewallRule -DisplayName "Allow inbound TCP port 10001" -Direction Inbound -LocalPort 10001 -Protocol TCP -Action Allow

# Install the IIS server feature
Install-WindowsFeature -Name Web-Server -includeManagementTools

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module WebAdministration -Force
Import-Module WebAdministration

New-WebBinding -Name $siteName -Port $port -Protocol "https"

$SSLCert = Get-ChildItem –Path "cert:\LocalMachine\My" | Where-Object {$_.subject -like 'cn=localhost'}
Set-Location "IIS:\sslbindings"
New-Item "!10001!" -value $SSLCert