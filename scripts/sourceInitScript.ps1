# Download and install the PowerShell Core package
Invoke-WebRequest -Uri https://github.com/PowerShell/PowerShell/releases/download/v7.2.1/PowerShell-7.2.1-win-x64.msi -OutFile PowerShell-7.2.1-win-x64.msi
Start-Process msiexec.exe -Wait -ArgumentList '/i PowerShell-7.2.1-win-x64.msi /qn /norestart'

# Add the PowerShell Core executable path to the system PATH environment variable
$envPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$psCorePath = 'C:\Program Files\PowerShell\7'
if ($envPath -notlike "*$psCorePath*") {
    [Environment]::SetEnvironmentVariable('Path', "$envPath;$psCorePath", 'Machine')
}