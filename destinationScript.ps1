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

# Bind the certificate to the IIS website
# $certHashBytes = (Get-Item -Path "Cert:\LocalMachine\My\$thumbprint").GetCertHash()
# $certHash = [System.BitConverter]::ToString($certHashBytes).Replace("-","")
# $certStoreName = "MY"

New-WebBinding -Name $siteName -Port $port -Protocol "https"
# $binding = Get-WebBinding -Name $siteName -Protocol "https"
# $binding.AddSslCertificate($certStoreName, $certHash)
