# Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install powershell-core -y
choco install microsoft-windows-terminal -y
choco install python311 -y
# Set the path to add
$newPath = "C:\Python311\python.exe"

# Set the scope of the environment variables to modify
$scope = "Machine" # or "User"

# Get the current path variable
$currentPath = [Environment]::GetEnvironmentVariable("Path", $scope)

# Check if the new path is already in the variable
if ($currentPath -notlike "*$newPath*") {
    # Append the new path to the current path variable
    $newPathString = "$currentPath;$newPath"
    [Environment]::SetEnvironmentVariable("Path", $newPathString, $scope)
    Write-Host "Path added successfully."
} else {
    Write-Host "Path already exists in environment variables."
}

choco install vscode -y
# Set the path to add
$newPath = "C:\Program Files\Microsoft VS Code\code.exe"

# Set the scope of the environment variables to modify
$scope = "Machine" # or "User"

# Get the current path variable
$currentPath = [Environment]::GetEnvironmentVariable("Path", $scope)

# Check if the new path is already in the variable
if ($currentPath -notlike "*$newPath*") {
    # Append the new path to the current path variable
    $newPathString = "$currentPath;$newPath"
    [Environment]::SetEnvironmentVariable("Path", $newPathString, $scope)
    Write-Host "Path added successfully."
} else {
    Write-Host "Path already exists in environment variables."
}


choco install wireshark -y
# Set the path to add
$newPath = "C:\Program Files\Wireshark\Wireshark.exe"

# Set the scope of the environment variables to modify
$scope = "Machine" # or "User"

# Get the current path variable
$currentPath = [Environment]::GetEnvironmentVariable("Path", $scope)

# Check if the new path is already in the variable
if ($currentPath -notlike "*$newPath*") {
    # Append the new path to the current path variable
    $newPathString = "$currentPath;$newPath"
    [Environment]::SetEnvironmentVariable("Path", $newPathString, $scope)
    Write-Host "Path added successfully."
} else {
    Write-Host "Path already exists in environment variables."
}



# Set the path to add
$newPath = "C:\PsTools\"

# Set the scope of the environment variables to modify
$scope = "Machine" # or "User"

# Get the current path variable
$currentPath = [Environment]::GetEnvironmentVariable("Path", $scope)

# Check if the new path is already in the variable
if ($currentPath -notlike "*$newPath*") {
    # Append the new path to the current path variable
    $newPathString = "$currentPath;$newPath"
    [Environment]::SetEnvironmentVariable("Path", $newPathString, $scope)
    Write-Host "Path added successfully."
} else {
    Write-Host "Path already exists in environment variables."
}

Invoke-WebRequest -Uri "https://npcap.com/dist/npcap-1.75.exe" -OutFile "c:\npcap-1.75.exe"
c:\npcap-1.75.exe


Invoke-WebRequest -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile "c:\Microsoft.VCLibs.x64.14.00.Desktop.appx"
Add-AppxPackage "c:\Microsoft.VCLibs.x64.14.00.Desktop.appx"

Invoke-WebRequest -Uri "https://github.com/microsoft/terminal/releases/download/v1.16.10261.0/Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle" -OutFile "c:\Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle"
Add-AppxPackage "c:\Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle"



